import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn, CreateDateColumn, UpdateDateColumn } from 'typeorm';
import { Shipment } from '../entities/shipment.entity';
import { Product } from '../../products/entities/product.entity';

@Entity('shipment_items')
export class ShipmentItem {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => Shipment, shipment => shipment.items, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'shipmentId' })
  shipment: Shipment;

  @Column()
  shipmentId: number;

  @ManyToOne(() => Product)
  @JoinColumn({ name: 'productId' })
  product: Product;

  @Column()
  productId: number;

  @Column({ type: 'decimal', precision: 10, scale: 2 })
  quantity: number;

  @Column({ type: 'decimal', precision: 10, scale: 2, nullable: true })
  returnQuantity: number;

  @Column({ type: 'decimal', precision: 10, scale: 2, default: 0 })
  pricePerUnit: number;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}