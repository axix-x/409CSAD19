# 409CSAD19
Лабораторні роботи з АПКС. Ребенчак Святослав, КІ-409

## Відомості про роботу

- ПІП: Ребенчак Святослав Володимирович
- Група: КІ-409
- Варіант: 1 — C++, CMake, GoogleTest/CTest

## Опис проєкту

Проєкт містить конфігурацію агента GitHub Copilot для створення, складання та перевірки кросплатформного C++17 Hello World-проєкту з CMake, GoogleTest, CTest і GitHub Actions.

## Запуск агента

У чаті Copilot виберіть агента `build-engineer` і виконайте команду:

`/init`

## Hello project

Цей репозиторій містить базовий C++17 проєкт `hello` з використанням CMake, GoogleTest і CTest.

Команда запуску:

```bash
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release
ctest --test-dir build -C Release --output-on-failure
```

