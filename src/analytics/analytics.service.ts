import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, Between, MoreThanOrEqual, LessThan } from 'typeorm';
import { Treatment } from '../treatments/entities/treatment.entity';
import { TreatmentProduct } from '../treatments/entities/treatment-product.entity';
import { ProductInventory } from '../inventory/entities/product-inventory.entity';
import { InventoryTransaction } from '../inventory/entities/inventory-transaction.entity';
import { Vehicle } from '../vehicles/entities/vehicle.entity';
import { MaintenanceRecord } from '../maintenance/entities/maintenance-record.entity';
import {
  OverviewStats,
  TreatmentAnalytics,
  InventoryAnalytics,
  VehiclesAnalytics,
  CultureTimeline,
  ProductUsageReport
} from './types/analytics.types';

@Injectable()
export class AnalyticsService {
  constructor(
    @InjectRepository(Treatment)
    private treatmentsRepository: Repository<Treatment>,
    @InjectRepository(TreatmentProduct)
    private treatmentProductRepository: Repository<TreatmentProduct>,
    @InjectRepository(ProductInventory)
    private inventoryRepository: Repository<ProductInventory>,
    @InjectRepository(InventoryTransaction)
    private transactionRepository: Repository<InventoryTransaction>,
    @InjectRepository(Vehicle)
    private vehiclesRepository: Repository<Vehicle>,
    @InjectRepository(MaintenanceRecord)
    private maintenanceRepository: Repository<MaintenanceRecord>,
  ) {}

  private async getCurrentBalance(productId: number): Promise<number> {
    const lastTransaction = await this.transactionRepository.findOne({
      where: { productId },
      order: { createdAt: 'DESC' },
    });
    return lastTransaction?.balanceAfter ?? 0;
  }

  async getOverviewStats(): Promise<OverviewStats> {
    const now = new Date();
    now.setHours(0, 0, 0, 0);
    
    const [
      totalTreatments,
      plannedTreatments,
      totalInventoryItems,
      totalVehicles,
      totalMaintenanceRecords
    ] = await Promise.all([
      this.treatmentsRepository.count(),
      this.treatmentsRepository.count({ 
        where: { dueDate: MoreThanOrEqual(now) }
      }),
      this.inventoryRepository.count(),
      this.vehiclesRepository.count(),
      this.maintenanceRepository.count()
    ]);

    const products = await this.inventoryRepository.find();
    let lowStockItems = 0;
    for (const product of products) {
      const balance = await this.getCurrentBalance(product.id);
      if (balance <= 5 && balance > 0) {
        lowStockItems++;
      }
    }

    return {
      treatments: {
        total: totalTreatments,
        planned: plannedTreatments,
        plannedRate: totalTreatments > 0 ? (plannedTreatments / totalTreatments) * 100 : 0
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

  async getTreatmentsAnalytics(startDate?: Date, endDate?: Date): Promise<TreatmentAnalytics> {
    const whereCondition: any = {};
    
    if (startDate && endDate) {
      whereCondition.dueDate = Between(startDate, endDate);
    }

    const treatments = await this.treatmentsRepository.find({
      where: whereCondition,
      relations: ['chemicalProducts', 'chemicalProducts.product']
    });

    const now = new Date();
    now.setHours(0, 0, 0, 0);

    const cultureStats: Record<string, { total: number; planned: number; area: number }> = {};
    for (const treatment of treatments) {
      const culture = treatment.culture;
      if (!cultureStats[culture]) {
        cultureStats[culture] = { total: 0, planned: 0, area: 0 };
      }
      cultureStats[culture].total++;
      cultureStats[culture].area += treatment.area;
      
      // Проверяем, запланирована ли обработка (dueDate в будущем или сегодня)
      if (treatment.dueDate && treatment.dueDate >= now) {
        cultureStats[culture].planned++;
      }
    }

    const productTypeStats: Record<string, number> = {};
    for (const treatment of treatments) {
      for (const product of treatment.chemicalProducts) {
        const type = product.product?.type || 'unknown';
        productTypeStats[type] = (productTypeStats[type] || 0) + 1;
      }
    }

    const monthlyStats: Record<string, { treatments: number; area: number; planned: number }> = {};
    for (const treatment of treatments) {
      if (treatment.dueDate) {
        const month = treatment.dueDate.toISOString().substring(0, 7);
        if (!monthlyStats[month]) {
          monthlyStats[month] = { treatments: 0, area: 0, planned: 0 };
        }
        monthlyStats[month].treatments++;
        monthlyStats[month].area += treatment.area;
        
        if (treatment.dueDate >= now) {
          monthlyStats[month].planned++;
        }
      }
    }

    const totalTreatments = treatments.length;
    const plannedTreatments = treatments.filter(t => t.dueDate && t.dueDate >= now).length;

    return {
      total: totalTreatments,
      totalArea: treatments.reduce((sum, t) => sum + t.area, 0),
      plannedRate: totalTreatments > 0 ? (plannedTreatments / totalTreatments) * 100 : 0,
      cultureStats,
      productTypeStats,
      monthlyStats: Object.entries(monthlyStats).map(([month, stats]) => ({
        month,
        treatments: stats.treatments,
        area: stats.area,
        planned: stats.planned
      })).sort((a, b) => a.month.localeCompare(b.month))
    };
  }

  async getInventoryAnalytics(): Promise<InventoryAnalytics> {
    const inventory = await this.inventoryRepository.find();
    
    const typeStats: Record<string, { count: number; totalQuantity: number; items: any[] }> = {};
    
    for (const product of inventory) {
      const type = product.type;
      const balance = await this.getCurrentBalance(product.id);
      
      if (!typeStats[type]) {
        typeStats[type] = { count: 0, totalQuantity: 0, items: [] };
      }
      typeStats[type].count++;
      typeStats[type].totalQuantity += balance;
      typeStats[type].items.push({
        ...product,
        currentBalance: balance
      });
    }

    const lowStock: any[] = [];
    const outOfStock: any[] = [];
    
    for (const product of inventory) {
      const balance = await this.getCurrentBalance(product.id);
      if (balance <= 5 && balance > 0) {
        lowStock.push({ ...product, currentBalance: balance });
      } else if (balance === 0) {
        outOfStock.push({ ...product, currentBalance: balance });
      }
    }

    return {
      totalItems: inventory.length,
      totalValue: 0,
      typeStats,
      alerts: {
        lowStock: lowStock.length,
        outOfStock: outOfStock.length,
        lowStockItems: lowStock,
        outOfStockItems: outOfStock
      }
    };
  }

  async getVehiclesAnalytics(): Promise<VehiclesAnalytics> {
    const vehicles = await this.vehiclesRepository.find({
      relations: ['maintenanceRecords']
    });

    const typeStats: Record<string, number> = {};
    for (const vehicle of vehicles) {
      const type = vehicle.type;
      typeStats[type] = (typeStats[type] || 0) + 1;
    }

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

  async getCultureTimeline(culture: string): Promise<CultureTimeline> {
    const treatments = await this.treatmentsRepository.find({
      where: { culture },
      relations: ['chemicalProducts', 'chemicalProducts.product'],
      order: { dueDate: 'ASC' }
    });

    const now = new Date();
    now.setHours(0, 0, 0, 0);

    const timelineData = treatments
      .filter(treatment => treatment.dueDate) // Только обработки с датой
      .map(treatment => ({
        id: treatment.id,
        date: treatment.dueDate,
        type: treatment.chemicalProducts[0]?.product?.type || 'unknown',
        products: treatment.chemicalProducts.map(p => p.product?.name || 'unknown'),
        area: treatment.area
      }));

    const plannedTreatments = treatments.filter(t => t.dueDate && t.dueDate >= now).length;

    return {
      culture,
      treatments: timelineData,
      totalTreatments: treatments.length,
      plannedTreatments,
      totalArea: treatments.reduce((sum, t) => sum + t.area, 0)
    };
  }

  async getProductUsageReport(): Promise<ProductUsageReport[]> {
    const treatments = await this.treatmentsRepository.find({
      relations: ['chemicalProducts', 'chemicalProducts.product']
    });

    const productUsage: Record<string, ProductUsageReport> = {};

    for (const treatment of treatments) {
      for (const product of treatment.chemicalProducts) {
        const productName = product.product?.name || 'unknown';
        const productType = product.product?.type || 'unknown';
        const key = `${productName}-${productType}`;
        
        if (!productUsage[key]) {
          productUsage[key] = {
            name: productName,
            type: productType,
            usageCount: 0,
            cultures: [],
            totalArea: 0
          };
        }
        
        productUsage[key].usageCount++;
        
        if (!productUsage[key].cultures.includes(treatment.culture)) {
          productUsage[key].cultures.push(treatment.culture);
        }
        
        productUsage[key].totalArea += treatment.area;
      }
    }

    return Object.values(productUsage).sort((a, b) => b.usageCount - a.usageCount);
  }
}