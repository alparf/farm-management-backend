// src/treatments/entities/treatment-product.entity.ts
import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn } from 'typeorm';
import { Treatment } from './treatment.entity';
import { ProductInventory } from '../../inventory/entities/product-inventory.entity';

@Entity('treatment_products')
export class TreatmentProduct {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => ProductInventory, { eager: true })
  @JoinColumn({ name: 'productId' })
  product: ProductInventory;

  @Column()
  productId: number;

  @Column({ type: 'decimal', precision: 10, scale: 2 })
  ratePerHa: number;

  @Column({ type: 'varchar', length: 10, default: 'л/га' })
  unit: string;

  @ManyToOne(() => Treatment, treatment => treatment.chemicalProducts, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'treatmentId' })
  treatment: Treatment;

  @Column()
  treatmentId: number;
}