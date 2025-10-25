import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AnalyticsService } from './analytics.service';
import { AnalyticsController } from './analytics.controller';
import { Treatment } from '../treatments/entities/treatment.entity';
import { ProductInventory } from '../inventory/entities/product-inventory.entity';
import { Vehicle } from '../vehicles/entities/vehicle.entity';
import { MaintenanceRecord } from '../maintenance/entities/maintenance-record.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Treatment, 
      ProductInventory, 
      Vehicle, 
      MaintenanceRecord
    ])
  ],
  controllers: [AnalyticsController],
  providers: [AnalyticsService],
})
export class AnalyticsModule {}