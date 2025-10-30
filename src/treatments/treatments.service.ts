// treatments.service.ts
import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Treatment } from './entities/treatment.entity';
import { CreateTreatmentDto } from './dto/create-treatment.dto';
import { UpdateTreatmentDto } from './dto/update-treatment.dto';
import { CompatibilityService } from './compatibility.service';

// Локально определяем тип, так как файл types не найден
export interface TankMixCompatibility {
  isCompatible: boolean;
  warnings: string[];
  errors: string[];
}

@Injectable()
export class TreatmentsService {
  constructor(
    @InjectRepository(Treatment)
    private treatmentsRepository: Repository<Treatment>,
    private compatibilityService: CompatibilityService
  ) {}

  async create(createTreatmentDto: CreateTreatmentDto): Promise<Treatment> {
    // Проверяем совместимость если это баковая смесь
    if (createTreatmentDto.isTankMix && createTreatmentDto.chemicalProducts && createTreatmentDto.chemicalProducts.length > 1) {
      const compatibility = this.compatibilityService.checkTankMixCompatibility(
        createTreatmentDto.chemicalProducts
      );
      
      createTreatmentDto.hasCompatibilityIssues = !compatibility.isCompatible;
      createTreatmentDto.compatibilityWarnings = [...compatibility.errors, ...compatibility.warnings].join('; ');
      
      // Можно добавить логирование или уведомление о проблемах совместимости
      if (!compatibility.isCompatible) {
        console.warn('Создается обработка с проблемами совместимости:', compatibility.errors);
      }
    }

    const treatment = this.treatmentsRepository.create(createTreatmentDto);
    return await this.treatmentsRepository.save(treatment);
  }

  async findAll(): Promise<Treatment[]> {
    return await this.treatmentsRepository.find({
      relations: ['chemicalProducts']
    });
  }

  async findOne(id: number): Promise<Treatment> {
    const treatment = await this.treatmentsRepository.findOne({
      where: { id },
      relations: ['chemicalProducts']
    });
    
    if (!treatment) {
      throw new NotFoundException(`Обработка с ID ${id} не найдена`);
    }
    
    return treatment;
  }

  async update(id: number, updateTreatmentDto: UpdateTreatmentDto): Promise<Treatment> {
    const treatment = await this.findOne(id);
    
    // Если обновляются химические продукты и это баковая смесь, проверяем совместимость
    if (updateTreatmentDto.chemicalProducts && treatment.isTankMix) {
      const compatibility = this.compatibilityService.checkTankMixCompatibility(
        updateTreatmentDto.chemicalProducts
      );
      
      updateTreatmentDto.hasCompatibilityIssues = !compatibility.isCompatible;
      updateTreatmentDto.compatibilityWarnings = [...compatibility.errors, ...compatibility.warnings].join('; ');
    }

    Object.assign(treatment, updateTreatmentDto);
    return await this.treatmentsRepository.save(treatment);
  }

  async remove(id: number): Promise<void> {
    const treatment = await this.findOne(id);
    await this.treatmentsRepository.remove(treatment);
  }

  async markAsCompleted(id: number): Promise<Treatment> {
    const treatment = await this.findOne(id);
    treatment.completed = true;
    treatment.actualDate = new Date();
    return await this.treatmentsRepository.save(treatment);
  }

  // Метод для принудительной проверки совместимости
  async checkCompatibility(id: number): Promise<TankMixCompatibility> {
    const treatment = await this.findOne(id);
    
    if (!treatment.isTankMix || !treatment.chemicalProducts || treatment.chemicalProducts.length <= 1) {
      return { isCompatible: true, warnings: [], errors: [] };
    }

    const compatibility = this.compatibilityService.checkTankMixCompatibility(
      treatment.chemicalProducts
    );

    // Обновляем статус в базе
    treatment.hasCompatibilityIssues = !compatibility.isCompatible;
    treatment.compatibilityWarnings = [...compatibility.errors, ...compatibility.warnings].join('; ');
    await this.treatmentsRepository.save(treatment);

    return compatibility;
  }
}