import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TreatmentsService } from './treatments.service';
import { TreatmentsController } from './treatments.controller';
import { Treatment } from './entities/treatment.entity';
import { TreatmentProduct } from './entities/treatment-product.entity';
import { CompatibilityService } from './compatibility.service';
import { InventoryModule } from '../inventory/inventory.module';
import { ProductInventory } from '../inventory/entities/product-inventory.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([Treatment, TreatmentProduct, ProductInventory]), // ← добавить ProductInventory
    InventoryModule,
  ],
  controllers: [TreatmentsController],
  providers: [TreatmentsService, CompatibilityService],
})
export class TreatmentsModule {}