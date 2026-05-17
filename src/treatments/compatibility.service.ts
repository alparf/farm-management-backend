import { Injectable } from '@nestjs/common';

export interface ChemicalProduct {
  productId: number;  // ← ID, но для совместимости он не нужен, только тип
  ratePerHa: number;  // ← норма, но для совместимости не используется
  // Добавляем поля, которые реально нужны для проверки совместимости
  name?: string;
  productType: string;
}

export type ProductType = 
  | 'гербицид' | 'инсектицид' | 'фунгицид' | 'десикант' 
  | 'регулятор роста' | 'удобрение' | 'биопрепарат' | 'адъювант';

export interface CompatibilityRule {
  productType1: ProductType;
  productType2: ProductType;
  compatible: boolean;
  notes?: string;
}

export interface TankMixCompatibility {
  isCompatible: boolean;
  warnings: string[];
  errors: string[];
}

export const COMPATIBILITY_RULES: CompatibilityRule[] = [
  { productType1: 'гербицид', productType2: 'регулятор роста', compatible: false, notes: 'Может вызвать фитотоксичность' },
  { productType1: 'фунгицид', productType2: 'биопрепарат', compatible: false, notes: 'Биопрепараты теряют эффективность' },
  { productType1: 'инсектицид', productType2: 'биопрепарат', compatible: false, notes: 'Гибель полезных микроорганизмов' },
  { productType1: 'фунгицид', productType2: 'инсектицид', compatible: true },
  { productType1: 'гербицид', productType2: 'адъювант', compatible: true },
  { productType1: 'удобрение', productType2: 'регулятор роста', compatible: true },
];

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

    for (let i = 0; i < products.length; i++) {
      for (let j = i + 1; j < products.length; j++) {
        const product1 = products[i];
        const product2 = products[j];
        
        const compatibilityIssue = this.checkProductPairCompatibility(
          product1.productType as ProductType, 
          product2.productType as ProductType
        );

        if (compatibilityIssue && !compatibilityIssue.compatible) {
          result.isCompatible = false;
          result.errors.push(
            `Несовместимость: ${product1.productType} и ${product2.productType} - ${compatibilityIssue.notes}`
          );
        }
      }
    }

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
    
    const uniqueTypes = new Set(productTypes);
    if (uniqueTypes.size > 3) {
      result.warnings.push('Слишком много разных типов препаратов в смеси - возможна нестабильность');
    }

    const hasBiologics = productTypes.includes('биопрепарат');
    const hasChemicals = productTypes.some(type => 
      ['гербицид', 'инсектицид', 'фунгицид'].includes(type)
    );
    
    if (hasBiologics && hasChemicals) {
      result.warnings.push('Биопрепараты могут терять эффективность в смеси с химическими средствами');
    }
  }
}