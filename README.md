# Запуск проєкту Journal App

Завантажуємо проєкт та відкриваємо у редакторі коду

У прикладі використовується редактор Visual Studio Code

Проєкт складається з двох частин:

- `backend/` – сервер на Flask;
- `frontend/` – Flutter-клієнт.

Команди нижче наведено для двох систем:

- macOS / Linux: термінал Bash;
- Windows: Git Bash.

---

## Backend

### 1. Відкриття папки backend

З кореневої папки проєкту переходимо до папки `backend/`:

```bash
cd backend
```

### 2. Віртуальне оточення та залежності проєкту

Створюємо віртуальне оточення:

macOS / Linux:

```bash
python3 -m venv .venv
```

Windows:

```bash
python -m venv .venv
```

Активуємо віртуальне оточення:

macOS / Linux:

```bash
source .venv/bin/activate
```

Windows (Git Bash):

```bash
source .venv/Scripts/activate
```

Встановлюємо залежності з `requirements.txt`:

```bash
pip install -r requirements.txt
```

> **Порада:** у VS Code обираємо інтерпретатор з віртуального середовища:
>
> 1. Ctrl+Shift+P (на macOS Cmd+Shift+P);
> 2. Python: Select Interpreter;
> 3. обираємо `.venv`

### 3. Змінні оточення

Створюємо файл `.env`:

```bash
touch .env
```

Копіюємо змінні з файлу-зразку `.env-sample` та заповнюємо їх власними значеннями

> **Порада:** файл можна одразу створити як копію зразку, а потім змінити значення:
>
> ```bash
> cp .env-sample .env
> ```

### 4. Проведення міграцій

Застосовуємо міграції до бази даних:

```bash
flask --app core db upgrade
```

### 5. Запуск сервера

Запускаємо сервер командою:

```bash
python manage.py
```

---

## Frontend

> **Примітка:** на macOS рекомендується розміщувати Flutter-клієнт у папці, яка не синхронізується з iCloud (тобто не на Робочому столі та не в Документах), наприклад `~/dev/`. iCloud може додати до файлів клієнта додаткові атрибути, через які Xcode не зможе підписати Flutter-фреймворк і клієнт не запуститься на симуляторі
>
> Якщо клієнт уже запускався з такої папки, після перенесення прибираємо зайві атрибути, виконавши в папці `frontend/`:
>
> ```bash
> xattr -cr .
> ```

### 1. Відкриття папки frontend

З кореневої папки проєкту переходимо до папки `frontend/`:

```bash
cd frontend
```

### 2. Адреса сервера

Заповнюємо файл `config/dev.json` адресою запущеного backend-сервера:

```json
{ "API_BASE_URL": "http://127.0.0.1:8080" }
```

### 3. Залежності проєкту

Встановлюємо залежності Flutter-клієнта:

```bash
flutter pub get
```

### 4. Запуск Flutter-клієнта

Запускаємо емулятор одним зі способів:

- Xcode (лише macOS): відкриваємо застосунок Simulator;
- Android Studio: Device Manager → обираємо пристрій → Start

Перевіряємо, що Flutter бачить емулятор:

```bash
flutter devices
```

Запускаємо клієнт:

```bash
flutter run --dart-define-from-file=config/dev.json
```

Якщо запущено кілька пристроїв, Flutter запропонує обрати потрібний зі списку

### Примітка щодо Android Studio на Windows

Для роботи емулятора Android на Windows має бути ввімкнена апаратна віртуалізація:

1. у BIOS / UEFI вмикаємо Intel VT-x (Intel) або SVM / AMD-V (AMD);
2. у «Компонентах Windows» вмикаємо «Платформа гіпервізора Windows» та перезавантажуємо комп'ютер;
3. в Android Studio → SDK Manager → SDK Tools встановлюємо Android SDK Command-line Tools;
4. приймаємо ліцензії Android SDK:

   ```bash
   flutter doctor --android-licenses
   ```

Перевіряємо, що все налаштовано:

```bash
flutter doctor
```

> **Примітка:** на Windows доступний лише емулятор Android, симулятор iOS працює тільки на macOS з Xcode
