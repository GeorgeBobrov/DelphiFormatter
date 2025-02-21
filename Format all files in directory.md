У меня есть программа для форматирования код (форматтер).
Мне нужно запустить её на всех файлах оприделённого типа в каталоге. Вот псевдокод:
filesInDir = GetFilesInDir("d:/test", "*.pas")
for filename in filesInDir do
    RunCmd("Formatter.exe sourceFile=" + filename + " run update")

Напиши пожалуйста это как скрипт FormatAll.cmd    

>
Вот скрипт FormatAll.cmd для Windows, который найдёт все .pas файлы в текущей директории и её поддиректориях и запустит форматтер для каждого файла:

```batch
@echo off
setlocal enabledelayedexpansion

for /R %%f in (*.pas) do (
    echo Processing: %%f
    Formatter.exe sourceFile="%%f" run update
)

echo Done!
pause
```

Если нужно запускать только в конкретной директории без поддиректорий, используйте:

```batch
@echo off
setlocal enabledelayedexpansion

for %%f in (*.pas) do (
    echo Processing: %%f
    Formatter.exe sourceFile="%%f" run update
)

echo Done!
pause
```

Если нужно указать конкретную директорию, добавьте в начало скрипта:

```batch
@echo off
setlocal enabledelayedexpansion

cd /d "D:\test"

for %%f in (*.pas) do (
    echo Processing: %%f
    Formatter.exe sourceFile="%%f" run update
)

echo Done!
pause
```

Примечания:
1. Замените `Formatter.exe` на реальное имя вашего форматтера
2. `@echo off` отключает вывод команд в консоль
3. `pause` в конце задерживает окно консоли, чтобы вы могли увидеть результат
4. Если путь к форматтеру не прописан в PATH, укажите полный путь к нему


>что значит setlocal enabledelayedexpansion

`setlocal enabledelayedexpansion` - это команда в batch-скриптах Windows, которая выполняет две функции:

1. `setlocal` - создаёт локальное окружение для переменных. Это значит, что все изменения переменных среды будут действовать только внутри скрипта и будут отменены после его завершения.

2. `enabledelayedexpansion` - включает отложенное расширение переменных, что позволяет использовать изменённые значения переменных внутри одного блока кода (например, внутри цикла).

Пример, почему это может быть важно:

```batch
@echo off
:: Без enabledelayedexpansion
set var=1
for %%i in (1 2 3) do (
    set var=%%i
    echo %var%    :: Выведет 1 три раза
)

:: С enabledelayedexpansion
setlocal enabledelayedexpansion
set var=1
for %%i in (1 2 3) do (
    set var=%%i
    echo !var!    :: Выведет 1, 2, 3
)
```

В данном случае для простого перебора файлов эта команда не обязательна, но это хорошая практика включать её в скрипты, особенно если вы планируете работать с переменными внутри циклов или условных блоков.

Кстати, в вашем конкретном случае можно убрать эту строку, так как скрипт не использует переменные внутри циклов.

>Почему в первом случае %var%  а во втором !var!

Это связано с тем, как Windows обрабатывает переменные в batch-скриптах:

1. `%var%` - это стандартное расширение переменных. Значения всех таких переменных вычисляются ПЕРЕД выполнением строки/блока кода. То есть, значение подставляется в момент чтения строки.

2. `!var!` - это отложенное расширение переменных (delayed expansion). Значения таких переменных вычисляются В МОМЕНТ выполнения строки/блока кода.

Пример для наглядности:
```batch
@echo off
set number=1
(
    echo %number%   :: Выведет 1
    set number=2
    echo %number%   :: Всё равно выведет 1
    echo !number!   :: Выведет 2
)
```

Почему так происходит:
- Когда cmd.exe читает блок в скобках (), он сначала заменяет все `%number%` на их текущие значения
- Поэтому оба `echo %number%` фактически превращаются в `echo 1` ещё до выполнения
- А `!number!` вычисляется непосредственно при выполнении команды echo, поэтому показывает актуальное значение

Поэтому:
- Используйте `%var%` для обычных случаев
- Используйте `!var!` когда нужно получить актуальное значение переменной внутри циклов или блоков кода, особенно если значение переменной меняется внутри этого же блока

И помните, что `!var!` работает только если включено `enabledelayedexpansion`!

>Можешь написать тот же скрипт, только PowerShell

Вот эквивалентный скрипт на PowerShell (FormatAll.ps1):

```powershell
# Простой вариант для текущей директории
Get-ChildItem -Filter "*.pas" | ForEach-Object {
    Write-Host "Processing: $($_.FullName)"
    & "Formatter.exe" "sourceFile=$($_.FullName)" "run" "update"
}

# Или более подробный вариант с указанием директории и обработкой ошибок
$directory = "D:\test"
$filePattern = "*.pas"

try {
    Get-ChildItem -Path $directory -Filter $filePattern | ForEach-Object {
        Write-Host "Processing: $($_.FullName)" -ForegroundColor Green
        try {
            & "Formatter.exe" "sourceFile=$($_.FullName)" "run" "update"
            if ($LASTEXITCODE -ne 0) {
                Write-Host "Error processing file: $($_.Name)" -ForegroundColor Red
            }
        }
        catch {
            Write-Host "Failed to process file: $($_.Name)" -ForegroundColor Red
            Write-Host $_.Exception.Message -ForegroundColor Red
        }
    }
}
catch {
    Write-Host "Error accessing directory: $directory" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
}

Write-Host "Done!" -ForegroundColor Green
pause
```

Если нужно включить поиск во всех поддиректориях, добавьте параметр `-Recurse`:
```powershell
Get-ChildItem -Path $directory -Filter $filePattern -Recurse
```

Основные отличия от cmd-скрипта:
1. Использует объектно-ориентированный подход
2. Имеет встроенную обработку ошибок (try-catch)
3. Поддерживает цветной вывод
4. Более гибкий в настройке

Чтобы запустить скрипт:
1. Сохраните его как `FormatAll.ps1`
2. Правый клик -> Run with PowerShell
   
Или из командной строки:
```
powershell -ExecutionPolicy Bypass -File FormatAll.ps1
```

Примечание: Если путь к Formatter.exe не прописан в PATH, укажите полный путь к нему:
```powershell
& "C:\Path\To\Formatter.exe" "sourceFile=$($_.FullName)" "run" "update"
```

>Можешь написать то же на bash

Вот эквивалентный скрипт на bash (format_all.sh):

```bash
#!/bin/bash

# Простой вариант
directory="./test"  # или /path/to/directory
formatter="./Formatter.exe"  # путь к форматтеру

# Базовый вариант
find "$directory" -name "*.pas" | while read -r file; do
    echo "Processing: $file"
    "$formatter" "sourceFile=$file" run update
done

# Или более продвинутый вариант с обработкой ошибок
#!/bin/bash

directory="./test"
formatter="./Formatter.exe"
file_pattern="*.pas"

# Проверка существования директории
if [ ! -d "$directory" ]; then
    echo "Error: Directory $directory does not exist"
    exit 1
fi

# Проверка существования форматтера
if [ ! -f "$formatter" ]; then
    echo "Error: Formatter not found at $formatter"
    exit 1
fi

# Обработка файлов
find "$directory" -name "$file_pattern" | while read -r file; do
    echo -e "\033[0;32mProcessing: $file\033[0m"  # Зелёный текст
    if "$formatter" "sourceFile=$file" run update; then
        echo -e "\033[0;32mSuccessfully processed: $file\033[0m"
    else
        echo -e "\033[0;31mError processing: $file\033[0m"  # Красный текст
    fi
done

echo -e "\033[0;32mDone!\033[0m"
```

Чтобы сделать скрипт исполняемым:
```bash
chmod +x format_all.sh
```

Запуск скрипта:
```bash
./format_all.sh
```

Если нужно обрабатывать только файлы в текущей директории (без поддиректорий), можно использовать:
```bash
for file in *.pas; do
    echo "Processing: $file"
    "$formatter" "sourceFile=$file" run update
done
```

Или с использованием glob:
```bash
shopt -s nullglob  # Предотвращает обработку самого паттерна, если файлов нет
for file in "$directory"/*.pas; do
    echo "Processing: $file"
    "$formatter" "sourceFile=$file" run update
done
```

Примечания:
1. В Linux пути используют прямой слэш (/) вместо обратного (\)
2. Если форматтер это Windows-программа (.exe), вам потребуется запускать его через wine:
```bash
wine "$formatter" "sourceFile=$file" run update
```
3. Цветной вывод работает в терминалах с поддержкой ANSI-цветов
4. `find` по умолчанию ищет рекурсивно во всех поддиректориях. Если нужно ограничить глубину поиска, используйте опцию -maxdepth:
```bash
find "$directory" -maxdepth 1 -name "*.pas"
```

>я хочу использовать bash, который идёт в комплекте с git for Windows

Git Bash в Windows отлично подходит для этой задачи. Вот оптимизированный для Git Bash скрипт (format_all.sh):

```bash
#!/bin/bash

# Настройки
directory="d:/test"  # Используйте прямые слэши даже в Windows
formatter="Formatter.exe"

# Конвертируем Windows-пути в формат UNIX
directory=$(cygpath -u "$directory")

# Проверка существования директории
if [ ! -d "$directory" ]; then
    echo "Error: Directory $directory does not exist"
    exit 1
fi

# Проверка существования форматтера
if ! command -v "$formatter" &> /dev/null; then
    echo "Error: Formatter not found in PATH"
    exit 1
fi

# Обработка файлов
find "$directory" -name "*.pas" | while read -r file; do
    # Конвертируем путь обратно в Windows-формат для .exe программы
    win_path=$(cygpath -w "$file")
    echo "Processing: $file"
    "$formatter" "sourceFile=$win_path" run update
done

echo "Done!"
read -p "Press enter to continue"
```

Особенности работы с Git Bash:

1. Git Bash понимает оба типа слэшей (/ и \), но лучше использовать прямые (/)

2. Если путь к форматтеру не в PATH, укажите полный путь:
```bash
formatter="d:/tools/Formatter.exe"
```

3. Можно использовать более простой вариант без конвертации путей, если ваш форматтер нормально работает с Unix-путями:
```bash
#!/bin/bash

directory="d:/test"
formatter="Formatter.exe"

find "$directory" -name "*.pas" | while read -r file; do
    echo "Processing: $file"
    "$formatter" "sourceFile=$file" run update
done

echo "Done!"
read -p "Press enter to continue"
```

Чтобы запустить скрипт:
1. Сохраните его как `format_all.sh`
2. Откройте Git Bash
3. Перейдите в директорию со скриптом
4. Выполните:
```bash
chmod +x format_all.sh
./format_all.sh
```

Или просто:
```bash
bash format_all.sh
```

Если нужно обрабатывать только текущую директорию без поддиректорий:
```bash
#!/bin/bash

directory="d:/test"
formatter="Formatter.exe"

for file in "$directory"/*.pas; do
    [ -f "$file" ] || continue  # Пропускаем если файлов нет
    win_path=$(cygpath -w "$file")
    echo "Processing: $file"
    "$formatter" "sourceFile=$win_path" run update
done

echo "Done!"
read -p "Press enter to continue"
```