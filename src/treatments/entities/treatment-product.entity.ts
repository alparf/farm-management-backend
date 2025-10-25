import { Entity, PrimaryGeneratedColumn, Column, ManyToOne } from 'typeorm';
import { Treatment } from './treatment.entity';

@Entity('treatment_products')
export class TreatmentProduct {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'varchar', length: 200 })
  name: string;

  @Column({ type: 'varchar', length: 100 })
  dosage: string;

  @Column({ type: 'varchar', length: 50 })
  productType: string;

  @ManyToOne(() => Treatment, treatment => treatment.chemicalProducts, { 
    onDelete: 'CASCADE' 
  })
  treatment: Treatment;

  @Column()
  treatmentId: number;
}