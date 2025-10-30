import { IsString, IsNumber, IsBoolean, IsOptional, IsArray, ValidateNested, IsDate } from 'class-validator';
import { Type } from 'class-transformer';

export class ChemicalProductDto {
  @IsString()
  name: string;

  @IsString()
  dosage: string;

  @IsString()
  productType: string;
}

export class CreateTreatmentDto {
  @IsString()
  culture: string;

  @IsNumber()
  area: number;

  @IsBoolean()
  @IsOptional()
  completed?: boolean;

  @IsDate()
  @Type(() => Date)
  dueDate: Date;

  @IsDate()
  @Type(() => Date)
  @IsOptional()
  actualDate?: Date;

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