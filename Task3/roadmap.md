# Roadmap изменений

## Горизонт планирования

Roadmap рассчитан на один год.

Цель через пару месяцев:

- архитектурное решение согласовано;
- границы доменов определены;
- ключевые связи между доменами описаны;
- проекты по развитию self-service витрины данных запланированы.

Цель через год:

- запущен портал самообслуживания;
- домены работают с данными в рамках новой архитектуры;
- legacy-системы временно сохранены только там, где это снижает риск миграции.

## Этап 0. Архитектурная фиксация

Срок: 0–2 месяца.

| Направление | Работы |
|---|---|
| Архитектура | утвердить целевую C4-архитектуру и домены |
| Данные | определить data products и владельцев данных |
| Безопасность | зафиксировать запрет medical records в self-service витрине |
| Интеграции | выбрать API Gateway, Event Bus и data contracts |
| Инфраструктура | выбрать облачную платформу и подход Terraform |

Ожидаемый результат:

- утверждены доменные границы;
- согласован путь миграции legacy DWH;
- определены первые data products;
- запланированы проекты MVP.

Ответственные команды:

- Architecture Team;
- Data Platform Team;
- Security Team;
- Medical, Fintech, AI Domain Teams.

Необходимые ресурсы:

- архитектор данных;
- solution architect;
- security architect;
- domain leads;
- data steward.

## Этап 1. Фундамент data-платформы

Срок: 2–4 месяца.

| Направление | Работы |
|---|---|
| Cloud | поднять базовую облачную инфраструктуру через Terraform |
| Data Platform | развернуть Lakehouse, ingestion и catalog |
| Governance | ввести Data Catalog, ownership, lineage |
| Security | подключить IAM, RBAC/ABAC и политики доступа |
| Legacy | сделать read-only Legacy Adapter к SQL Server 2008 |

Ожидаемый результат:

- есть базовая data-платформа;
- данные из legacy DWH можно забирать контролируемо;
- новые data products регистрируются в каталоге;
- доступ к данным управляется ролями и политиками.

Ответственные команды:

- Platform Team;
- Data Engineering Team;
- Security Team;
- Legacy Migration Team.

Необходимые ресурсы:

- cloud engineer;
- data engineer;
- DevOps engineer;
- security engineer.

## Этап 2. MVP self-service портала

Срок: 4–6 месяцев.

| Направление | Работы |
|---|---|
| Data Portal | реализовать поиск наборов данных и запуск отчётов |
| Semantic Layer | определить первые KPI и метрики |
| BI | перевести ключевые отчёты на curated marts |
| Data Quality | добавить проверки качества данных |
| Access | настроить row/column security и masking |

Ожидаемый результат:

- бизнес-пользователь может собрать отчёт через портал;
- ключевые KPI считаются одинаково;
- сложные отчёты не строятся напрямую в SQL Server 2008;
- medical records не попадают в self-service витрину.

Ответственные команды:

- Data Platform Team;
- BI Team;
- Product Team;
- Security Team.

Необходимые ресурсы:

- backend/frontend engineers;
- BI engineer;
- data analyst;
- data steward.

## Этап 3. Независимое развитие доменов

Срок: 6–9 месяцев.

| Направление | Работы |
|---|---|
| Fintech | вынести финтех-логику в Fintech Domain Services |
| AI | оформить AI Domain и контролируемый доступ к medical data |
| Medical | выделить Clinical Domain и Medical Records Boundary |
| Partners | создать Partner Domain для фармы и электроники |
| Integration | подключить API Gateway, Event Bus и contracts |

Ожидаемый результат:

- финтех и AI могут развиваться отдельными релизными циклами;
- новые партнёры подключаются через стандартный integration pattern;
- бизнес-логика больше не добавляется в DWH;
- legacy DWH теряет роль центра изменений.

Ответственные команды:

- Fintech Team;
- AI Team;
- Medical Team;
- Partner Integration Team;
- Platform Team.

Необходимые ресурсы:

- backend engineers;
- integration engineer;
- data engineer;
- security engineer;
- domain product owners.

## Этап 4. Масштабирование и оптимизация

Срок: 9–12 месяцев.

| Направление | Работы |
|---|---|
| Performance | оптимизировать query engine и marts |
| Migration | перенести критичные отчёты с legacy DWH |
| Observability | внедрить метрики, tracing, alerting |
| Cost control | настроить лимиты и FinOps-практики |
| Governance | расширить data products и lineage |

Ожидаемый результат:

- отчётность работает быстрее и стабильнее;
- legacy DWH используется как архив или временный источник;
- новые бизнесы подключаются без изменения DWH;
- облачные расходы контролируются;
- качество медицинских и финансовых сервисов поддерживается мониторингом и SLA.

Ответственные команды:

- Platform Team;
- Data Platform Team;
- SRE/Observability Team;
- Domain Teams;
- FinOps.

Необходимые ресурсы:

- SRE;
- data engineer;
- cloud engineer;
- FinOps specialist;
- QA/performance engineer.

## Сводный roadmap

| Этап | Срок | Основной результат | Бизнес-цель |
|---|---|---|---|
| 0. Архитектурная фиксация | 0–2 месяца | домены и целевая архитектура согласованы | снизить риск хаотичной миграции |
| 1. Фундамент data-платформы | 2–4 месяца | Lakehouse, Catalog, IAM, Terraform | масштабирование и контроль данных |
| 2. MVP self-service портала | 4–6 месяцев | первые отчёты через portal + semantic layer | ускорение принятия решений |
| 3. Независимые домены | 6–9 месяцев | Fintech, AI, Medical, Partner развиваются отдельно | time-to-market новых продуктов |
| 4. Масштабирование | 9–12 месяцев | оптимизация, observability, миграция legacy | стабильность и снижение затрат |
