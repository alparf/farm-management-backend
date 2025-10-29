import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  
  // Разрешаем все origins для разработки
  app.enableCors({
    origin: [
      'http://localhost:3001',
      'http://192.168.100.8:3001',
      'http://127.0.0.1:3001'
    ],
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
  await app.listen(port);
  console.log(`🚀 Farm Management API запущен на http://localhost:${port}`);
}
bootstrap();