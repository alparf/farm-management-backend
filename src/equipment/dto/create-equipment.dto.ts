import { IsString, IsDate, IsOptional } from 'class-validator';
import { Type } from 'class-transformer';

export class CreateEquipmentDto {
  @IsString()
  name: string;

  @IsString()
  type: string;

  @IsString()
  @IsOptional()
  model?: string;

  @IsString()
  @IsOptional()
  serialNumber?: string;

  @IsDate()
  @Type(() => Date)
  verificationDate: Date;

  @IsString()
  @IsOptional()
  notes?: string;
}