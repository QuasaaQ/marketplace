# Q Marketplace - сайт (GitHub Pages)

Витрина расширений для Chrome и Яндекс Браузера.

**Адрес сайта:** https://quasaaq.github.io/marketplace/

## Важно: сайт генерируется автоматически

Файлы `index.html`, `install/index.html`, `<slug>/index.html`, содержимое `downloads/`, `assets/<slug>.png`
и файлы политик в `install/` **создаются сборщиком** из проекта `Q.Marketplace`:

```
Q.Marketplace\
  extensions.json        реестр расширений (пути к проектам)
  Q.Marketplace.bat      GUI: выбор проектов, сборка, публикация
  build.bat              сборка и публикация без GUI
  tools\
    common.ps1           поиск релизов, выбор самой свежей версии
    templates.ps1        генерация страниц сайта
    build.ps1            сборка: ZIP, CRX, update.xml, страницы, политики
    gui.ps1              интерфейс
    make-policy-reg.ps1  генерация .reg и .bat политик
  keys\                  приватные ключи подписи (в GitHub НЕ попадают)
  site\                  этот репозиторий (публикуется на Pages)
```

Вручную править сгенерированные файлы **не нужно** - при следующей сборке они перезапишутся.
Ручные файлы здесь: `assets/style.css`, `assets/icon.svg`, `404.html`, `.nojekyll`.

## Структура

```
index.html                 - главная (витрина), генерируется
404.html                   - страница «не найдено»
assets/style.css           - общие стили (правится вручную)
assets/icon.svg            - иконка сайта (правится вручную)
assets/<slug>.png          - иконки расширений, копируются сборщиком
downloads/<slug>.crx       - подписанные расширения (они же перетаскиваются в browser://tune)
downloads/<slug>-v<ver>.zip- ZIP-архивы расширений
downloads/install-<slug>.bat - установщик: скачивает crx и регистрирует его в HKCU (без прав админа)
downloads/<slug>-update.xml- манифесты обновлений
install/index.html         - инструкция по установке, генерируется
install/install-policy.reg - политики для Chrome (Sources + Allowlist)
install/install-policy-forcelist.reg - то же + автоустановка (управляемые ПК)
install/APPLY-POLICY.bat   - применение политик
install/CLEAN-POLICY.bat   - откат политик
<slug>/index.html          - страница расширения, генерируется
.nojekyll                  - отключает обработку Jekyll
```

## Формат политик (важно)

Списковые политики Chromium в реестре работают как **подраздел с нумерованными значениями `REG_SZ`**:

```
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\ExtensionInstallSources]
"1"="https://quasaaq.github.io/marketplace/*"
"2"="https://quasaaq.github.io/*"
```

`REG_MULTI_SZ` браузеры не читают: политика выглядит как «не заadaна», хотя значение в реестре есть.

## Способы установки

| Браузер | Способ | Результат |
|---|---|---|
| Chrome | политика `install-policy.reg` → кнопка «Установить в один клик» | работает, обновления автоматически |
| Яндекс Браузер | скачать `.crx` → `browser://tune` → перетащить файл | работает, раздел «Из других источников» |
| Управляемые ПК | `install-policy-forcelist.reg` (`ExtensionInstallForcelist`) | автоустановка без действий пользователя |

Ограничения, проверенные на практике:

- Яндекс Браузер блокирует установку сторонних расширений с сайтов на не-корпоративных ПК - политикой не снимается.
- `ExtensionInstallForcelist` на не-корпоративном ПК отклоняется с сообщением «компьютер не является корпоративным».

## Публикация

GitHub Pages включён для ветки `main`, папка `/ (root)`.
Публикация выполняется кнопкой «Собрать и опубликовать» в GUI или файлом `build.bat`.
