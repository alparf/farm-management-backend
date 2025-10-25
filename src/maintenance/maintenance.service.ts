import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { MaintenanceRecord } from './entities/maintenance-record.entity';
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
    const record = this.maintenanceRepository.create(createMaintenanceDto);
    return await this.maintenanceRepository.save(record);
  }

  async update(id: number, updateMaintenanceDto: UpdateMaintenanceDto): Promise<MaintenanceRecord> {
    const record = await this.findOne(id);
    Object.assign(record, updateMaintenanceDto);
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
      where: { type },
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
    
    const byType = await this.maintenanceRepository
      .createQueryBuilder('maintenance')
      .select('maintenance.type, COUNT(*) as count')
      .groupBy('maintenance.type')
      .getRawMany();

    const recentMaintenance = await this.maintenanceRepository.find({
      relations: ['vehicle'],
      order: { date: 'DESC' },
      take: 10
    });

    return {
      totalRecords,
      byType: byType.reduce((acc, item) => {
        acc[item.type] = parseInt(item.count);
        return acc;
      }, {}),
      recentMaintenance
    };
  }
}