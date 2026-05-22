# devops-diploma

В ходе выполнения дипломной работы были проделаны следующие действия:

## Создание облачной инфраструктуры

Было подготовлено две конфигурации Terraform:

1. Конфигурация backend'а (каталог [terraform-backend-init](https://github.com/RiteHist/devops-diploma/tree/main/src/terraform-backend-init)):

Создается S3 bucket для хранения state файла, таблица в YDB для блокировки state файла во время использования, сервисные аккаунты для доступа к бакету и для создания будущей инфрастурктуры. По окончании, создаются файлы authorized_key.json с данными сервисного аккаунта, файл backend.hcl с конфигурацией backend'а, и скрипт tfinit.sh запускающий `terraform init` с данными  сервисного аккаунта с доступом к бакету со state файлом.

Созданный бакет:

![alt text](https://github.com/ritehist/devops-diploma/blob/main/media/1.PNG?raw=true)

Созданные сервисные аккаунты:

![alt text](https://github.com/ritehist/devops-diploma/blob/main/media/2.PNG?raw=true)

2. Конфигурация основной инфраструктуры (каталог [terraform-main-infra](https://github.com/RiteHist/devops-diploma/tree/main/src/terraform-main-infra)):

Через данную конфигурацию создаются следующие ресурсы:

- VPC.
- Три подсети под зоны доступности a, b и d.
- Виртуальная машина, выполняющая роль NAT, находящаяся в зоне доступности a.
- Несколько виртуальных машин, выполняющих роли рабочих нод в будущем кластере k8s, распределенных между зонами b и d.
- Виртуальная машина, выполняющая роль control plane ноды.
- Сетевой балансировщик, который перенаправляет трафик на рабочие ноды по HTTP.

Все виртуальные машины, кроме NAT инстанса, не имеют публичного IP и общаются с внешним миром через NAT. Балансировщик используется для доступа к приложениям внутри будущего кластера по 80 порту.

После создания инфраструктуры, Terraform генерирует файлы inventory.ini (из шаблона [inventory.tftpl](https://github.com/RiteHist/devops-diploma/blob/main/src/ansible/playbook/inventory/inventory.tftpl)) с адресами ВМ и файл переменных all.yaml для ansible (из шаблона [all.tftpl](https://github.com/RiteHist/devops-diploma/blob/main/src/ansible/playbook/inventory/group_vars/all.tftpl)).

Созданные виртуальные машины:

![alt text](https://github.com/ritehist/devops-diploma/blob/main/media/3.PNG?raw=true)

## Создание Kubernetes кластера

Для выполнения данного этапа было решено использовать kubespray. В каталоге [src/ansible/playbook](https://github.com/RiteHist/devops-diploma/tree/main/src/ansible/playbook) расположены файлы для запуска playbook'а, который запускает kubespray. Для удобства использования на локальной машине, был сделан скрипт [start_kubespray.sh](https://github.com/RiteHist/devops-diploma/blob/main/src/ansible/playbook/start_kubespray.sh), который запускает виртуальное окружение, скачивает правильные версии необходимых для kubesrpay зависимостей и запускает ansible playbook. В работе используется версия kubespray release-2.30, т.к. это последняя версия, в которой содержится установка nginx-ingress-controller, который используется для применения ingress конфигураций. 

При запуске плэйбука на локальной машине, после окончания выполнения, также создается каталог `inventory/artifacts`, где лежит файл admin.conf, с данными для подключения к кластеру. 

Результат выполнения команды `kubectl get nodes`:

![alt text](https://github.com/ritehist/devops-diploma/blob/main/media/4.PNG?raw=true)

## Создание тестового приложения

Для данного этапа в [отдельном репозитории](https://github.com/RiteHist/devops-diploma-app) был создан простой [Dockerfile](https://github.com/RiteHist/devops-diploma-app/blob/main/Dockerfile), который запускает nginx со статической HTML страницей.
Образ загружен в [репозиторий Docker Hub](https://hub.docker.com/repository/docker/ritehist/nginx-with-amazing-webpage/general)

## Подготовка системы мониторинга и деплой приложения

В [отдельном репозитории](https://github.com/RiteHist/devops-diploma-kube) были созданы два каталога:

1. [kube-prometheus-stack](https://github.com/RiteHist/devops-diploma-kube/tree/main/src/kube-prometheus-stack):

Для решения данного этапа было решено использовать [готовый helm чарт](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack). В файле [values.yaml](https://github.com/RiteHist/devops-diploma-kube/blob/main/src/kube-prometheus-stack/values.yaml) были заданы настройки grafana, которые позволяют ей работать через ingress. Сама конфигурация ingress для grafana описана в манифесте [grafana-ingress.yaml](https://github.com/RiteHist/devops-diploma-kube/blob/main/src/kube-prometheus-stack/grafana-ingress.yaml). Для удобства установки системы мониторинга в кластер с локальной машины был сделан небольшой скрипт [install_prometheus_stack.sh](https://github.com/RiteHist/devops-diploma-kube/blob/main/src/kube-prometheus-stack/install_prometheus_stack.sh), который устанавливает helm чарт, ingress для grafana и выводит в консоль пароль администратора для входа в grafana.

2. [app-config](https://github.com/RiteHist/devops-diploma-kube/tree/main/src/app-config):

В данном каталоге расположены манифесты для запуска подготовленного ранее приложения. Создается отдельный [namespace](https://github.com/RiteHist/devops-diploma-kube/blob/main/src/app-config/0-prod-namespace.yaml), [deployment для подов](https://github.com/RiteHist/devops-diploma-kube/blob/main/src/app-config/1-deployment.yaml), [сервис](https://github.com/RiteHist/devops-diploma-kube/blob/main/src/app-config/2-service.yaml) и [конфигурация ingress](https://github.com/RiteHist/devops-diploma-kube/blob/main/src/app-config/3-ingress.yaml).

После установки манифестов в кластер приложение становится доступно по 80 порту при заходе на созданный ранее Terraform'ом NLB. Интерфейс grafana доступен по `<NLB-IP>/grafana`.

Страница приложения:

![alt text](https://github.com/ritehist/devops-diploma/blob/main/media/5.PNG?raw=true)

Страница логина в grafana:

![alt text](https://github.com/ritehist/devops-diploma/blob/main/media/6.PNG?raw=true)

Дашборд, показывающий метрики кластера:

![alt text](https://github.com/ritehist/devops-diploma/blob/main/media/7.PNG?raw=true)

## Установка и настройка CI/CD

Для данного этапа было решено сделать все CI/CD пайплайны через Github Actions.

В репозитории, содержащем конфигурацию Terraform (данный репозиторий), был создан файл [terraform-pr.yml](https://github.com/RiteHist/devops-diploma/blob/main/.github/workflows/terraform-pr.yml). Данный workflow выполняет следующие действия:

- При создании PR происходит запуск `terraform plan`.
- При push в main ветку происходит запуск `terraform apply`.
- Если был сделан `terraform apply` и были изменены или созданы ресурсы, помеченные лэйблом "k8s", то также запускается ansible playbook с kubespray.
- Если был запущен kubespray, то также происходит загрузка в кластер helm чарта kube-prometheus-stack и конфигурация приложения.

Результат при создании PR:

![alt text](https://github.com/ritehist/devops-diploma/blob/main/media/8.PNG?raw=true)

Результат при merge:

![alt text](https://github.com/ritehist/devops-diploma/blob/main/media/9.PNG?raw=true)

![alt text](https://github.com/ritehist/devops-diploma/blob/main/media/10.PNG?raw=true)

В репозитории, [содержащем приложение](https://github.com/RiteHist/devops-diploma-app/tree/main), был создан файл [docker-push.yml](https://github.com/RiteHist/devops-diploma-app/blob/main/.github/workflows/docker-push.yml). Данный workflow выполняет следующие действия:

- При push в main ветку происходит сборка Docker образа и отправка его в Docker Hub.
- Если коммиту был присвоен тег, то образ помечается этим тегом и дополнительно происходит этап деплоя данного образа в кластере k8s.

Образ в Docker Hub с добавленными тегами:

![alt text](https://github.com/ritehist/devops-diploma/blob/main/media/11.PNG?raw=true)

Результаты выполнения workflow:

![alt text](https://github.com/ritehist/devops-diploma/blob/main/media/12.PNG?raw=true)

Проверка, что в подах загружается корректная версия образа:

![alt text](https://github.com/ritehist/devops-diploma/blob/main/media/13.PNG?raw=true)
