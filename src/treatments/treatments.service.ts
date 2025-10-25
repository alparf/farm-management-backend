import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Treatment } from './entities/treatment.entity';
import { CreateTreatmentDto } from './dto/create-treatment.dto';
import { UpdateTreatmentDto } from './dto/update-treatment.dto';

@Injectable()
export class TreatmentsService {
  constructor(
    @InjectRepository(Treatment)
    private treatmentsRepository: Repository<Treatment>,
  ) {}

  async findAll(): Promise<Treatment[]> {
    return this.treatmentsRepository.find({
      relations: ['chemicalProducts'],
      order: { createdAt: 'DESC' }
    });
  }

  async findOne(id: number): Promise<Treatment> {
    const treatment = await this.treatmentsRepository.findOne({
      where: { id },
      relations: ['chemicalProducts']
    });
    
    if (!treatment) {
      throw new NotFoundException(`Treatment with ID ${id} not found`);
    }
    
    return treatment;
  }

  async create(createTreatmentDto: CreateTreatmentDto): Promise<Treatment> {
    const treatment = this.treatmentsRepository.create(createTreatmentDto);
    return await this.treatmentsRepository.save(treatment);
  }

  async update(id: number, updateTreatmentDto: UpdateTreatmentDto): Promise<Treatment> {
    const treatment = await this.findOne(id);
    Object.assign(treatment, updateTreatmentDto);
    return await this.treatmentsRepository.save(treatment);
  }

  async remove(id: number): Promise<void> {
    const result = await this.treatmentsRepository.delete(id);
    if (result.affected === 0) {
      throw new NotFoundException(`Treatment with ID ${id} not found`);
    }
  }

  async markAsCompleted(id: number): Promise<Treatment> {
    const treatment = await this.findOne(id);
    treatment.completed = true;
    treatment.actualDate = new Date();
    return await this.treatmentsRepository.save(treatment);
  }
}