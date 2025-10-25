import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ProductInventory } from './entities/product-inventory.entity';
import { CreateInventoryDto } from './dto/create-inventory.dto';
import { UpdateInventoryDto } from './dto/update-inventory.dto';

@Injectable()
export class InventoryService {
  constructor(
    @InjectRepository(ProductInventory)
    private inventoryRepository: Repository<ProductInventory>,
  ) {}

  async findAll(): Promise<ProductInventory[]> {
    return this.inventoryRepository.find({
      order: { updatedAt: 'DESC' }
    });
  }

  async findOne(id: number): Promise<ProductInventory> {
    const product = await this.inventoryRepository.findOne({
      where: { id }
    });
    
    if (!product) {
      throw new NotFoundException(`Product with ID ${id} not found`);
    }
    
    return product;
  }

  async create(createInventoryDto: CreateInventoryDto): Promise<ProductInventory> {
    const product = this.inventoryRepository.create(createInventoryDto);
    return await this.inventoryRepository.save(product);
  }

  async update(id: number, updateInventoryDto: UpdateInventoryDto): Promise<ProductInventory> {
    const product = await this.findOne(id);
    Object.assign(product, updateInventoryDto);
    return await this.inventoryRepository.save(product);
  }

  async remove(id: number): Promise<void> {
    const result = await this.inventoryRepository.delete(id);
    if (result.affected === 0) {
      throw new NotFoundException(`Product with ID ${id} not found`);
    }
  }

  async updateQuantity(id: number, quantity: number): Promise<ProductInventory> {
    const product = await this.findOne(id);
    product.quantity = quantity;
    return await this.inventoryRepository.save(product);
  }

  async findByType(type: string): Promise<ProductInventory[]> {
    return this.inventoryRepository.find({
      where: { type },
      order: { name: 'ASC' }
    });
  }

  async getLowStock(threshold: number = 5): Promise<ProductInventory[]> {
    return this.inventoryRepository
      .createQueryBuilder('product')
      .where('product.quantity <= :threshold', { threshold })
      .orderBy('product.quantity', 'ASC')
      .getMany();
  }
}