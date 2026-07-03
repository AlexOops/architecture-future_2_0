# Task3 — Техрадар и roadmap изменений

## Цель

Сформировать технологический радар и roadmap изменений для перехода «Будущее 2.0» от legacy DWH-centric архитектуры к доменной data-платформе с self-service аналитикой.

## Что подготовлено

- технический радар по технологиям, подходам и инструментам;
- roadmap изменений на год;
- обоснование этапов с точки зрения бизнес-целей;
- PlantUML-диаграммы техрадара и roadmap.

## Структура

```text
Task3/
├── README.md
├── tech_radar.md
├── roadmap.md
├── transformation_rationale.md
└── diagrams/
    ├── tech_radar.puml
    ├── roadmap.puml
    └── pictures/
        ├── tech_radar.png
        └── roadmap.png
```

## Диаграммы

Исходники:

```text
Task3/diagrams/*.puml
```

## Основной вектор изменений

- DWH перестаёт быть центром бизнес-логики.
- Бизнес-логика переносится в доменные сервисы.
- Аналитика строится через Lakehouse, Data Products, Semantic Layer и Self-service Data Portal.
- Новые бизнесы подключаются через API Gateway, Event Bus и Data Contracts.
- Legacy DWH и PowerBuilder мигрируют поэтапно через adapter и strangler-подход.
