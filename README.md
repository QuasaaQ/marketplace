# Q Marketplace (quasaq.github.io)

Витрина расширений для Chrome и Яндекс Браузера. Сайт публикуется через **GitHub Pages**
из этого репозитория (`marketplace`) и доступен по адресу:

```
https://quasaaq.github.io/marketplace/
```

## Структура сайта

```
index.html                 — главная страница (витрина всех расширений)
404.html                   — страница «не найдено»
assets/style.css           — общие стили
assets/icon.svg            — иконка сайта (favicon)
downloads/                 — ZIP-архивы, .crx и update.xml для self-hosted установки
install/index.html         — инструкция «установка в один клик» + .reg-файлы политик
<имя-расширения>/index.html— отдельная страница расширения
.nojekyll                  — отключает обработку Jekyll (файлы отдаются как есть)
```

## Self-hosted установка (политики)

Скрипт `tools\make-policy-reg.ps1` (лежит в корне проекта, не в репозитории) генерирует
`site/install/install-policy-sources.reg` и `site/install/install-policy-forcelist.reg`
для веток Yandex Browser, Chrome и Chromium.

Сборка `.crx` и `update.xml` (Node.js, пакет `crx3`, ставится в `.tools/`):

```
node .tools\node_modules\crx3\bin\crx3.js -p "keys\yen-to-rub.pem" ^
  -o "site\downloads\yen-to-rub.crx" -x "site\downloads\update.xml" ^
  --appVersion 1.0.0 ^
  --crxURL "https://quasaaq.github.io/marketplace/downloads/yen-to-rub.crx" app
```

Приватный ключ `keys\yen-to-rub.pem` — **вне репозитория**, в GitHub не попадает.
При выходе новой версии увеличьте `version` в `app/manifest.json`, пересоберите `.crx`
с тем же ключом и обновите `--appVersion` в `update.xml`.

## Как добавить новое расширение

1. Соберите ZIP расширения (файлы должны быть в корне архива, включая `manifest.json`)
   и положите его в `downloads/`, например `downloads/my-ext-v1.0.0.zip`.
2. Создайте папку `my-ext/` со своей страницей `index.html` (можно скопировать
   `yen-to-rub/index.html` как шаблон).
3. Добавьте карточку расширения в `index.html` в секцию `#extensions`.
4. Закоммитьте и запушьте — GitHub Pages обновит сайт автоматически (обычно 30–60 секунд).

## Публикация

GitHub Pages включён для ветки `main`, папка `/ (root)`.
