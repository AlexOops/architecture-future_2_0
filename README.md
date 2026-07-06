# architecture-future_2_0

Проектная работа 11 спринта.

Кейс: компания «Будущее 2.0».

## О проекте

«Будущее 2.0» — компания с медицинским, финтех- и AI-направлениями.  
Текущая архитектура завязана на legacy DWH на SQL Server 2008, PowerBuilder, Power BI и старую интеграционную шину Apache Camel.

Основная проблема: DWH стал центром хранения данных, отчётности, интеграций и бизнес-логики. Из-за этого отчёты строятся часами, новые направления развиваются медленно, а подключение партнёров требует изменений в legacy-ландшафте.

## Цель решения

Спроектировать целевую архитектуру, которая позволит:

- ускорить подготовку отчётности;
- запустить self-service data portal;
- разделить систему на независимые домены;
- снизить зависимость от legacy DWH;
- вынести бизнес-логику из DWH в доменные сервисы;
- подключать финтех-, AI-, фармацевтические и device-направления через стандартные контракты;
- подготовить облачную инфраструктуру через Terraform.

## Что сделано

### Task1 — Целевая архитектура и приоритизация проблем

Спроектирована C4 Container архитектура целевого состояния через год.

Подготовлено:

- контейнерная диаграмма целевой архитектуры;
- анализ проблемных мест текущего состояния;
- приоритизация проблем по MoSCoW;
- связь проблем с бизнес-сценариями.

Файлы:

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

Ключевое решение:

- legacy DWH остаётся временным read-only источником;
- новая логика переносится в доменные сервисы;
- отчётность строится через Lakehouse, Analytical DWH, Semantic Layer и Self-service Data Portal.

### Task2 — Домены и потоки данных

Система разделена на домены, чтобы направления могли развиваться независимо.

Выделены домены:

- Clinical Domain;
- Medical Records Boundary;
- Fintech Domain;
- AI Domain;
- Partner Domain;
- Corporate Domain;
- Data Platform Domain;
- Governance Domain.

Подготовлено:

- DFD потоков данных между доменами;
- обоснование доменной декомпозиции;
- описание потоков для ключевых бизнес-сценариев.

Файлы:

```text
Task2/
├── README.md
├── data_flow_analysis.md
├── domain_decomposition.md
└── diagrams/
    ├── data_flow_domains.puml
    └── pictures/
        └── data_flow_domains.png
```

Ключевое решение:

- домены обмениваются данными через API, Event Bus и Data Contracts;
- Data Platform получает данные как data products;
- медицинские карты, истории болезней и результаты исследований не публикуются в self-service витрину.

### Task3 — Техрадар и roadmap изменений

Подготовлен технологический радар и roadmap трансформации на один год.

Подготовлено:

- tech radar с категориями Adopt / Trial / Assess / Hold;
- roadmap изменений;
- обоснование этапов с точки зрения бизнес-целей;
- диаграммы техрадара и roadmap.

Файлы:

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

Ключевое решение:

- в Adopt вынесены Cloud Data Platform, Lakehouse, Data Products, Data Contracts, Data Catalog, Lineage, Semantic Layer, API Gateway, Event Bus, Terraform;
- в Hold вынесены SQL Server 2008 как центральный DWH, бизнес-логика в DWH, PowerBuilder для новых процессов, прямой BI-доступ к DWH.

### Task4 — Облачная инфраструктура и Terraform

Спроектирована и проверена базовая IaaS-инфраструктура для data-платформы.

Подготовлено:

- Terraform-конфигурация;
- диаграмма автоматизации развёртывания;
- обоснование выбранных ресурсов;
- инструкция по запуску;
- скриншот успешного выполнения `terraform apply`.

Файлы:

```text
Task4/
├── README.md
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── justification.md
├── deployment_automation.md
├── diagrams/
│   ├── deployment_automation.puml
│   └── pictures/
│       └── deployment_automation.png
└── screenshots/
    ├── terraform-apply-success.png
    └── terraform-apply-output.txt
```

Terraform создаёт:

- VPC network;
- public subnet;
- private subnet;
- NAT Gateway;
- route table;
- security groups;
- bastion VM;
- self-service portal VM;
- integration VM;
- data platform VM;
- observability VM;
- дополнительный диск для data platform.

Проверено:

```text
terraform init
terraform validate
terraform plan
terraform apply
terraform output
```

## Общая структура проекта

```text
architecture-future_2_0/
├── Task1/
├── Task2/
├── Task3/
├── Task4/
├── docs/
├── scripts/
├── .gitignore
└── README.md
```

## Диаграммы

Все диаграммы выполнены в PlantUML.

Исходники:

```text
Task*/diagrams/*.puml
```

## Ключевые архитектурные решения

- Декомпозировать систему на домены.
- Перенести бизнес-логику из DWH в доменные сервисы.
- Использовать Data Products и Data Contracts для обмена данными.
- Построить self-service data portal поверх semantic layer.
- Использовать Lakehouse и curated marts для ускорения отчётности.
- Сохранять legacy DWH как read-only источник на период миграции.
- Подключать новые бизнесы через API Gateway, Event Bus и Partner Domain.
- Не включать медицинские карты, истории болезней и результаты исследований в self-service витрину.
- Управлять инфраструктурой через Terraform.
- Разворачивать окружения воспроизводимо через Infrastructure as Code.