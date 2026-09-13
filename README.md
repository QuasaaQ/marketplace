# Q Marketplace (quasaaq.github.io/marketplace)

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
downloads/                 — ZIP, .crx и update.xml
install/index.html         — инструкция по установке + .reg и .bat
<имя-расширения>/index.html— отдельная страница расширения
.nojekyll                  — отключает обработку Jekyll (файлы отдаются как есть)
```

## Как добавить новое расширение

1. Соберите ZIP расширения (файлы в корне архива, включая `manifest.json`) и положите в `downloads/`.
2. Создайте `my-ext/index.html` (шаблон — `yen-to-rub/index.html`).
3. Добавьте карточку в секцию `#extensions` в `index.html`.
4. Закоммитьте и запушьте — GitHub Pages обновит сайт через 30–60 секунд.

## Формат политик (важно)

Списковые политики Chromium в реестре Windows работают как **подраздел с нумерованными
значениями `REG_SZ`**, а не как `REG_MULTI_SZ`:

```
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\ExtensionInstallSources]
"1"="https://quasaaq.github.io/marketplace/*"
"2"="https://quasaaq.github.io/*"
```

`REG_MULTI_SZ` браузеры не читают: политика выглядит как «не задана», хотя значение в реестре есть.

## Генерация .reg

`tools\make-policy-reg.ps1` (в корне проекта, вне репозитория) создаёт:

- `site/install/install-policy.reg` — `ExtensionInstallSources` + `ExtensionInstallAllowlist`;
- `site/install/install-policy-forcelist.reg` — то же + `ExtensionInstallForcelist`
  (работает только на управляемых/корпоративных ПК).

Ветки реестра: `HKCU`, `HKLM` (64-бит) и `HKLM\WOW6432Node` (32-бит)
для `YandexBrowser`, `Google\Chrome`, `Chromium`.

## Сборка .crx и update.xml

Node.js, пакет `crx3` в `.tools/`:

```
node .tools\node_modules\crx3\bin\crx3.js -p "keys\yen-to-rub.pem" ^
  -o "site\downloads\yen-to-rub.crx" -x "site\downloads\update.xml" ^
  --appVersion 1.0.0 ^
  --crxURL "https://quasaaq.github.io/marketplace/downloads/yen-to-rub.crx" app
```

Приватный ключ `keys\yen-to-rub.pem` — **вне репозитория**, в GitHub не попадает.
При новой версии увеличьте `version` в `app/manifest.json`, пересоберите `.crx`
тем же ключом и обновите `--appVersion`.

## Результаты проверки на реальных браузерах

| Браузер | Результат |
|---|---|
| Chrome 152 | Установка в один клик с сайта после применения `install-policy.reg` — **работает** |
| Яндекс Браузер 26.8 | Политика `ExtensionInstallSources` читается (статус ОК), но установку блокирует: сторонние расширения разрешены только на корпоративных ПК. Рабочий вариант — установка распакованного ZIP через «Режим разработчика» |
| `ExtensionInstallForcelist` | На не-корпоративном ПК отклоняется с сообщением «компьютер не является корпоративным» |

## Публикация

GitHub Pages включён для ветки `main`, папка `/ (root)`.
