import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ProductInventory } from './entities/product-inventory.entity';
import { InventoryTransaction } from './entities/inventory-transaction.entity';
import { CreateInventoryDto } from './dto/create-inventory.dto';
import { UpdateInventoryDto } from './dto/update-inventory.dto';
import { InventoryTransactionsService } from './inventory-transactions.service';

@Injectable()
export class InventoryService {
  constructor(
    @InjectRepository(ProductInventory)
    private inventoryRepository: Repository<ProductInventory>,
    @InjectRepository(InventoryTransaction)
    private transactionRepository: Repository<InventoryTransaction>,
    private inventoryTransactionsService: InventoryTransactionsService,
  ) {}

  async findAll(): Promise<any[]> {
    const products = await this.inventoryRepository.find({
      order: { name: 'ASC' }
    });
    
    const result = [];
    for (const product of products) {
      const balance = await this.inventoryTransactionsService.getCurrentBalance(product.id);
      result.push({
        ...product,
        quantity: balance,
        currentBalance: balance,
      });
    }
    
    return result;
  }

  async findOne(id: number): Promise<any> {
    const product = await this.inventoryRepository.findOne({
      where: { id }
    });
    
    if (!product) {
      throw new NotFoundException(`Товар с ID ${id} не найден`);
    }
    
    const balance = await this.inventoryTransactionsService.getCurrentBalance(id);
    
    return {
      ...product,
      quantity: balance,
      currentBalance: balance,
    };
  }

  async create(createInventoryDto: CreateInventoryDto): Promise<ProductInventory> {
    const product = this.inventoryRepository.create({
      name: createInventoryDto.name,
      type: createInventoryDto.type,
      unit: createInventoryDto.unit,
      notes: createInventoryDto.notes,
    });
    
    const savedProduct = await this.inventoryRepository.save(product);
    
    // Создаём начальную транзакцию IN с указанным количеством
    if (createInventoryDto.quantity > 0) {
      await this.transactionRepository.save({
        productId: savedProduct.id,
        type: 'IN',
        quantity: createInventoryDto.quantity,
        balanceAfter: createInventoryDto.quantity,
        referenceType: 'MANUAL_IN',
        description: `Начальный остаток при создании: ${createInventoryDto.quantity} ${createInventoryDto.unit}`,
      });
    }
    
    return savedProduct;
  }

  async update(id: number, updateInventoryDto: UpdateInventoryDto): Promise<any> {
    const product = await this.inventoryRepository.findOne({ where: { id } });
    if (!product) {
      throw new NotFoundException(`Товар с ID ${id} не найден`);
    }
    
    // Обновляем только основные поля (без quantity)
    if (updateInventoryDto.name !== undefined) product.name = updateInventoryDto.name;
    if (updateInventoryDto.type !== undefined) product.type = updateInventoryDto.type;
    if (updateInventoryDto.unit !== undefined) product.unit = updateInventoryDto.unit;
    if (updateInventoryDto.notes !== undefined) product.notes = updateInventoryDto.notes;
    
    const updatedProduct = await this.inventoryRepository.save(product);
    const balance = await this.inventoryTransactionsService.getCurrentBalance(id);
    
    return {
      ...updatedProduct,
      quantity: balance,
      currentBalance: balance,
    };
  }

  async remove(id: number): Promise<void> {
    // Сначала удаляем связанные транзакции
    await this.transactionRepository.delete({ productId: id });
    // Затем удаляем продукт
    const result = await this.inventoryRepository.delete(id);
    if (result.affected === 0) {
      throw new NotFoundException(`Товар с ID ${id} не найден`);
    }
  }

  async findByType(type: string): Promise<any[]> {
    const products = await this.inventoryRepository.find({
      where: { type },
      order: { name: 'ASC' }
    });
    
    const result = [];
    for (const product of products) {
      const balance = await this.inventoryTransactionsService.getCurrentBalance(product.id);
      result.push({
        ...product,
        quantity: balance,
        currentBalance: balance,
      });
    }
    
    return result;
  }

  async getLowStock(threshold: number = 5): Promise<any[]> {
    const products = await this.inventoryRepository.find();
    const lowStockProducts = [];

    for (const product of products) {
      const balance = await this.inventoryTransactionsService.getCurrentBalance(product.id);
      if (balance <= threshold && balance > 0) {
        lowStockProducts.push({
          ...product,
          quantity: balance,
          currentBalance: balance,
        });
      }
    }

    return lowStockProducts.sort((a, b) => a.currentBalance - b.currentBalance);
  }
}