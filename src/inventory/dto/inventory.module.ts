import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { InventoryService } from './inventory.service';
import { InventoryController } from './inventory.controller';
import { ProductInventory } from './entities/product-inventory.entity';

@Module({
  imports: [TypeOrmModule.forFeature([ProductInventory])],
  controllers: [InventoryController],
  providers: [InventoryService],
})
export class InventoryModule {}