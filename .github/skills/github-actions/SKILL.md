---
name: github-actions
description: "Застосовувати для створення .github/workflows/ci.yml з matrix CI для Linux, Windows і macOS через наявні ci.sh та ci.bat."
---

# GitHub Actions

## Коли застосовувати

Застосовуй цей skill, коли потрібно створити або безпечно доповнити workflow GitHub Actions для складання C++-проєкту на Linux, Windows і macOS через наявні скрипти `ci.sh` та `ci.bat`.

Не створюй сам workflow, якщо користувач просить лише підготувати або змінити цей skill.

## Входи

- наявний файл `ci.sh` у корені репозиторію;
- наявний файл `ci.bat` у корені репозиторію.

Якщо будь-який із цих файлів відсутній або вхідні дані неоднозначні, зупинися та повідом, яких даних бракує.

## Виходи

- файл `.github/workflows/ci.yml`, який:
  - запускається на `push` і `pull_request` до гілок `develop` і `master`;
  - містить одну job із matrix для `ubuntu-latest`, `windows-latest` і `macos-latest`;
  - має вимкнений `fail-fast`;
  - використовує офіційні actions `actions/checkout` і `actions/upload-artifact` в актуальних мажорних версіях;
  - запускає `bash ci.sh` на Linux і macOS;
  - запускає `ci.bat` на Windows через `shell: cmd`;
  - зберігає виконуваний файл як артефакт із назвою, що містить назву ОС;
  - використовує шлях `build/hello` для Linux і macOS, а для Windows у багаторядковому `path` вказує `build/hello.exe` і `build/Release/hello.exe`, зберігаючи файл, який існує;
  - не містить прямих команд `cmake` або `ctest`, а викликає лише скрипти складання;
  - не містить секретів, токенів або паролів.

## Кроки

1. Перевір наявність `ci.sh` і `ci.bat` у корені репозиторію.
2. Перед створенням каталогу або файлу перевір, чи він уже існує.
3. Створи каталог `.github/workflows/`, якщо він відсутній.
4. Створи `.github/workflows/ci.yml` із тригерами `push` і `pull_request` для гілок `develop` та `master`.
5. Додай одну job із matrix `os: [ubuntu-latest, windows-latest, macos-latest]` і `fail-fast: false`.
6. Додай крок checkout через офіційний `actions/checkout` в актуальній мажорній версії.
7. Додай умовні кроки запуску: `bash ci.sh` для Linux і macOS; `ci.bat` із `shell: cmd` для Windows.
8. Додай умовні кроки `actions/upload-artifact` в актуальній мажорній версії з назвою артефакту, що містить `${{ matrix.os }}`. Для Windows задай багаторядковий `path` із `build/hello.exe` і `build/Release/hello.exe`, щоб зберігався файл, який існує.
9. Переконайся, що workflow не містить прямих команд `cmake` або `ctest` і не містить секретів.
10. Не дублюй job або тригери, якщо `.github/workflows/ci.yml` уже існує, і не перезаписуй наявний файл без потреби.

## Перевірки

Після виконання перевір:

- YAML синтаксично коректний;
- у matrix присутні `ubuntu-latest`, `windows-latest` і `macos-latest`;
- тригери `push` і `pull_request` налаштовані для гілок `develop` і `master`;
- використовується одна job із вимкненим `fail-fast`;
- Linux і macOS запускають `bash ci.sh`, а Windows запускає `ci.bat` через `shell: cmd`;
- для Linux і macOS шлях артефакту — `build/hello`, а для Windows багаторядковий `path` містить `build/hello.exe` і `build/Release/hello.exe`, зберігаючи файл, який існує;
- у workflow немає прямих команд `cmake` або `ctest`;
- складання не продубльоване у workflow і не містить секретів.

## Дії при помилці

Якщо будь-який крок або перевірка не пройшли:

1. негайно зупинися;
2. не перезаписуй і не видаляй наявні файли;
3. повідом назву кроку або перевірки, що не пройшла;
4. наведи коротку причину помилки та перелік уже виконаних змін;
5. не продовжуй до отримання подальших вказівок.

## Приклад входу й очікуваний результат

**Вхід:**

- у корені репозиторію існують `ci.sh` і `ci.bat`.

**Очікуваний результат:**

Створено `.github/workflows/ci.yml` з одним matrix-job для `ubuntu-latest`, `windows-latest` і `macos-latest`, запуском на `push` та `pull_request` до `develop` і `master`, а також умовним викликом відповідного скрипту. Для кожної ОС збережено виконуваний файл як артефакт із назвою, що містить назву ОС. Workflow не містить прямих команд `cmake` або `ctest` і не містить секретів.

## Типовий сценарій помилки

Якщо `.github/workflows/ci.yml` уже містить job або тригери, не додавай дублікати. Якщо відсутній `ci.sh` чи `ci.bat`, YAML некоректний, у matrix немає однієї з ОС або workflow містить прямий виклик `cmake` чи `ctest`, зупинися, повідом причину та не перезаписуй наявний файл.
