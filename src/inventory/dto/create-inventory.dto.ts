import { IsString, IsNumber, IsOptional } from 'class-validator';

export class CreateInventoryDto {
  @IsString()
  name: string;

  @IsString()
  type: string;

  @IsNumber()
  quantity: number;

  @IsString()
  unit: string;

  @IsString()
  @IsOptional()
  notes?: string;
}