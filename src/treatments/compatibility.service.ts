// Создадим файл compatibility.service.ts
import { Injectable } from '@nestjs/common';
import { ChemicalProduct, ProductType, TankMixCompatibility, COMPATIBILITY_RULES } from '@/types';

@Injectable()
export class CompatibilityService {
  
  checkTankMixCompatibility(products: ChemicalProduct[]): TankMixCompatibility {
    const result: TankMixCompatibility = {
      isCompatible: true,
      warnings: [],
      errors: []
    };

    if (products.length <= 1) {
      return result;
    }

    // Проверяем все возможные пары продуктов
    for (let i = 0; i < products.length; i++) {
      for (let j = i + 1; j < products.length; j++) {
        const product1 = products[i];
        const product2 = products[j];
        
        const compatibilityIssue = this.checkProductPairCompatibility(
          product1.productType, 
          product2.productType
        );

        if (compatibilityIssue) {
          result.isCompatible = false;
          result.errors.push(
            `Несовместимость: ${product1.productType} (${product1.name}) и ${product2.productType} (${product2.name}) - ${compatibilityIssue.notes}`
          );
        }
      }
    }

    // Дополнительные проверки
    this.checkSpecialCases(products, result);

    return result;
  }

  private checkProductPairCompatibility(type1: ProductType, type2: ProductType): CompatibilityRule | null {
    return COMPATIBILITY_RULES.find(rule => 
      (rule.productType1 === type1 && rule.productType2 === type2) ||
      (rule.productType1 === type2 && rule.productType2 === type1)
    ) || null;
  }

  private checkSpecialCases(products: ChemicalProduct[], result: TankMixCompatibility): void {
    const productTypes = products.map(p => p.productType);
    
    // Проверка на количество разных типов
    const uniqueTypes = new Set(productTypes);
    if (uniqueTypes.size > 3) {
      result.warnings.push('Слишком много разных типов препаратов в смеси - возможна нестабильность');
    }

    // Проверка на наличие биопрепаратов с химией
    const hasBiologics = productTypes.includes('биопрепарат');
    const hasChemicals = productTypes.some(type => 
      ['гербицид', 'инсектицид', 'фунгицид'].includes(type)
    );
    
    if (hasBiologics && hasChemicals) {
      result.warnings.push('Биопрепараты могут терять эффективность в смеси с химическими средствами');
    }
  }
}