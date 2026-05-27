import { PartialType } from '@nestjs/mapped-types';
import { CreateTreatmentDto } from './create-treatment.dto';
import { IsDate, IsOptional } from 'class-validator';
import { Type } from 'class-transformer';

export class UpdateTreatmentDto extends PartialType(CreateTreatmentDto) {
  @IsDate()
  @IsOptional()
  @Type(() => Date)
  actualDate?: Date;
}