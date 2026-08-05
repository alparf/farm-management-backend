import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Client } from './entities/client.entity';
import { CreateClientDto } from './dto/create-client.dto';
import { UpdateClientDto } from './dto/update-client.dto';

@Injectable()
export class ClientsService {
  constructor(
    @InjectRepository(Client)
    private clientsRepository: Repository<Client>,
  ) {}

  async findAll(): Promise<Client[]> {
    return this.clientsRepository.find({ order: { name: 'ASC' } });
  }

  async findOne(id: number): Promise<Client> {
    const client = await this.clientsRepository.findOne({ where: { id } });
    if (!client) throw new NotFoundException(`Client with ID ${id} not found`);
    return client;
  }

  async create(createClientDto: CreateClientDto): Promise<Client> {
    const client = this.clientsRepository.create(createClientDto);
    return this.clientsRepository.save(client);
  }

  async update(id: number, updateClientDto: UpdateClientDto): Promise<Client> {
    const client = await this.findOne(id);
    Object.assign(client, updateClientDto);
    return this.clientsRepository.save(client);
  }

  async remove(id: number): Promise<void> {
    const result = await this.clientsRepository.delete(id);
    if (result.affected === 0) throw new NotFoundException(`Client with ID ${id} not found`);
  }
}