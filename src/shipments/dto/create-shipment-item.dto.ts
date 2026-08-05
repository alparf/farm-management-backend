import { IsNumber, IsPositive, Min, IsOptional } from 'class-validator';
import { Transform } from 'class-transformer';

export class CreateShipmentItemDto {
  @IsNumber()
  productId: number;

  @Transform(({ value }) => Number(value))
  @IsNumber()
  @IsPositive()
  quantity: number;

  @IsOptional()
  @Transform(({ value }) => {
    if (value === undefined || value === null || value === '') {
      return undefined;
    }
    return Number(value);
  })
  @IsNumber({}, { each: false })
  @Min(0)
  returnQuantity?: number;

  @Transform(({ value }) => Number(value))
  @IsNumber()
  @Min(0)
  pricePerUnit: number;
}