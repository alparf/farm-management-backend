import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Shipment } from './entities/shipment.entity';
import { ShipmentItem } from './entities/shipment-item.entity';
import { CreateShipmentDto } from './dto/create-shipment.dto';
import { UpdateShipmentDto } from './dto/update-shipment.dto';

@Injectable()
export class ShipmentsService {
  constructor(
    @InjectRepository(Shipment)
    private shipmentsRepository: Repository<Shipment>,
    @InjectRepository(ShipmentItem)
    private shipmentItemsRepository: Repository<ShipmentItem>,
  ) {}

  async findAll(): Promise<Shipment[]> {
    return this.shipmentsRepository.find({
      relations: ['client', 'items', 'items.product'],
      order: { date: 'DESC' },
    });
  }

  async findOne(id: number): Promise<Shipment> {
    const shipment = await this.shipmentsRepository.findOne({
      where: { id },
      relations: ['client', 'items', 'items.product'], // явно загружаем связи
    });
    if (!shipment) throw new NotFoundException(`Shipment with ID ${id} not found`);
    return shipment;
  }

  async create(createShipmentDto: CreateShipmentDto): Promise<Shipment> {
    const shipment = this.shipmentsRepository.create({
      clientId: createShipmentDto.clientId,
      date: createShipmentDto.date,
      notes: createShipmentDto.notes,
    });
    const savedShipment = await this.shipmentsRepository.save(shipment);

    const items = createShipmentDto.items.map(itemDto =>
      this.shipmentItemsRepository.create({
        ...itemDto,
        shipmentId: savedShipment.id,
      })
    );
    await this.shipmentItemsRepository.save(items);

    return this.findOne(savedShipment.id);
  }

  async update(id: number, updateShipmentDto: UpdateShipmentDto): Promise<Shipment> {
    const shipment = await this.findOne(id);

    if (updateShipmentDto.clientId !== undefined) shipment.clientId = updateShipmentDto.clientId;
    if (updateShipmentDto.date !== undefined) shipment.date = updateShipmentDto.date;
    if (updateShipmentDto.notes !== undefined) shipment.notes = updateShipmentDto.notes;

    if (updateShipmentDto.items) {
      // Удаляем старые позиции
      await this.shipmentItemsRepository.delete({ shipmentId: id });

      // Создаём новые
      const newItems = updateShipmentDto.items.map(itemDto =>
        this.shipmentItemsRepository.create({
          ...itemDto,
          shipmentId: id,
        })
      );
      await this.shipmentItemsRepository.save(newItems);
    }

    await this.shipmentsRepository.save(shipment);
    return this.findOne(id);
  }

  // ✅ ИСПРАВЛЕННЫЙ МЕТОД УДАЛЕНИЯ (Вариант 3)
  async remove(id: number): Promise<void> {
    // Загружаем отгрузку со всеми связями (включая позиции)
    const shipment = await this.findOne(id);
    if (!shipment) throw new NotFoundException(`Shipment with ID ${id} not found`);

    // Удаляем через TypeORM remove – каскады сработают благодаря cascade: true
    await this.shipmentsRepository.remove(shipment);
  }
}