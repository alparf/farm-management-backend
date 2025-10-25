import { IsString, IsNumber, IsOptional, IsDate, IsInt } from 'class-validator';
import { Type } from 'class-transformer';

export class CreateMaintenanceDto {
  @IsInt()
  vehicleId: number;

  @IsString()
  vehicleName: string;

  @IsString()
  type: string;

  @IsDate()
  @Type(() => Date)
  date: Date;

  @IsNumber()
  @IsOptional()
  hours?: number;

  @IsString()
  description: string;

  @IsString()
  @IsOptional()
  notes?: string;
}