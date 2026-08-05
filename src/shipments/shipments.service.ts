import { Injectable, NotFoundException, InternalServerErrorException } from '@nestjs/common';
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
    try {
      return await this.shipmentsRepository.find({
        relations: ['client', 'items', 'items.product'],
        order: { date: 'DESC' },
      });
    } catch (error) {
      console.error('Error in findAll:', error);
      throw new InternalServerErrorException('Failed to fetch shipments');
    }
  }

  async findOne(id: number): Promise<Shipment> {
    try {
      const shipment = await this.shipmentsRepository.findOne({
        where: { id },
        relations: ['client', 'items', 'items.product'],
      });
      if (!shipment) throw new NotFoundException(`Shipment with ID ${id} not found`);
      return shipment;
    } catch (error) {
      console.error(`Error in findOne(${id}):`, error);
      throw error;
    }
  }

  async create(createShipmentDto: CreateShipmentDto): Promise<Shipment> {
    try {
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
    } catch (error) {
      console.error('Error in create:', error);
      throw new InternalServerErrorException('Failed to create shipment');
    }
  }

  async update(id: number, updateShipmentDto: UpdateShipmentDto): Promise<Shipment> {
    try {
      console.log('Update DTO received:', JSON.stringify(updateShipmentDto, null, 2));

      // Находим существующую отгрузку (без связей, чтобы упростить)
      const shipment = await this.shipmentsRepository.findOne({
        where: { id },
      });
      if (!shipment) throw new NotFoundException(`Shipment with ID ${id} not found`);

      // Обновляем поля
      if (updateShipmentDto.clientId !== undefined) shipment.clientId = updateShipmentDto.clientId;
      if (updateShipmentDto.date !== undefined) shipment.date = updateShipmentDto.date;
      if (updateShipmentDto.notes !== undefined) shipment.notes = updateShipmentDto.notes;

      // Сохраняем изменения (без позиций)
      await this.shipmentsRepository.save(shipment);

      // Если есть позиции, обновляем их
      if (updateShipmentDto.items) {
        // Удаляем старые
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

      return this.findOne(id);
    } catch (error) {
      console.error('Error in update:', error);
      throw new InternalServerErrorException('Failed to update shipment');
    }
  }

  async remove(id: number): Promise<void> {
    try {
      const result = await this.shipmentsRepository.delete(id);
      if (result.affected === 0) throw new NotFoundException(`Shipment with ID ${id} not found`);
    } catch (error) {
      console.error(`Error in remove(${id}):`, error);
      throw error;
    }
  }
}