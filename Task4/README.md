# Task4 — Облачная инфраструктура и Terraform

## Цель

Спроектировать облачную инфраструктуру для целевой data-платформы «Будущее 2.0» и описать её через Terraform.

## Что подготовлено

- Terraform-конфигурация;
- диаграмма автоматизации развёртывания;
- обоснование выбора ресурсов;
- инструкция по запуску `terraform init`, `plan`, `apply`;
- место для скриншота успешного `terraform apply`.

## Структура

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
    └── terraform-apply-success.png
```

## Что создаёт Terraform

- VPC network;
- public subnet;
- private subnet;
- NAT Gateway;
- route table для private subnet;
- security groups;
- bastion VM;
- self-service portal VM;
- integration VM;
- data platform VM;
- observability VM;
- дополнительный диск для data platform.

## Что остаётся ручным

- создание cloud account и billing;
- создание folder/project;
- получение Terraform credentials;
- настройка DNS;
- выпуск production TLS-сертификатов;
- деплой прикладного кода;
- финальное подключение доменных сервисов и data pipelines.

## Запуск Terraform

```bash
cd Task4
terraform fmt
terraform init
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```