// src/maintenance/maintenance.service.ts
import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { MaintenanceRecord, MaintenanceType } from './entities/maintenance-record.entity';
import { CreateMaintenanceDto } from './dto/create-maintenance.dto';
import { UpdateMaintenanceDto } from './dto/update-maintenance.dto';

@Injectable()
export class MaintenanceService {
  constructor(
    @InjectRepository(MaintenanceRecord)
    private maintenanceRepository: Repository<MaintenanceRecord>,
  ) {}

  async findAll(): Promise<MaintenanceRecord[]> {
    return this.maintenanceRepository.find({
      relations: ['vehicle'],
      order: { date: 'DESC' }
    });
  }

  async findOne(id: number): Promise<MaintenanceRecord> {
    const record = await this.maintenanceRepository.findOne({
      where: { id },
      relations: ['vehicle']
    });
    
    if (!record) {
      throw new NotFoundException(`Maintenance record with ID ${id} not found`);
    }
    
    return record;
  }

  async create(createMaintenanceDto: CreateMaintenanceDto): Promise<MaintenanceRecord> {
    // Преобразуем строку даты в объект Date
    const recordData = {
      vehicleId: createMaintenanceDto.vehicleId,
      vehicleName: createMaintenanceDto.vehicleName,
      type: createMaintenanceDto.type as MaintenanceType,
      date: new Date(createMaintenanceDto.date),
      hours: createMaintenanceDto.hours,
      description: createMaintenanceDto.description,
      notes: createMaintenanceDto.notes,
    };
    
    const record = this.maintenanceRepository.create(recordData);
    return await this.maintenanceRepository.save(record);
  }

  async update(id: number, updateMaintenanceDto: UpdateMaintenanceDto): Promise<MaintenanceRecord> {
    const record = await this.findOne(id);
    
    // Обновляем только переданные поля, преобразуя дату если нужно
    if (updateMaintenanceDto.date) {
      record.date = new Date(updateMaintenanceDto.date);
    }
    if (updateMaintenanceDto.vehicleId !== undefined) {
      record.vehicleId = updateMaintenanceDto.vehicleId;
    }
    if (updateMaintenanceDto.vehicleName !== undefined) {
      record.vehicleName = updateMaintenanceDto.vehicleName;
    }
    if (updateMaintenanceDto.type !== undefined) {
      record.type = updateMaintenanceDto.type as MaintenanceType;
    }
    if (updateMaintenanceDto.hours !== undefined) {
      record.hours = updateMaintenanceDto.hours;
    }
    if (updateMaintenanceDto.description !== undefined) {
      record.description = updateMaintenanceDto.description;
    }
    if (updateMaintenanceDto.notes !== undefined) {
      record.notes = updateMaintenanceDto.notes;
    }
    
    return await this.maintenanceRepository.save(record);
  }

  async remove(id: number): Promise<void> {
    const result = await this.maintenanceRepository.delete(id);
    if (result.affected === 0) {
      throw new NotFoundException(`Maintenance record with ID ${id} not found`);
    }
  }

  async findByVehicle(vehicleId: number): Promise<MaintenanceRecord[]> {
    return this.maintenanceRepository.find({
      where: { vehicleId },
      relations: ['vehicle'],
      order: { date: 'DESC' }
    });
  }

  async findByType(type: string): Promise<MaintenanceRecord[]> {
    return this.maintenanceRepository.find({
      where: { type: type as MaintenanceType },
      relations: ['vehicle'],
      order: { date: 'DESC' }
    });
  }

  async getMaintenanceStats(): Promise<{
    totalRecords: number;
    byType: Record<string, number>;
    recentMaintenance: MaintenanceRecord[];
  }> {
    const totalRecords = await this.maintenanceRepository.count();
    
    const byTypeRaw = await this.maintenanceRepository
      .createQueryBuilder('maintenance')
      .select('maintenance.type', 'type')
      .addSelect('COUNT(*)', 'count')
      .groupBy('maintenance.type')
      .getRawMany();

    const byType: Record<string, number> = {};
    byTypeRaw.forEach(item => {
      byType[item.type] = parseInt(item.count);
    });

    const recentMaintenance = await this.maintenanceRepository.find({
      relations: ['vehicle'],
      order: { date: 'DESC' },
      take: 10
    });

    return {
      totalRecords,
      byType,
      recentMaintenance
    };
  }
}