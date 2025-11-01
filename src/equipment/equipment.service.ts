import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Equipment } from './entities/equipment.entity';
import { CreateEquipmentDto } from './dto/create-equipment.dto';
import { UpdateEquipmentDto } from './dto/update-equipment.dto';

@Injectable()
export class EquipmentService {
  constructor(
    @InjectRepository(Equipment)
    private equipmentRepository: Repository<Equipment>,
  ) {}

  async findAll(): Promise<Equipment[]> {
    return this.equipmentRepository.find({
      order: { createdAt: 'DESC' }
    });
  }

  async findOne(id: number): Promise<Equipment> {
    const equipment = await this.equipmentRepository.findOne({
      where: { id }
    });
    
    if (!equipment) {
      throw new NotFoundException(`Equipment with ID ${id} not found`);
    }
    
    return equipment;
  }

  async create(createEquipmentDto: CreateEquipmentDto): Promise<Equipment> {
    const equipment = this.equipmentRepository.create(createEquipmentDto);
    return await this.equipmentRepository.save(equipment);
  }

  async update(id: number, updateEquipmentDto: UpdateEquipmentDto): Promise<Equipment> {
    const equipment = await this.findOne(id);
    Object.assign(equipment, updateEquipmentDto);
    return await this.equipmentRepository.save(equipment);
  }

  async remove(id: number): Promise<void> {
    const result = await this.equipmentRepository.delete(id);
    if (result.affected === 0) {
      throw new NotFoundException(`Equipment with ID ${id} not found`);
    }
  }

  async findByType(type: string): Promise<Equipment[]> {
    return this.equipmentRepository.find({
      where: { type },
      order: { name: 'ASC' }
    });
  }

  async getExpiringVerifications(): Promise<Equipment[]> {
    const thirtyDaysFromNow = new Date();
    thirtyDaysFromNow.setDate(thirtyDaysFromNow.getDate() + 30);

    return this.equipmentRepository
      .createQueryBuilder('equipment')
      .where('equipment.verificationDate <= :date', { date: thirtyDaysFromNow })
      .andWhere('equipment.verificationDate >= :now', { now: new Date() })
      .getMany();
  }

  async getExpiredVerifications(): Promise<Equipment[]> {
    return this.equipmentRepository
      .createQueryBuilder('equipment')
      .where('equipment.verificationDate < :now', { now: new Date() })
      .getMany();
  }
}