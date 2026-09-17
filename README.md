# Q.Marketplace - сайт (GitHub Pages)

Витрина расширений для Chrome и Яндекс Браузера.

**Адрес сайта:** https://quasaaq.github.io/marketplace/

## Важно: сайт генерируется автоматически

Файлы `index.html`, `install/index.html`, `<slug>/index.html`, содержимое `downloads/`, `assets/<slug>.png`,
`assets/donation-qr.jpg` и файлы политик в `install/` **создаются сборщиком** из проекта `Q.Marketplace`:

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
assets/donation-qr.jpg     - QR-код для донатов, копируется сборщиком из donation\ проекта Q.Marketplace
assets/<slug>.png          - иконки расширений, копируются сборщиком
assets/external/<id>.png   - иконки сторонних расширений, скачиваются из Chrome Web Store
downloads/external/<slug>.crx - пакеты сторонних расширений с GitHub (публикуются как есть)
downloads/<slug>.crx       - подписанные расширения (без прав админа ставятся перетаскиванием в бета-версии Яндекс Браузера)
downloads/<slug>-grey.crx  - серая сборка того же расширения: отдельный пакет, свой ID и свой update.xml
downloads/<slug>-v<ver>.zip- ZIP-архивы расширений
downloads/install-<slug>.bat - установщик: скачивает crx и регистрирует его в HKCU (запускать от имени администратора)
downloads/<slug>-update.xml- манифесты обновлений
install/index.html         - инструкция по установке, генерируется
install/install-policy.reg - политики для Chrome (Sources + Allowlist + MV2, применяются от имени администратора)
install/install-policy-corporate.reg - то же + ExtensionSettings (управляемые ПК)
install/APPLY-POLICY.bat   - применение политик (Sources + Allowlist + MV2)
install/CLEAN-POLICY.bat   - откат политик (включая ExtensionManifestV2Availability)
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

### Манифест V2: запрет браузеру отключать расширения

Современные сборки Chromium сами отключают и удаляют расширения Manifest V2 (Chrome 127+).
Скрипты политик записывают значение `ExtensionManifestV2Availability` = 2 (`Force enabled`):

```
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome]
"ExtensionManifestV2Availability"=dword:00000002
```

Значение имеет тип `REG_DWORD` (не `REG_SZ`) и пишется в те же ветки `SOFTWARE\Policies`
для Chrome, Яндекс Браузера и Chromium (HKCU, HKLM, WOW6432Node). При облачном управлении
(Google Admin console) локальный ключ - только запасной вариант: в облачном правиле
`ExtensionManifestV2Availability` тоже нужно выставить `Force enabled` (2), иначе
администратор перезапишет локальную настройку.
https://chromeenterprise.google/policies/#ExtensionManifestV2Availability

`CLEAN-POLICY.bat` удаляет это значение вместе с остальными политиками проекта.

## Способы установки

| Браузер | Способ | Права администратора |
|---|---|---|
| Яндекс Браузер Бета | скачать `.crx` → перетащить файл в окно браузера (`chrome://extensions`, `browser://tune`) | не нужны |
| Chrome | политика `install-policy.reg` → установка в один клик с сайта | нужны |
| Яндекс Браузер Бета | политика `install-policy.reg` → установка в один клик с сайта | нужны |
| Яндекс Браузер (стандартная версия) | установщик `install-<slug>.bat` или `.crx` → `browser://tune` | нужны |
| Управляемые ПК | `install-policy-corporate.reg` (`ExtensionSettings`, force_installed) | нужны |
| Все браузеры | `ExtensionManifestV2Availability` = 2 - браузер не отключает и не удаляет расширения Manifest V2 | нужны |

Ограничения, проверенные на практике:

- Без прав администратора расширение ставится только в бета-версию Яндекс Браузера - перетаскиванием файла `.crx`.
- Яндекс Браузер блокирует установку сторонних расширений с сайтов на не-корпоративных ПК - политикой не снимается.
- Автоустановка (`ExtensionSettings`) на не-корпоративном ПК отклоняется с сообщением «компьютер не является корпоративным».

## Публикация

GitHub Pages включён для ветки `main`, папка `/ (root)`.
Публикация выполняется кнопкой «Собрать и опубликовать» в GUI или файлом `build.bat`.
