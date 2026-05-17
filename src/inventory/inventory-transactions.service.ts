// src/inventory/inventory-transactions.service.ts
import { Injectable, BadRequestException, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { InventoryTransaction } from './entities/inventory-transaction.entity';
import { ProductInventory } from './entities/product-inventory.entity';

@Injectable()
export class InventoryTransactionsService {
  constructor(
    @InjectRepository(InventoryTransaction)
    private transactionRepository: Repository<InventoryTransaction>,
    @InjectRepository(ProductInventory)
    private inventoryRepository: Repository<ProductInventory>,
  ) {}

  async getCurrentBalance(productId: number): Promise<number> {
    const lastTransaction = await this.transactionRepository.findOne({
      where: { productId },
      order: { createdAt: 'DESC', id: 'DESC' },
    });
    
    // Важно: возвращаем число, а не строку
    const balance = lastTransaction?.balanceAfter ?? 0;
    return typeof balance === 'string' ? parseFloat(balance) : Number(balance);
  }

  async getTransactionHistory(productId: number): Promise<InventoryTransaction[]> {
    return this.transactionRepository.find({
      where: { productId },
      relations: ['product'],
      order: { createdAt: 'DESC', id: 'DESC' },
    });
  }

  async getAllTransactions(): Promise<InventoryTransaction[]> {
    return this.transactionRepository.find({
      relations: ['product'],
      order: { createdAt: 'DESC' }
    });
  }

  async recalculateBalance(productId: number): Promise<void> {
    const transactions = await this.transactionRepository.find({
      where: { productId },
      order: { createdAt: 'ASC', id: 'ASC' },
    });
    
    let runningBalance = 0;
    
    for (const tx of transactions) {
      const numQuantity = typeof tx.quantity === 'string' ? parseFloat(tx.quantity) : Number(tx.quantity);
      
      if (tx.type === 'IN') {
        runningBalance = runningBalance + numQuantity;
      } else if (tx.type === 'OUT') {
        runningBalance = runningBalance - numQuantity;
      } else if (tx.type === 'ADJUSTMENT') {
        runningBalance = numQuantity;
      }
      
      // Обновляем balanceAfter только если он отличается
      const currentBalanceAfter = typeof tx.balanceAfter === 'string' ? parseFloat(tx.balanceAfter) : Number(tx.balanceAfter);
      if (currentBalanceAfter !== runningBalance) {
        await this.transactionRepository.update(tx.id, { balanceAfter: runningBalance });
      }
    }
  }

  async manualIn(productId: number, quantity: number, description?: string): Promise<InventoryTransaction> {
    console.log('=== MANUAL IN ===');
    console.log('Product ID:', productId);
    console.log('Quantity:', quantity);
    
    const numQuantity = Number(quantity);
    if (isNaN(numQuantity) || numQuantity <= 0) {
      throw new BadRequestException('Количество должно быть больше 0');
    }

    const product = await this.inventoryRepository.findOne({ where: { id: productId } });
    if (!product) {
      throw new NotFoundException(`Товар с ID ${productId} не найден`);
    }

    const currentBalance = await this.getCurrentBalance(productId);
    console.log('Current balance:', currentBalance);
    
    const newBalance = currentBalance + numQuantity;
    console.log('New balance:', newBalance);

    const transaction = this.transactionRepository.create({
      productId,
      type: 'IN',
      quantity: numQuantity,
      balanceAfter: newBalance,
      referenceType: 'MANUAL_IN',
      description: description || `Ручной приход: +${numQuantity} ${product.unit}`,
    });

    const saved = await this.transactionRepository.save(transaction);
    console.log('Transaction saved, ID:', saved.id);
    
    await this.recalculateBalance(productId);
    
    return saved;
  }

  async manualOut(productId: number, quantity: number, description?: string): Promise<InventoryTransaction> {
    const numQuantity = Number(quantity);
    if (isNaN(numQuantity) || numQuantity <= 0) {
      throw new BadRequestException('Количество должно быть больше 0');
    }

    const product = await this.inventoryRepository.findOne({ where: { id: productId } });
    if (!product) throw new NotFoundException(`Товар с ID ${productId} не найден`);

    const currentBalance = await this.getCurrentBalance(productId);

    if (currentBalance < numQuantity) {
      throw new BadRequestException(
        `Недостаточно СЗР на складе. Доступно: ${currentBalance} ${product.unit}, требуется: ${numQuantity} ${product.unit}`
      );
    }

    const newBalance = currentBalance - numQuantity;

    const transaction = this.transactionRepository.create({
      productId,
      type: 'OUT',
      quantity: numQuantity,
      balanceAfter: newBalance,
      referenceType: 'MANUAL_OUT',
      description: description || `Ручной расход: -${numQuantity} ${product.unit}`,
    });

    const saved = await this.transactionRepository.save(transaction);
    await this.recalculateBalance(productId);
    
    return saved;
  }

  async deduct(params: {
    productId: number;
    quantity: number;
    referenceType: 'TREATMENT';
    referenceId: number;
    description?: string;
  }): Promise<InventoryTransaction> {
    const numQuantity = Number(params.quantity);
    if (isNaN(numQuantity) || numQuantity <= 0) {
      throw new BadRequestException('Количество должно быть больше 0');
    }
    
    const product = await this.inventoryRepository.findOne({ where: { id: params.productId } });
    if (!product) {
      throw new NotFoundException(`Товар с ID ${params.productId} не найден`);
    }
    
    const currentBalance = await this.getCurrentBalance(params.productId);

    if (currentBalance < numQuantity) {
      throw new BadRequestException(
        `Недостаточно СЗР на складе. Доступно: ${currentBalance} ${product.unit}, требуется: ${numQuantity} ${product.unit}`
      );
    }

    const newBalance = currentBalance - numQuantity;

    const transaction = this.transactionRepository.create({
      productId: params.productId,
      type: 'OUT',
      quantity: numQuantity,
      balanceAfter: newBalance,
      referenceType: params.referenceType,
      referenceId: params.referenceId,
      description: params.description || `Списание по обработке #${params.referenceId}`,
    });

    const saved = await this.transactionRepository.save(transaction);
    await this.recalculateBalance(params.productId);
    
    return saved;
  }

  async adjust(productId: number, newQuantity: number, reason?: string): Promise<InventoryTransaction> {
    const numNewQuantity = Number(newQuantity);
    if (isNaN(numNewQuantity)) {
      throw new BadRequestException('Некорректное значение количества');
    }

    const product = await this.inventoryRepository.findOne({ where: { id: productId } });
    if (!product) throw new NotFoundException(`Товар с ID ${productId} не найден`);

    const currentBalance = await this.getCurrentBalance(productId);
    const delta = numNewQuantity - currentBalance;

    if (delta === 0) {
      throw new BadRequestException('Новое количество совпадает с текущим');
    }

    const type = delta > 0 ? 'IN' : 'OUT';

    const transaction = this.transactionRepository.create({
      productId,
      type,
      quantity: Math.abs(delta),
      balanceAfter: numNewQuantity,
      referenceType: 'MANUAL_ADJUST',
      description: reason || `Корректировка остатка: ${currentBalance} → ${numNewQuantity} ${product.unit}`,
    });

    const saved = await this.transactionRepository.save(transaction);
    await this.recalculateBalance(productId);
    
    return saved;
  }
}