# Архітектура

## Проблеми, які вирішує агент

Агент `build-engineer` організовує створення та перевірку кросплатформного навчального проєкту Hello World на C++17. Він описує послідовність підготовки Git, структури проєкту, CMake/GoogleTest/CTest, GitHub Actions і фінальної перевірки. Агент також задає безпечну роботу з файлами: перевірку наявності перед створенням, відсутність зайвого перезапису та відсутність дублювання під час повторного запуску.

## Skills

Агент використовує три skills:

- `project-scaffold` — створює мінімальну структуру C++ Hello World у корені репозиторію: `src/`, `tests/`, `src/main.cpp`, доповнення `.gitignore` і `README.md`.
- `build-and-test` — додає функцію `add(int, int)`, тест `BasicAddition`, CMake з GoogleTest через `FetchContent`, CTest, а також `ci.sh` і `ci.bat`.
- `github-actions` — створює або безпечно доповнює `.github/workflows/ci.yml` з matrix для Linux, Windows і macOS через наявні скрипти.

## Доступні commands

Доступні prompt-команди, прив’язані до агента `build-engineer`:

- `/git-init` — перевіряє Git-репозиторій, доповнює `.gitignore` і показує `git status`.
- `/create-project` — виконує `project-scaffold` для C++-проєкту `hello`.
- `/create-build` — виконує `build-and-test` за наявності `src/main.cpp`.
- `/create-actions` — виконує `github-actions` за наявності `ci.sh` і `ci.bat`.
- `/check` — перевіряє структуру, складання, тести, CI та Git; під час складання може створювати або оновлювати лише `build/`.
- `/init` — послідовно виконує всі наведені команди та завершується лише після успішного `/check`.

## Передавання даних між етапами

| Етап | Вхід | Результат для наступного етапу |
|---|---|---|
| `/git-init` | Git-репозиторій або можливість визначити його корінь | корінь репозиторію, `.gitignore`, стан Git |
| `/create-project` | мова C++, назва `hello` | `src/`, `tests/`, `src/main.cpp`, README.md, `.gitignore` |
| `/create-build` | наявний `src/main.cpp` | `src/add.h`, `src/add.cpp`, `tests/test_add.cpp`, `CMakeLists.txt`, `ci.sh`, `ci.bat` |
| `/create-actions` | наявні `ci.sh` і `ci.bat` | `.github/workflows/ci.yml` із matrix, тригерами та артефактами |
| `/check` | усі попередні файли та Git-репозиторій | статус `OK`/`FAIL`, підсумок перевірок і результат `пройдено` або `не пройдено` |

Кожен етап перевіряє передумови та результат попереднього етапу. Повторний запуск не має руйнувати наявне і не має дублювати конфігурації.

## Обробка помилок оркестратором

`/init` виконує етапи в порядку `git-init` → `create-project` → `create-build` → `create-actions` → `check`. Перед кожним етапом він читає відповідний prompt і виконує всі його інструкції та перевірки. Якщо передумова, команда або перевірка не пройшла, `/init` зупиняється, не запускає наступні етапи й повідомляє назву кроку, причину, код завершення, якщо він доступний, і вже виконані зміни. Успішним увесь процес є лише після успішного `check`. Коміти та надсилання на GitHub не виконуються.

## Файл — його роль

| Файл | Роль |
|---|---|
| `.github/agents/build-engineer.agent.md` | Визначає роль агента, межі відповідальності, заборони, порядок роботи та критерії завершення. |
| `.github/skills/project-scaffold/SKILL.md` | Описує створення мінімального Hello World-проєкту. |
| `.github/skills/build-and-test/SKILL.md` | Описує CMake, бібліотеку `add`, GoogleTest, CTest і скрипти складання. |
| `.github/skills/github-actions/SKILL.md` | Описує workflow GitHub Actions для трьох ОС. |
| `.github/prompts/git-init.prompt.md` | Команда підготовки Git і `.gitignore`. |
| `.github/prompts/create-project.prompt.md` | Команда запуску `project-scaffold`. |
| `.github/prompts/create-build.prompt.md` | Команда запуску `build-and-test`. |
| `.github/prompts/create-actions.prompt.md` | Команда запуску `github-actions`. |
| `.github/prompts/check.prompt.md` | Команда фінальної перевірки структури, складання, тестів, CI та Git. |
| `.github/prompts/init.prompt.md` | Оркестратор усіх етапів у визначеному порядку. |
| `README.md` | Основна інформація про лабораторну роботу, проєкт і запуск агента. |
| `docs/architecture.md` | Опис архітектури та передавання даних між етапами. |
| `docs/usage.md` | Інструкції запуску prompt-команд і локальної перевірки. |
| `src/main.cpp` | Hello World-програма, яку створює `project-scaffold`, якщо файла немає. |
| `src/add.h`, `src/add.cpp` | Оголошення та реалізація функції `add(int, int)`, які створює `build-and-test`. |
| `tests/test_add.cpp` | GoogleTest із тестом `BasicAddition`. |
| `CMakeLists.txt` | Конфігурація CMake, цілі `hello` і тестового виконуваного файла. |
| `ci.sh`, `ci.bat` | Скрипти конфігурації, складання та запуску CTest. |
| `.github/workflows/ci.yml` | CI matrix для `ubuntu-latest`, `windows-latest` і `macos-latest`. |
