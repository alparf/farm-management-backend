import { Controller, Get, Query } from '@nestjs/common';
import { AnalyticsService } from './analytics.service';
import {
  OverviewStats,
  TreatmentAnalytics,
  InventoryAnalytics,
  VehiclesAnalytics,
  CultureTimeline,
  ProductUsageReport
} from './types/analytics.types';

@Controller('analytics')
export class AnalyticsController {
  constructor(private readonly analyticsService: AnalyticsService) {}

  @Get('overview')
  getOverview(): Promise<OverviewStats> {
    return this.analyticsService.getOverviewStats();
  }

  @Get('treatments')
  getTreatmentsAnalytics(
    @Query('startDate') startDate?: string,
    @Query('endDate') endDate?: string
  ): Promise<TreatmentAnalytics> {
    const start = startDate ? new Date(startDate) : undefined;
    const end = endDate ? new Date(endDate) : undefined;
    return this.analyticsService.getTreatmentsAnalytics(start, end);
  }

  @Get('inventory')
  getInventoryAnalytics(): Promise<InventoryAnalytics> {
    return this.analyticsService.getInventoryAnalytics();
  }

  @Get('vehicles')
  getVehiclesAnalytics(): Promise<VehiclesAnalytics> {
    return this.analyticsService.getVehiclesAnalytics();
  }

  @Get('culture-timeline')
  getCultureTimeline(@Query('culture') culture: string): Promise<CultureTimeline> {
    return this.analyticsService.getCultureTimeline(culture);
  }

  @Get('product-usage')
  getProductUsageReport(): Promise<ProductUsageReport[]> {
    return this.analyticsService.getProductUsageReport();
  }
}