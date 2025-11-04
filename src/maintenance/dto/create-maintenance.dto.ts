import { IsString, IsNumber, IsOptional, IsDateString, IsInt, IsNotEmpty } from 'class-validator';

export class CreateMaintenanceDto {
  @IsInt()
  @IsNotEmpty()
  vehicleId: number;

  @IsString()
  @IsNotEmpty()
  vehicleName: string;

  @IsString()
  @IsNotEmpty()
  type: string;

  @IsDateString()
  @IsNotEmpty()
  date: string; // Используем string для ISO даты

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