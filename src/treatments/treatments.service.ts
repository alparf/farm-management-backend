// В treatments.service.ts:

import { CompatibilityService } from './compatibility.service';

@Injectable()
export class TreatmentsService {
  constructor(
    @InjectRepository(Treatment)
    private treatmentsRepository: Repository<Treatment>,
    private compatibilityService: CompatibilityService // Добавляем сервис совместимости
  ) {}

  async create(createTreatmentDto: CreateTreatmentDto): Promise<Treatment> {
    // Проверяем совместимость если это баковая смесь
    if (createTreatmentDto.isTankMix && createTreatmentDto.chemicalProducts.length > 1) {
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

  // Метод для принудительной проверки совместимости
  async checkCompatibility(id: number): Promise<TankMixCompatibility> {
    const treatment = await this.findOne(id);
    
    if (!treatment.isTankMix || treatment.chemicalProducts.length <= 1) {
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