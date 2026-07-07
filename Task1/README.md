# Task1 — Целевая архитектура и приоритизация проблем

## Цель

Спроектировать целевую архитектуру «Будущее 2.0» через год и показать, как она поддерживает ключевые бизнес-сценарии:

- быстрая подготовка отчётности;
- независимое развитие медицинского, финтех- и ИИ-направлений;
- подключение новых бизнесов;
- масштабирование работы с данными;
- вынос бизнес-логики из legacy DWH и legacy ESB;
- поэтапный вывод Apache Camel с декомпозицией его ответственности;
- безопасная аналитика без медицинских карт, историй болезней и результатов исследований.

## Что подготовлено

- C4 Container диаграмма целевого состояния.
- Анализ проблемных мест As-Is.
- Приоритизация проблем по MoSCoW с привязкой к бизнес-целям.
- Стратегия вывода Apache Camel / legacy ESB с разбором ФЛК, трансформаций, надёжности и бизнес-логики.

## Структура

```text
Task1/
├── README.md
├── bottlenecks_analysis.md
├── priorities.md
├── esb_decommission_strategy.md
└── diagrams/
    ├── future_target_container_c4.puml
    ├── esb_decommission_responsibilities.puml
    └── pictures/
        ├── future_target_container_c4.png
        └── esb_decommission_responsibilities.png
```

## Диаграмма

Исходники:

```text
Task1/diagrams/future_target_container_c4.puml
Task1/diagrams/esb_decommission_responsibilities.puml
```

## Основное решение

Целевая архитектура строится вокруг доменов и data products.

DWH больше не является местом, куда складывают всю бизнес-логику. Он становится частью аналитического слоя, а бизнес-правила переносятся в доменные сервисы.

Apache Camel / legacy ESB также выводится из роли центра интеграционной и бизнес-логики. В целевой архитектуре он не заменяется только на API Gateway и Event Bus, потому что эти компоненты закрывают только транспортный слой.

Ключевые блоки:

- доменные сервисы для медицинского, финтех-, ИИ- и корпоративного направлений;
- self-service data portal;
- semantic layer / metrics store;
- lakehouse / cloud data platform;
- каталог данных и lineage;
- data governance layer;
- API Gateway и Event Bus;
- domain validators и data contracts для ФЛК и проверки схем;
- anti-corruption layer / mapping services для трансформаций и защиты новых доменов от legacy-моделей;
- reliability patterns на уровне Event Bus и consumer services: retry, DLQ, идемпотентность;
- read-only legacy adapter для поэтапной миграции SQL Server 2008 и PowerBuilder;
- legacy integration adapter / strangler layer для поэтапного вывода Apache Camel.

## Что происходит с Apache Camel / legacy ESB

Apache Camel в As-Is архитектуре не рассматривается только как транспортная шина. В нём могут находиться:

- маршрутизация между системами;
- форматно-логический контроль;
- пакетные и потоковые трансформации;
- retry, dead letter queue и идемпотентность;
- оркестрация процессов;
- часть бизнес-логики.

Поэтому в целевой архитектуре Apache Camel не заменяется только на API Gateway и Event Bus.  
API Gateway и Event Bus закрывают транспортный слой: синхронные API и асинхронные события.

Остальная ответственность ESB переносится в целевые компоненты:

| Ответственность Apache Camel | Целевой компонент |
| --- | --- |
| Синхронный транспорт | API Gateway + доменные API |
| Асинхронный транспорт | Event Bus |
| Маршрутизация | Integration Layer / Event Routing |
| Форматно-логический контроль | Domain Validators / Data Contracts |
| Трансформации сообщений | Anti-Corruption Layer / Mapping Services |
| Пакетные трансформации | Data Platform Ingestion Pipelines |
| Retry / DLQ | Event Bus reliability patterns |
| Идемпотентность | Consumer Services / Idempotency Keys |
| Бизнес-логика | Domain Services |
| Legacy routes | Legacy Adapter / Strangler Layer |

Вывод ESB выполняется поэтапно:

1. Инвентаризируются все Camel routes.
2. Каждый route классифицируется по типам ответственности: transport, validation, transformation, reliability, orchestration, business logic.
3. Транспорт переносится в API Gateway и Event Bus.
4. ФЛК переносится в domain validators и data contracts.
5. Трансформации переносятся в anti-corruption layer, mapping services и data pipelines.
6. Бизнес-логика переносится в соответствующие доменные сервисы.
7. Apache Camel временно остаётся только как legacy integration adapter.
8. После переноса маршрутов ESB выводится из критического контура.

Новая бизнес-логика, новые проверки и новые трансформации в Apache Camel не добавляются.
