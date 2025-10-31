import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  
  // Разрешаем все origins для разработки (осторожно в production!)
  app.enableCors({
    origin: true, // Разрешаем все origins
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS', 'HEAD'],
    allowedHeaders: ['Content-Type', 'Authorization', 'Accept', 'Origin'],
    credentials: true,
    preflightContinue: false,
    optionsSuccessStatus: 204
  });
  
  app.useGlobalPipes(new ValidationPipe({
    whitelist: true,
    transform: true,
  }));
  
  const port = process.env.PORT || 3000;
  const host = '0.0.0.0'; // Важно: слушаем все интерфейсы
  
  await app.listen(port, host);
  console.log(`🚀 Farm Management API запущен:`);
  console.log(`   Локально: http://localhost:${port}`);
  console.log(`   В сети: http://${getNetworkIp()}:${port}`);
}

// Функция для получения IP адреса в сети
function getNetworkIp(): string {
  const os = require('os');
  const interfaces = os.networkInterfaces();
  
  for (const name of Object.keys(interfaces)) {
    for (const interfaceInfo of interfaces[name]) {
      const { address, family, internal } = interfaceInfo;
      if (family === 'IPv4' && !internal) {
        // Пропускаем Docker и другие виртуальные интерфейсы
        if (!address.startsWith('172.') || !address.startsWith('docker')) {
          return address;
        }
      }
    }
  }
  return 'localhost';
}

bootstrap();