// src/treatments/dto/create-treatment.dto.ts
import { IsString, IsNumber, IsBoolean, IsOptional, IsArray, ValidateNested, IsDate, Min, IsIn } from 'class-validator';
import { Type } from 'class-transformer';

export class ChemicalProductDto {
  @IsNumber()
  productId: number;

  @IsNumber()
  @Min(0)
  ratePerHa: number;

  @IsString()
  @IsIn(['л/га', 'кг/га'])
  unit: string = 'л/га';
}

export class CreateTreatmentDto {
  @IsString()
  culture: string;

  @IsNumber()
  @Min(0.01)
  area: number;

  @IsDate()
  @Type(() => Date)
  dueDate: Date;

  @IsBoolean()
  @IsOptional()
  isTankMix?: boolean;

  @IsBoolean()
  @IsOptional()
  hasCompatibilityIssues?: boolean;

  @IsString()
  @IsOptional()
  compatibilityWarnings?: string;

  @IsString()
  @IsOptional()
  notes?: string;

  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => ChemicalProductDto)
  chemicalProducts: ChemicalProductDto[];
}