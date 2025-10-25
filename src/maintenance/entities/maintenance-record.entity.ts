import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne } from 'typeorm';
import { Vehicle } from '../../vehicles/entities/vehicle.entity';

@Entity('maintenance_records')
export class MaintenanceRecord {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  vehicleId: number;

  @Column({ type: 'varchar', length: 200 })
  vehicleName: string;

  @Column({ type: 'varchar', length: 50 })
  type: string;

  @Column({ type: 'date' })
  date: Date;

  @Column({ type: 'decimal', precision: 8, scale: 1, nullable: true })
  hours: number;

  @Column({ type: 'text' })
  description: string;

  @Column({ type: 'text', nullable: true })
  notes: string;

  @CreateDateColumn()
  createdAt: Date;

  @ManyToOne(() => Vehicle, vehicle => vehicle.maintenanceRecords, { onDelete: 'CASCADE' })
  vehicle: Vehicle;
}