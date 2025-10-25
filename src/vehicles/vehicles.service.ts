import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Vehicle } from './entities/vehicle.entity';
import { CreateVehicleDto } from './dto/create-vehicle.dto';
import { UpdateVehicleDto } from './dto/update-vehicle.dto';

@Injectable()
export class VehiclesService {
  constructor(
    @InjectRepository(Vehicle)
    private vehiclesRepository: Repository<Vehicle>,
  ) {}

  async findAll(): Promise<Vehicle[]> {
    return this.vehiclesRepository.find({
      order: { createdAt: 'DESC' }
    });
  }

  async findOne(id: number): Promise<Vehicle> {
    const vehicle = await this.vehiclesRepository.findOne({
      where: { id }
    });
    
    if (!vehicle) {
      throw new NotFoundException(`Vehicle with ID ${id} not found`);
    }
    
    return vehicle;
  }

  async create(createVehicleDto: CreateVehicleDto): Promise<Vehicle> {
    const vehicle = this.vehiclesRepository.create(createVehicleDto);
    return await this.vehiclesRepository.save(vehicle);
  }

  async update(id: number, updateVehicleDto: UpdateVehicleDto): Promise<Vehicle> {
    const vehicle = await this.findOne(id);
    Object.assign(vehicle, updateVehicleDto);
    return await this.vehiclesRepository.save(vehicle);
  }

  async remove(id: number): Promise<void> {
    const result = await this.vehiclesRepository.delete(id);
    if (result.affected === 0) {
      throw new NotFoundException(`Vehicle with ID ${id} not found`);
    }
  }

  async findByType(type: string): Promise<Vehicle[]> {
    return this.vehiclesRepository.find({
      where: { type },
      order: { name: 'ASC' }
    });
  }

  async getExpiringDocuments(): Promise<{ 
    insuranceExpiring: Vehicle[], 
    roadLegalExpiring: Vehicle[] 
  }> {
    const thirtyDaysFromNow = new Date();
    thirtyDaysFromNow.setDate(thirtyDaysFromNow.getDate() + 30);

    const insuranceExpiring = await this.vehiclesRepository
      .createQueryBuilder('vehicle')
      .where('vehicle.insuranceDate <= :date', { date: thirtyDaysFromNow })
      .andWhere('vehicle.insuranceDate >= :now', { now: new Date() })
      .getMany();

    const roadLegalExpiring = await this.vehiclesRepository
      .createQueryBuilder('vehicle')
      .where('vehicle.roadLegalUntil <= :date', { date: thirtyDaysFromNow })
      .andWhere('vehicle.roadLegalUntil >= :now', { now: new Date() })
      .getMany();

    return { insuranceExpiring, roadLegalExpiring };
  }

  async getExpiredDocuments(): Promise<{ 
    insuranceExpired: Vehicle[], 
    roadLegalExpired: Vehicle[] 
  }> {
    const insuranceExpired = await this.vehiclesRepository
      .createQueryBuilder('vehicle')
      .where('vehicle.insuranceDate < :now', { now: new Date() })
      .getMany();

    const roadLegalExpired = await this.vehiclesRepository
      .createQueryBuilder('vehicle')
      .where('vehicle.roadLegalUntil < :now', { now: new Date() })
      .getMany();

    return { insuranceExpired, roadLegalExpired };
  }
}