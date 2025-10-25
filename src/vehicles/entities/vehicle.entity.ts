import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, OneToMany } from 'typeorm';
import { MaintenanceRecord } from '../../maintenance/entities/maintenance-record.entity';

@Entity('vehicles')
export class Vehicle {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'varchar', length: 200 })
  name: string;

  @Column({ type: 'varchar', length: 50 })
  type: string;

  @Column({ type: 'varchar', length: 100, nullable: true })
  model: string;

  @Column({ type: 'int', nullable: true })
  year: number;

  @Column({ type: 'varchar', length: 100, nullable: true })
  vin: string;

  @Column({ type: 'date', nullable: true })
  insuranceDate: Date;

  @Column({ type: 'date', nullable: true })
  roadLegalUntil: Date;

  @Column({ type: 'text', nullable: true })
  notes: string;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  @OneToMany(() => MaintenanceRecord, maintenance => maintenance.vehicle)
  maintenanceRecords: MaintenanceRecord[];
}