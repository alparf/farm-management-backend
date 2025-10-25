import { Controller, Get, Query } from '@nestjs/common';
import { AnalyticsService } from './analytics.service';

@Controller('analytics')
export class AnalyticsController {
  constructor(private readonly analyticsService: AnalyticsService) {}

  @Get('overview')
  getOverview() {
    return this.analyticsService.getOverviewStats();
  }

  @Get('treatments')
  getTreatmentsAnalytics(
    @Query('startDate') startDate?: string,
    @Query('endDate') endDate?: string
  ) {
    const start = startDate ? new Date(startDate) : undefined;
    const end = endDate ? new Date(endDate) : undefined;
    return this.analyticsService.getTreatmentsAnalytics(start, end);
  }

  @Get('inventory')
  getInventoryAnalytics() {
    return this.analyticsService.getInventoryAnalytics();
  }

  @Get('vehicles')
  getVehiclesAnalytics() {
    return this.analyticsService.getVehiclesAnalytics();
  }

  @Get('culture-timeline')
  getCultureTimeline(@Query('culture') culture: string) {
    return this.analyticsService.getCultureTimeline(culture);
  }

  @Get('product-usage')
  getProductUsageReport() {
    return this.analyticsService.getProductUsageReport();
  }
}