// src/treatments/treatments.service.ts
import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Treatment } from './entities/treatment.entity';
import { TreatmentProduct } from './entities/treatment-product.entity';
import { CreateTreatmentDto, ChemicalProductDto } from './dto/create-treatment.dto';
import { UpdateTreatmentDto } from './dto/update-treatment.dto';
import { CompatibilityService } from './compatibility.service';
import { InventoryTransactionsService } from '../inventory/inventory-transactions.service';
import { ProductInventory } from '../inventory/entities/product-inventory.entity';

@Injectable()
export class TreatmentsService {
  constructor(
    @InjectRepository(Treatment)
    private treatmentsRepository: Repository<Treatment>,
    @InjectRepository(TreatmentProduct)
    private treatmentProductRepository: Repository<TreatmentProduct>,
    @InjectRepository(ProductInventory)
    private inventoryRepository: Repository<ProductInventory>,
    private compatibilityService: CompatibilityService,
    private inventoryTransactionsService: InventoryTransactionsService,
  ) {}

  async create(createTreatmentDto: CreateTreatmentDto): Promise<Treatment> {
    console.log('=== CREATE TREATMENT ===');
    console.log('Chemical products count:', createTreatmentDto.chemicalProducts?.length);
    
    // Проверка совместимости для баковой смеси
    if (createTreatmentDto.isTankMix && createTreatmentDto.chemicalProducts?.length > 1) {
      const productsWithTypes = await Promise.all(
        createTreatmentDto.chemicalProducts.map(async (chemical) => {
          const inventoryItem = await this.inventoryRepository.findOne({
            where: { id: chemical.productId },
          });
          return {
            productId: chemical.productId,
            ratePerHa: chemical.ratePerHa,
            productType: inventoryItem?.type || 'unknown',
          };
        })
      );
      
      const compatibility = this.compatibilityService.checkTankMixCompatibility(productsWithTypes);
      
      createTreatmentDto.hasCompatibilityIssues = !compatibility.isCompatible;
      createTreatmentDto.compatibilityWarnings = [...compatibility.errors, ...compatibility.warnings].join('; ');
    }

    // ✅ ПРОВЕРКА ОСТАТКОВ ПЕРЕД СОЗДАНИЕМ (БЕЗ ПЕРЕНОСОВ СТРОК)
    const area = createTreatmentDto.area;
    const errors: string[] = [];

    for (const chemical of createTreatmentDto.chemicalProducts) {
      const currentBalance = await this.inventoryTransactionsService.getCurrentBalance(chemical.productId);
      const requiredQuantity = chemical.ratePerHa * area;
      
      if (currentBalance < requiredQuantity) {
        const product = await this.inventoryRepository.findOne({
          where: { id: chemical.productId }
        });
        const productName = product?.name || `ID:${chemical.productId}`;
        errors.push(`${productName}: требуется ${requiredQuantity} ${chemical.unit}, доступно ${currentBalance} ${product?.unit || ''}`);
      }
    }
    
    if (errors.length > 0) {
      // ОДНА СТРОКА БЕЗ ПЕРЕНОСОВ
      const errorMessage = `Недостаточно препаратов на складе: ${errors.join(', ')}`;
      console.error(errorMessage);
      throw new BadRequestException(errorMessage);
    }

    // 1. Создаём обработку
    const { chemicalProducts, ...treatmentData } = createTreatmentDto;
    const treatment = this.treatmentsRepository.create({
      ...treatmentData,
      completed: false,
    });
    const savedTreatment = await this.treatmentsRepository.save(treatment);
    console.log('Treatment saved, ID:', savedTreatment.id);

    // 2. Сохраняем продукты обработки
    if (chemicalProducts && chemicalProducts.length > 0) {
      const products = chemicalProducts.map(chemical => 
        this.treatmentProductRepository.create({
          productId: chemical.productId,
          ratePerHa: chemical.ratePerHa,
          unit: chemical.unit as 'л/га' | 'кг/га',
          treatmentId: savedTreatment.id,
        })
      );
      await this.treatmentProductRepository.save(products);
      console.log('Chemical products saved:', products.length);
    }

    // 3. Загружаем обработку с продуктами
    const treatmentWithProducts = await this.treatmentsRepository.findOne({
      where: { id: savedTreatment.id },
      relations: ['chemicalProducts', 'chemicalProducts.product']
    });

    if (!treatmentWithProducts) {
      throw new NotFoundException(`Не удалось загрузить созданную обработку`);
    }

    // 4. Списываем препараты со склада
    await this.deductInventoryForTreatment(treatmentWithProducts);

    console.log('Treatment created successfully, ID:', savedTreatment.id);
    return treatmentWithProducts;
  }

  private async deductInventoryForTreatment(treatment: Treatment): Promise<void> {
    console.log('=== DEDUCT INVENTORY FOR TREATMENT ===');
    console.log('Treatment ID:', treatment.id);
    console.log('Area:', treatment.area);
    console.log('Chemical products count:', treatment.chemicalProducts?.length);
    
    if (!treatment.chemicalProducts || treatment.chemicalProducts.length === 0) {
      console.log('No chemical products to deduct');
      return;
    }

    const area = typeof treatment.area === 'string' ? parseFloat(treatment.area) : Number(treatment.area);
    
    for (let i = 0; i < treatment.chemicalProducts.length; i++) {
      const product = treatment.chemicalProducts[i];
      
      const ratePerHa = typeof product.ratePerHa === 'string' ? parseFloat(product.ratePerHa) : Number(product.ratePerHa);
      const requiredQuantity = ratePerHa * area;
      
      console.log(`Processing product ${i + 1}/${treatment.chemicalProducts.length}:`);
      console.log(`  Product ID: ${product.productId}`);
      console.log(`  Required quantity: ${requiredQuantity}`);
      
      if (isNaN(requiredQuantity) || requiredQuantity <= 0) {
        console.error(`Invalid quantity for product ${product.productId}: ${requiredQuantity}`);
        continue;
      }
      
      const inventoryProduct = await this.inventoryRepository.findOne({
        where: { id: product.productId }
      });
      
      const productName = inventoryProduct?.name || `ID:${product.productId}`;
      
      console.log(`   Deducting: ${productName} - ${requiredQuantity} ${product.unit}`);

      try {
        await this.inventoryTransactionsService.deduct({
          productId: product.productId,
          quantity: requiredQuantity,
          referenceType: 'TREATMENT',
          referenceId: treatment.id,
          description: `Создание обработки #${treatment.id}: ${productName} - ${treatment.culture}, ${area} га, норма ${ratePerHa} ${product.unit}`,
        });
        console.log(`   Deduct successful for ${productName}`);
      } catch (error) {
        const errorMessage = error instanceof Error ? error.message : 'Unknown error';
        console.error(`   Deduct failed for ${productName}:`, errorMessage);
      }
    }
    
    console.log('Inventory deduction completed');
  }

  private async returnInventoryForTreatment(treatment: Treatment): Promise<void> {
    console.log('=== RETURN INVENTORY FOR TREATMENT ===');
    console.log('Treatment ID:', treatment.id);
    console.log('Area:', treatment.area);
    console.log('Chemical products count:', treatment.chemicalProducts?.length);
    
    if (!treatment.chemicalProducts || treatment.chemicalProducts.length === 0) {
      console.log('No chemical products to return');
      return;
    }

    const area = typeof treatment.area === 'string' ? parseFloat(treatment.area) : Number(treatment.area);
    
    for (let i = 0; i < treatment.chemicalProducts.length; i++) {
      const product = treatment.chemicalProducts[i];
      
      const ratePerHa = typeof product.ratePerHa === 'string' ? parseFloat(product.ratePerHa) : Number(product.ratePerHa);
      const returnedQuantity = ratePerHa * area;
      
      console.log(`Processing product ${i + 1}/${treatment.chemicalProducts.length}:`);
      console.log(`  Product ID: ${product.productId}`);
      console.log(`  Return quantity: ${returnedQuantity}`);
      
      if (isNaN(returnedQuantity) || returnedQuantity <= 0) {
        console.error(`Invalid quantity for product ${product.productId}: ${returnedQuantity}`);
        continue;
      }
      
      const inventoryProduct = await this.inventoryRepository.findOne({
        where: { id: product.productId }
      });
      
      const productName = inventoryProduct?.name || `ID:${product.productId}`;
      
      console.log(`   Returning: ${productName} - ${returnedQuantity} ${product.unit}`);

      try {
        await this.inventoryTransactionsService.manualIn(
          product.productId,
          returnedQuantity,
          `Удаление обработки #${treatment.id}: ${productName} - ${treatment.culture}, ${area} га, норма ${ratePerHa} ${product.unit}`
        );
        console.log(`   Return successful for ${productName}`);
      } catch (error) {
        const errorMessage = error instanceof Error ? error.message : 'Unknown error';
        console.error(`   Return failed for ${productName}:`, errorMessage);
      }
    }
    
    console.log('Inventory return completed');
  }

  async findAll(): Promise<Treatment[]> {
    return await this.treatmentsRepository.find({
      relations: ['chemicalProducts', 'chemicalProducts.product'],
      order: { createdAt: 'DESC' }
    });
  }

  async findOne(id: number): Promise<Treatment> {
    const treatment = await this.treatmentsRepository.findOne({
      where: { id },
      relations: ['chemicalProducts', 'chemicalProducts.product']
    });
    
    if (!treatment) {
      throw new NotFoundException(`Обработка с ID ${id} не найдена`);
    }
    
    return treatment;
  }

  async update(id: number, updateTreatmentDto: UpdateTreatmentDto): Promise<Treatment> {
    console.log('=== UPDATE TREATMENT ===');
    console.log('Treatment ID:', id);
    
    const treatment = await this.findOne(id);
    
    const needsInventoryRecalculation = 
      updateTreatmentDto.chemicalProducts || 
      (updateTreatmentDto.area !== undefined && updateTreatmentDto.area !== treatment.area);
    
    if (needsInventoryRecalculation) {
      // Возвращаем старые препараты на склад
      await this.returnInventoryForTreatment(treatment);
      
      // Обновляем химические продукты
      if (updateTreatmentDto.chemicalProducts) {
        await this.treatmentProductRepository.delete({ treatmentId: id });
        
        const products = updateTreatmentDto.chemicalProducts.map(chemical => 
          this.treatmentProductRepository.create({
            productId: chemical.productId,
            ratePerHa: chemical.ratePerHa,
            unit: chemical.unit as 'л/га' | 'кг/га',
            treatmentId: id,
          })
        );
        
        await this.treatmentProductRepository.save(products);
        treatment.chemicalProducts = products;
      }
      
      // Обновляем остальные поля
      const { chemicalProducts, ...updateData } = updateTreatmentDto;
      Object.assign(treatment, updateData);
      
      const savedTreatment = await this.treatmentsRepository.save(treatment);
      
      // Загружаем обновлённую обработку с продуктами
      const updatedTreatment = await this.findOne(id);
      
      // Списываем новые препараты
      await this.deductInventoryForTreatment(updatedTreatment);
      
      console.log('Treatment updated with inventory adjustment, ID:', savedTreatment.id);
      return updatedTreatment;
    }
    
    // Простое обновление без изменения остатков
    const { chemicalProducts, ...updateData } = updateTreatmentDto;
    Object.assign(treatment, updateData);
    
    const savedTreatment = await this.treatmentsRepository.save(treatment);
    console.log('Treatment updated successfully, ID:', savedTreatment.id);
    return savedTreatment;
  }

  async remove(id: number): Promise<void> {
    console.log('=== DELETE TREATMENT ===');
    console.log('Treatment ID:', id);
    
    const treatment = await this.findOne(id);
    
    if (!treatment) {
      throw new NotFoundException(`Обработка с ID ${id} не найдена`);
    }
    
    console.log('Treatment found, chemical products:', treatment.chemicalProducts?.length);
    
    // ✅ ВОЗВРАЩАЕМ ПРЕПАРАТЫ НА СКЛАД
    try {
      await this.returnInventoryForTreatment(treatment);
    } catch (error) {
      const errorMessage = error instanceof Error ? error.message : 'Unknown error';
      console.error('Error returning inventory:', errorMessage);
    }
    
    // Сначала удаляем связанные продукты
    console.log('Deleting treatment products...');
    await this.treatmentProductRepository.delete({ treatmentId: id });
    
    // Затем удаляем саму обработку
    console.log('Deleting treatment...');
    await this.treatmentsRepository.remove(treatment);
    
    console.log('Treatment deleted successfully, ID:', id);
  }

  async markAsCompleted(id: number): Promise<Treatment> {
    console.log('=== MARK AS COMPLETED ===');
    console.log('Treatment ID:', id);
    
    const treatment = await this.findOne(id);

    if (treatment.completed) {
      throw new BadRequestException(`Обработка уже выполнена`);
    }

    treatment.completed = true;
    treatment.actualDate = new Date();
    
    const savedTreatment = await this.treatmentsRepository.save(treatment);
    console.log('Treatment marked as completed, ID:', savedTreatment.id);
    return savedTreatment;
  }

  async unmarkAsCompleted(id: number): Promise<Treatment> {
    console.log('=== UNMARK AS COMPLETED ===');
    console.log('Treatment ID:', id);
    
    const treatment = await this.findOne(id);

    if (!treatment.completed) {
      throw new BadRequestException(`Обработка не была выполнена`);
    }

    treatment.completed = false;
    treatment.actualDate = null;
    
    const savedTreatment = await this.treatmentsRepository.save(treatment);
    console.log('Treatment unmarked as completed, ID:', savedTreatment.id);
    return savedTreatment;
  }

  async checkCompatibility(id: number): Promise<any> {
    console.log('=== CHECK COMPATIBILITY ===');
    console.log('Treatment ID:', id);
    
    const treatment = await this.findOne(id);
    
    if (!treatment.isTankMix || !treatment.chemicalProducts || treatment.chemicalProducts.length <= 1) {
      return { isCompatible: true, warnings: [], errors: [] };
    }

    const productsWithTypes = treatment.chemicalProducts.map(product => ({
      productId: product.productId,
      ratePerHa: product.ratePerHa,
      productType: product.product?.type || 'unknown',
    }));

    const compatibility = this.compatibilityService.checkTankMixCompatibility(productsWithTypes);

    treatment.hasCompatibilityIssues = !compatibility.isCompatible;
    treatment.compatibilityWarnings = [...compatibility.errors, ...compatibility.warnings].join('; ');
    await this.treatmentsRepository.save(treatment);

    return compatibility;
  }
}