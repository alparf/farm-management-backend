// src/maintenance/dto/create-maintenance.dto.ts
import { IsString, IsNumber, IsOptional, IsDateString, IsInt, IsNotEmpty } from 'class-validator';

export type MaintenanceType = 'Плановое ТО' | 'Внеплановый ремонт';

export class CreateMaintenanceDto {
  @IsInt()
  @IsNotEmpty()
  vehicleId: number;

  @IsString()
  @IsNotEmpty()
  vehicleName: string;

  @IsString()
  @IsNotEmpty()
  type: MaintenanceType;

  @IsDateString()
  @IsNotEmpty()
  date: string;

  @IsNumber()
  @IsOptional()
  hours?: number;

  @IsString()
  @IsNotEmpty()
  description: string;

  @IsString()
  @IsOptional()
  notes?: string;
}