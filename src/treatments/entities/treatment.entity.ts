import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, OneToMany } from 'typeorm';
import { TreatmentProduct } from './treatment-product.entity';

@Entity('treatments')
export class Treatment {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'varchar', length: 100 })
  culture: string;

  @Column({ type: 'decimal', precision: 10, scale: 2 })
  area: number;

  @Column({ default: false })
  completed: boolean;

  @Column({ type: 'date', nullable: true })
  dueDate: Date;

  @Column({ type: 'date', nullable: true })
  actualDate: Date;

  @Column({ default: false })
  isTankMix: boolean;

  @Column({ default: false })
  hasCompatibilityIssues: boolean;

  @Column({ type: 'text', nullable: true })
  compatibilityWarnings: string;

  @Column({ type: 'text', nullable: true })
  notes: string;

  @CreateDateColumn()
  createdAt: Date;

  @OneToMany(() => TreatmentProduct, product => product.treatment, { 
    cascade: true,
    eager: true 
  })
  chemicalProducts: TreatmentProduct[];
}