# Task3 — Техрадар и roadmap изменений

## Цель

Сформировать технологический радар и roadmap изменений для перехода «Будущее 2.0» от legacy DWH/ESB-centric архитектуры к доменной data-платформе с self-service аналитикой, независимыми доменами и поэтапным выводом legacy ESB.

## Что подготовлено

- технический радар по технологиям, подходам и инструментам;
- roadmap изменений на год;
- обоснование этапов с точки зрения бизнес-целей;
- стратегия поэтапного вывода Apache Camel / legacy ESB;
- PlantUML-диаграммы техрадара и roadmap.

## Структура

```text
Task3/
├── README.md
├── tech_radar.md
├── roadmap.md
├── transformation_rationale.md
├── esb_migration_roadmap.md
└── diagrams/
    ├── tech_radar.puml
    ├── roadmap.puml
    ├── esb_migration_roadmap.puml
    └── pictures/
        ├── tech_radar.png
        ├── roadmap.png
        └── esb_migration_roadmap.png
```

## Диаграммы

Исходники:

```text
Task3/diagrams/*.puml
```

## Основной вектор изменений

- DWH перестаёт быть центром бизнес-логики.
- Apache Camel перестаёт быть местом новой интеграционной и бизнес-логики.
- Бизнес-логика переносится в доменные сервисы.
- Аналитика строится через Lakehouse, Data Products, Semantic Layer и Self-service Data Portal.
- Новые бизнесы подключаются через API Gateway, Event Bus и Data Contracts.
- API Gateway и Event Bus закрывают транспортный слой, но не заменяют всю ответственность ESB.
- ФЛК переносится в domain validators и data contracts.
- Трансформации переносятся в anti-corruption layer, mapping services и data pipelines.
- Retry, DLQ и идемпотентность переносятся в reliability patterns Event Bus и consumer services.
- Legacy DWH, PowerBuilder и Apache Camel мигрируют поэтапно через adapter и strangler-подход.

## Что меняется в roadmap по Apache Camel / ESB

Apache Camel не выводится простой заменой на API Gateway и Event Bus.

В текущей архитектуре ESB может содержать:

- транспортную интеграцию;
- маршрутизацию;
- форматно-логический контроль;
- трансформации сообщений;
- batch/stream transformations;
- retry, DLQ и идемпотентность;
- оркестрацию;
- часть бизнес-логики.

Поэтому roadmap предусматривает декомпозицию ответственности ESB:

| Ответственность ESB | Целевое место |
| --- | --- |
| Синхронный транспорт | API Gateway |
| Асинхронный транспорт | Event Bus |
| ФЛК | Domain Validators / Data Contracts |
| Трансформации | Anti-Corruption Layer / Mapping Services |
| Пакетные и потоковые трансформации | Data Platform Ingestion Pipelines |
| Retry / DLQ | Event Bus reliability patterns |
| Идемпотентность | Consumer Services / Idempotency Keys |
| Бизнес-логика | Domain Services |
| Legacy routes | Legacy Adapter / Strangler Layer |

Этапы вывода ESB:

1. Инвентаризация Camel routes.
2. Классификация маршрутов по типам ответственности.
3. Перенос transport routes в API Gateway и Event Bus.
4. Перенос ФЛК в validators и data contracts.
5. Перенос трансформаций в anti-corruption layer, mapping services и data pipelines.
6. Перенос бизнес-логики в доменные сервисы.
7. Отключение перенесённых Camel routes.
8. Сохранение Apache Camel только как временного legacy adapter до полного вывода.

В tech radar Apache Camel остаётся в Hold как место для новой логики. Новые интеграции, проверки, трансформации и бизнес-правила в Camel не добавляются.