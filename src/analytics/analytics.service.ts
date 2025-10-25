import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, Between } from 'typeorm';
import { Treatment } from '../treatments/entities/treatment.entity';
import { ProductInventory } from '../inventory/entities/product-inventory.entity';
import { Vehicle } from '../vehicles/entities/vehicle.entity';
import { MaintenanceRecord } from '../maintenance/entities/maintenance-record.entity';

interface MonthlyStats {
  treatments: number;
  area: number;
  completed: number;
}

interface CultureStats {
  total: number;
  completed: number;
  area: number;
}

@Injectable()
export class AnalyticsService {
  constructor(
    @InjectRepository(Treatment)
    private treatmentsRepository: Repository<Treatment>,
    @InjectRepository(ProductInventory)
    private inventoryRepository: Repository<ProductInventory>,
    @InjectRepository(Vehicle)
    private vehiclesRepository: Repository<Vehicle>,
    @InjectRepository(MaintenanceRecord)
    private maintenanceRepository: Repository<MaintenanceRecord>,
  ) {}

  // Общая статистика
  async getOverviewStats() {
    const [
      totalTreatments,
      completedTreatments,
      totalInventoryItems,
      lowStockItems,
      totalVehicles,
      totalMaintenanceRecords
    ] = await Promise.all([
      this.treatmentsRepository.count(),
      this.treatmentsRepository.count({ where: { completed: true } }),
      this.inventoryRepository.count(),
      this.inventoryRepository.count({ where: { quantity: 5 } }),
      this.vehiclesRepository.count(),
      this.maintenanceRepository.count()
    ]);

    return {
      treatments: {
        total: totalTreatments,
        completed: completedTreatments,
        completionRate: totalTreatments > 0 ? (completedTreatments / totalTreatments) * 100 : 0
      },
      inventory: {
        total: totalInventoryItems,
        lowStock: lowStockItems
      },
      vehicles: {
        total: totalVehicles
      },
      maintenance: {
        total: totalMaintenanceRecords
      }
    };
  }

  // Статистика по обработкам
  async getTreatmentsAnalytics(startDate?: Date, endDate?: Date) {
    const whereCondition: any = {};
    
    if (startDate && endDate) {
      whereCondition.dueDate = Between(startDate, endDate);
    }

    const treatments = await this.treatmentsRepository.find({
      where: whereCondition,
      relations: ['chemicalProducts']
    });

    // Статистика по культурам
    const cultureStats: Record<string, CultureStats> = treatments.reduce((acc, treatment) => {
      const culture = treatment.culture;
      if (!acc[culture]) {
        acc[culture] = { total: 0, completed: 0, area: 0 };
      }
      acc[culture].total++;
      acc[culture].area += treatment.area;
      if (treatment.completed) {
        acc[culture].completed++;
      }
      return acc;
    }, {} as Record<string, CultureStats>);

    // Статистика по типам препаратов
    const productTypeStats: Record<string, number> = treatments.reduce((acc, treatment) => {
      treatment.chemicalProducts.forEach(product => {
        const type = product.productType;
        if (!acc[type]) {
          acc[type] = 0;
        }
        acc[type]++;
      });
      return acc;
    }, {} as Record<string, number>);

    // Ежемесячная статистика
    const monthlyStats: Record<string, MonthlyStats> = treatments.reduce((acc, treatment) => {
      const month = treatment.dueDate.toISOString().substring(0, 7); // YYYY-MM
      if (!acc[month]) {
        acc[month] = { treatments: 0, area: 0, completed: 0 };
      }
      acc[month].treatments++;
      acc[month].area += treatment.area;
      if (treatment.completed) {
        acc[month].completed++;
      }
      return acc;
    }, {} as Record<string, MonthlyStats>);

    return {
      total: treatments.length,
      totalArea: treatments.reduce((sum, t) => sum + t.area, 0),
      completionRate: treatments.length > 0 ? 
        (treatments.filter(t => t.completed).length / treatments.length) * 100 : 0,
      cultureStats,
      productTypeStats,
      monthlyStats: Object.entries(monthlyStats).map(([month, stats]) => ({
        month,
        treatments: stats.treatments,
        area: stats.area,
        completed: stats.completed
      })).sort((a, b) => a.month.localeCompare(b.month))
    };
  }

  // Аналитика склада
  async getInventoryAnalytics() {
    const inventory = await this.inventoryRepository.find();
    
    const typeStats = inventory.reduce((acc, product) => {
      const type = product.type;
      if (!acc[type]) {
        acc[type] = { count: 0, totalQuantity: 0, items: [] };
      }
      acc[type].count++;
      acc[type].totalQuantity += product.quantity;
      acc[type].items.push(product);
      return acc;
    }, {} as Record<string, { count: number; totalQuantity: number; items: ProductInventory[] }>);

    const lowStock = inventory.filter(product => product.quantity <= 5);
    const outOfStock = inventory.filter(product => product.quantity === 0);

    return {
      totalItems: inventory.length,
      totalValue: inventory.reduce((sum, product) => sum + product.quantity, 0),
      typeStats,
      alerts: {
        lowStock: lowStock.length,
        outOfStock: outOfStock.length,
        lowStockItems: lowStock,
        outOfStockItems: outOfStock
      }
    };
  }

  // Аналитика техники
  async getVehiclesAnalytics() {
    const vehicles = await this.vehiclesRepository.find({
      relations: ['maintenanceRecords']
    });

    const typeStats: Record<string, number> = vehicles.reduce((acc, vehicle) => {
      const type = vehicle.type;
      if (!acc[type]) {
        acc[type] = 0;
      }
      acc[type]++;
      return acc;
    }, {} as Record<string, number>);

    const now = new Date();
    const thirtyDaysFromNow = new Date();
    thirtyDaysFromNow.setDate(now.getDate() + 30);

    const insuranceExpiring = vehicles.filter(v => 
      v.insuranceDate && v.insuranceDate <= thirtyDaysFromNow && v.insuranceDate >= now
    );
    
    const insuranceExpired = vehicles.filter(v => 
      v.insuranceDate && v.insuranceDate < now
    );

    const roadLegalExpiring = vehicles.filter(v => 
      v.roadLegalUntil && v.roadLegalUntil <= thirtyDaysFromNow && v.roadLegalUntil >= now
    );
    
    const roadLegalExpired = vehicles.filter(v => 
      v.roadLegalUntil && v.roadLegalUntil < now
    );

    return {
      total: vehicles.length,
      typeStats,
      documents: {
        insuranceExpiring: insuranceExpiring.length,
        insuranceExpired: insuranceExpired.length,
        roadLegalExpiring: roadLegalExpiring.length,
        roadLegalExpired: roadLegalExpired.length,
        insuranceExpiringList: insuranceExpiring,
        roadLegalExpiringList: roadLegalExpiring
      }
    };
  }

  // Временная шкала обработок для культуры
  async getCultureTimeline(culture: string) {
    const treatments = await this.treatmentsRepository.find({
      where: { culture },
      relations: ['chemicalProducts'],
      order: { dueDate: 'ASC' }
    });

    const timelineData = treatments.map(treatment => ({
      id: treatment.id,
      date: treatment.dueDate,
      type: treatment.chemicalProducts[0]?.productType || 'unknown',
      products: treatment.chemicalProducts.map(p => p.name),
      completed: treatment.completed,
      area: treatment.area
    }));

    return {
      culture,
      treatments: timelineData,
      totalTreatments: treatments.length,
      completedTreatments: treatments.filter(t => t.completed).length,
      totalArea: treatments.reduce((sum, t) => sum + t.area, 0)
    };
  }

  // Отчет по использованию препаратов
  async getProductUsageReport() {
    const treatments = await this.treatmentsRepository.find({
      relations: ['chemicalProducts']
    });

    const productUsage: Record<string, {
      name: string;
      type: string;
      usageCount: number;
      cultures: Set<string>;
      totalArea: number;
    }> = treatments.reduce((acc, treatment) => {
      treatment.chemicalProducts.forEach(product => {
        const key = `${product.name}-${product.productType}`;
        if (!acc[key]) {
          acc[key] = {
            name: product.name,
            type: product.productType,
            usageCount: 0,
            cultures: new Set(),
            totalArea: 0
          };
        }
        acc[key].usageCount++;
        acc[key].cultures.add(treatment.culture);
        acc[key].totalArea += treatment.area;
      });
      return acc;
    }, {} as Record<string, any>);

    // Convert Set to Array
    Object.values(productUsage).forEach((product: any) => {
      product.cultures = Array.from(product.cultures);
    });

    return Object.values(productUsage).sort((a: any, b: any) => b.usageCount - a.usageCount);
  }
}