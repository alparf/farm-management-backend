import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { ProductInventory } from './product-inventory.entity';

export type TransactionType = 'IN' | 'OUT' | 'ADJUSTMENT';
export type ReferenceType = 'TREATMENT' | 'MANUAL_IN' | 'MANUAL_OUT' | 'MANUAL_ADJUST';

@Entity('inventory_transactions')
export class InventoryTransaction {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => ProductInventory, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'productId' })
  product: ProductInventory;

  @Column()
  productId: number;

  @Column({ type: 'enum', enum: ['IN', 'OUT', 'ADJUSTMENT'] })
  type: TransactionType;

  @Column({ type: 'decimal', precision: 10, scale: 3 })
  quantity: number;

  @Column({ type: 'decimal', precision: 10, scale: 3 })
  balanceAfter: number;

  @Column({ type: 'enum', enum: ['TREATMENT', 'MANUAL_IN', 'MANUAL_OUT', 'MANUAL_ADJUST'], nullable: true })
  referenceType: ReferenceType;

  @Column({ nullable: true })
  referenceId: number;

  @Column({ type: 'text', nullable: true })
  description: string;

  @CreateDateColumn()
  createdAt: Date;
}