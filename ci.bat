@echo off
setlocal

cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
if errorlevel 1 exit /b %errorlevel%

cmake --build build --config Release
if errorlevel 1 exit /b %errorlevel%

ctest --test-dir build -C Release --output-on-failure
if errorlevel 1 exit /b %errorlevel%
