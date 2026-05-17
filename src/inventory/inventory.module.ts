import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { InventoryService } from './inventory.service';
import { InventoryController } from './inventory.controller';
import { ProductInventory } from './entities/product-inventory.entity';
import { InventoryTransaction } from './entities/inventory-transaction.entity';
import { InventoryTransactionsService } from './inventory-transactions.service';

@Module({
  imports: [TypeOrmModule.forFeature([ProductInventory, InventoryTransaction])],
  controllers: [InventoryController],
  providers: [InventoryService, InventoryTransactionsService],
  exports: [InventoryTransactionsService], // ← ВАЖНО: экспортируем для других модулей
})
export class InventoryModule {}