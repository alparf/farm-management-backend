// src/inventory/inventory.controller.ts
import { Controller, Get, Post, Body, Patch, Param, Delete, ParseIntPipe, Query } from '@nestjs/common';
import { InventoryService } from './inventory.service';
import { InventoryTransactionsService } from './inventory-transactions.service';
import { CreateInventoryDto } from './dto/create-inventory.dto';
import { UpdateInventoryDto } from './dto/update-inventory.dto';

@Controller('inventory')
export class InventoryController {
  constructor(
    private readonly inventoryService: InventoryService,
    private readonly inventoryTransactionsService: InventoryTransactionsService,
  ) {}

  @Post()
  create(@Body() createInventoryDto: CreateInventoryDto) {
    return this.inventoryService.create(createInventoryDto);
  }

  @Get()
  findAll() {
    return this.inventoryService.findAll();
  }

  @Get('type/:type')
  findByType(@Param('type') type: string) {
    return this.inventoryService.findByType(type);
  }

  @Get('low-stock')
  getLowStock(@Query('threshold') threshold: number = 5) {
    return this.inventoryService.getLowStock(threshold);
  }

  @Get('transactions/all')
  async getAllTransactions() {
    return this.inventoryTransactionsService.getAllTransactions();
  }

  @Get(':id')
  findOne(@Param('id', ParseIntPipe) id: number) {
    return this.inventoryService.findOne(id);
  }

  @Patch(':id')
  update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updateInventoryDto: UpdateInventoryDto,
  ) {
    return this.inventoryService.update(id, updateInventoryDto);
  }

  @Delete(':id')
  remove(@Param('id', ParseIntPipe) id: number) {
    return this.inventoryService.remove(id);
  }

  // ========== ОПЕРАЦИИ СО СКЛАДОМ ==========
  
  @Post(':id/in')
  async manualIn(
    @Param('id', ParseIntPipe) id: number,
    @Body('quantity') quantity: number,
    @Body('description') description: string,
  ) {
    return this.inventoryTransactionsService.manualIn(id, quantity, description);
  }

  @Post(':id/out')
  async manualOut(
    @Param('id', ParseIntPipe) id: number,
    @Body('quantity') quantity: number,
    @Body('description') description: string,
  ) {
    return this.inventoryTransactionsService.manualOut(id, quantity, description);
  }

  @Post(':id/adjust')
  async adjust(
    @Param('id', ParseIntPipe) id: number,
    @Body('newQuantity') newQuantity: number,
    @Body('reason') reason: string,
  ) {
    return this.inventoryTransactionsService.adjust(id, newQuantity, reason);
  }

  // ========== ИСТОРИЯ ДВИЖЕНИЙ ==========

  @Get(':id/transactions')
  async getTransactions(@Param('id', ParseIntPipe) id: number) {
    return this.inventoryTransactionsService.getTransactionHistory(id);
  }

  @Get(':id/balance')
  async getBalance(@Param('id', ParseIntPipe) id: number) {
    const balance = await this.inventoryTransactionsService.getCurrentBalance(id);
    return { productId: id, currentBalance: balance };
  }
}