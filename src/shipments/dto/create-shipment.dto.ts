import { IsNumber, IsDate, IsOptional, IsString, IsArray, ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';
import { CreateShipmentItemDto } from './create-shipment-item.dto';

export class CreateShipmentDto {
  @IsNumber()
  clientId: number;

  @Type(() => Date)
  @IsDate()
  date: Date;

  @IsOptional()
  @IsString()
  notes?: string;

  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => CreateShipmentItemDto)
  items: CreateShipmentItemDto[];
}