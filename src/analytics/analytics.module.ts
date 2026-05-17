import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AnalyticsService } from './analytics.service';
import { AnalyticsController } from './analytics.controller';
import { Treatment } from '../treatments/entities/treatment.entity';
import { TreatmentProduct } from '../treatments/entities/treatment-product.entity';
import { ProductInventory } from '../inventory/entities/product-inventory.entity';
import { InventoryTransaction } from '../inventory/entities/inventory-transaction.entity';
import { Vehicle } from '../vehicles/entities/vehicle.entity';
import { MaintenanceRecord } from '../maintenance/entities/maintenance-record.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Treatment,
      TreatmentProduct,
      ProductInventory,
      InventoryTransaction,
      Vehicle,
      MaintenanceRecord
    ])
  ],
  controllers: [AnalyticsController],
  providers: [AnalyticsService],
})
export class AnalyticsModule {}