import { IsString, IsNumber, IsOptional, IsDate } from 'class-validator';
import { Type } from 'class-transformer';

export class CreateVehicleDto {
  @IsString()
  name: string;

  @IsString()
  type: string;

  @IsString()
  @IsOptional()
  model?: string;

  @IsNumber()
  @IsOptional()
  year?: number;

  @IsString()
  @IsOptional()
  vin?: string;

  @IsDate()
  @Type(() => Date)
  @IsOptional()
  insuranceDate?: Date;

  @IsDate()
  @Type(() => Date)
  @IsOptional()
  roadLegalUntil?: Date;

  @IsString()
  @IsOptional()
  notes?: string;
}