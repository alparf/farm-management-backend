// src/analytics/types/analytics.types.ts
export interface CultureStats {
  total: number;
  completed: number;
  area: number;
}

export interface MonthlyStats {
  treatments: number;
  area: number;
  completed: number;
}

export interface TreatmentAnalytics {
  total: number;
  totalArea: number;
  completionRate: number;
  cultureStats: Record<string, CultureStats>;
  productTypeStats: Record<string, number>;
  monthlyStats: {
    month: string;
    treatments: number;
    area: number;
    completed: number;
  }[];
}

export interface OverviewStats {
  treatments: {
    total: number;
    completed: number;
    completionRate: number;
  };
  inventory: {
    total: number;
    lowStock: number;
  };
  vehicles: {
    total: number;
  };
  maintenance: {
    total: number;
  };
}

export interface InventoryAnalytics {
  totalItems: number;
  totalValue: number;
  typeStats: Record<string, { count: number; totalQuantity: number; items: any[] }>;
  alerts: {
    lowStock: number;
    outOfStock: number;
    lowStockItems: any[];
    outOfStockItems: any[];
  };
}

export interface VehiclesAnalytics {
  total: number;
  typeStats: Record<string, number>;
  documents: {
    insuranceExpiring: number;
    insuranceExpired: number;
    roadLegalExpiring: number;
    roadLegalExpired: number;
    insuranceExpiringList: any[];
    roadLegalExpiringList: any[];
  };
}

export interface CultureTimeline {
  culture: string;
  treatments: {
    id: number;
    date: Date;
    type: string;
    products: string[];
    completed: boolean;
    area: number;
  }[];
  totalTreatments: number;
  completedTreatments: number;
  totalArea: number;
}

export interface ProductUsageReport {
  name: string;
  type: string;
  usageCount: number;
  cultures: string[];
  totalArea: number;
}