import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TreatmentsService } from './treatments.service';
import { TreatmentsController } from './treatments.controller';
import { Treatment } from './entities/treatment.entity';
import { TreatmentProduct } from './entities/treatment-product.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Treatment, TreatmentProduct])],
  controllers: [TreatmentsController],
  providers: [TreatmentsService],
})
export class TreatmentsModule {}