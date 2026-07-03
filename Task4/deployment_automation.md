# Автоматизация развёртывания

## Последовательность запуска

1. Подготовить облачный аккаунт и folder.
2. Получить `cloud_id` и `folder_id`.
3. Подготовить SSH public key.
4. Заполнить `terraform.tfvars`.
5. Выполнить Terraform-команды.
6. Сделать скриншот успешного `apply`.
7. Закоммитить конфигурации и скриншот.

## Проверка окружения

```bash
terraform version
yc --version
```

## Аутентификация

Токен не хранится в репозитории.

Пример через Yandex Cloud CLI:

```bash
yc init
export YC_TOKEN="$(yc iam create-token)"
```

## Заполнение terraform.tfvars

Нужно заменить значения:

```hcl
cloud_id       = "REPLACE_WITH_CLOUD_ID"
folder_id      = "REPLACE_WITH_FOLDER_ID"
ssh_public_key = "ssh-ed25519 REPLACE_WITH_PUBLIC_KEY user@example"
admin_cidrs    = ["YOUR_PUBLIC_IP/32"]
```

Получить внешний IP:

```bash
curl ifconfig.me
```

## Команды Terraform

```bash
cd Task4

terraform fmt
terraform init
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

## Скриншот apply

```bash
mkdir -p screenshots
gnome-screenshot -a -f screenshots/terraform-apply-success.png
```

На скриншоте должно быть видно, что `terraform apply` завершился успешно.

## Проверка outputs

```bash
terraform output
```

## Удаление стенда после проверки

```bash
terraform destroy
```

Удаление выполнять только если инфраструктура больше не нужна.
