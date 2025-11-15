# Starter Repo (Учебный шаблон)

Минимальный проект для ЛР-1: compose.yaml (+service `app`), тесты, pre-commit, скрипты.

## Быстрый старт

```bash
# Вариант A: Docker Compose v2
docker compose up -d --build
# Вариант B: Docker Compose v1
docker-compose up -d --build
# Проверка
./scripts/mini-smoke.sh
```

## Без Docker (fallback)
```bash
python3 -m venv .venv && . ./.venv/bin/activate
pip install -r requirements.txt
python -m pytest -q
```


## Права на скрипты (важно)
Если при запуске скриптов видите Permission denied:

```bash
chmod +x scripts/*.sh
# Зафиксировать исполняемый бит в Git (пример):
git update-index --chmod=+x scripts/mini-smoke.sh
# Либо добавить с правами сразу:
git add --chmod=+x scripts/bisect_demo_init.sh
```

## Полезно
- Имя сервиса в compose.yaml — `app`. Если меняете, поправьте команды.
- pre-commit: `pre-commit install` и `pre-commit run -a`.
- Bisect: `git bisect run scripts/bisect_test.sh`.

## ADR (пример)
Создайте `docs/adr/0001-dev-environment.md` по шаблону из курса.

