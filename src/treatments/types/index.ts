// src/treatments/types/index.ts
export interface ChemicalProduct {
  name: string;
  dosage: string;
  productType: ProductType;
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
  // Несовместимые комбинации
  { productType1: 'гербицид', productType2: 'регулятор роста', compatible: false, notes: 'Может вызвать фитотоксичность' },
  { productType1: 'фунгицид', productType2: 'биопрепарат', compatible: false, notes: 'Биопрепараты теряют эффективность' },
  { productType1: 'инсектицид', productType2: 'биопрепарат', compatible: false, notes: 'Гибель полезных микроорганизмов' },
  
  // Совместимые комбинации
  { productType1: 'фунгицид', productType2: 'инсектицид', compatible: true },
  { productType1: 'гербицид', productType2: 'адъювант', compatible: true },
  { productType1: 'удобрение', productType2: 'регулятор роста', compatible: true },
];