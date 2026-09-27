# agvpn

Текущая версия: **2.0.0**. [История обновлений](CHANGELOG.md).

Удобная консольная оболочка над AdGuard VPN CLI (Python 3).

## Возможности

- интерактивное меню и полноценный CLI
- английский язык по умолчанию и русский перевод с сохранением выбора
- быстрое подключение, избранные локации, поиск по локациям с пингом
- читаемый статус: локация, режим, интерфейс, IP, трафик, время сессии
- управление настройками (режим, DNS, SOCKS, протокол, маршрутизация и пр.)
- исключения сайтов (general/selective), профили настроек
- kill switch-проверка утечек DNS/IP, watch-мониторинг, логи

## Требования

- Linux (Debian/Ubuntu, Kali и совместимые)
- Python 3
- `curl` или `git`
- [AdGuard VPN CLI](https://github.com/AdguardTeam/AdguardVPNCLI) (устанавливается отдельно)

## Быстрая установка (одной командой)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/0xSecr/agvpn/main/install.sh)
```

Команда скачивает репозиторий и устанавливает `agvpn` в `~/.local/bin`,
а дополнение bash — в `~/.local/share/bash-completion/completions`.

## Установка AdGuard VPN CLI

`agvpn` является оболочкой и требует установленный `adguardvpn-cli`.
Установите его официальным скриптом:

```bash
curl -fsSL https://raw.githubusercontent.com/AdguardTeam/AdguardVPNCLI/HEAD/scripts/release/install.sh | sh -s -- -v
```

Проверьте:

```bash
adguardvpn-cli --version
```

Затем войдите в аккаунт:

```bash
adguardvpn-cli login
```

## Установка agvpn

### Способ 1. Одной командой (рекомендуется)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/0xSecr/agvpn/main/install.sh)
```

### Способ 2. Через git clone

```bash
git clone https://github.com/0xSecr/agvpn.git
cd agvpn
./install.sh
```

### Способ 3. Вручную

```bash
install -Dm 755 bin/agvpn ~/.local/bin/agvpn
install -Dm 755 bin/bash-completion.sh ~/.local/share/bash-completion/completions/agvpn
```

## Настройка PATH

Если `~/.local/bin` отсутствует в `PATH`, добавьте:

```bash
printf '\nexport PATH="$HOME/.local/bin:$PATH"\n' >> ~/.bashrc
export PATH="$HOME/.local/bin:$PATH"
```

## Проверка

```bash
agvpn --version
agvpn          # интерактивное меню
agvpn language ru  # переключить интерфейс на русский
agvpn language en  # переключить интерфейс на английский
```

В интерактивном меню язык можно изменить пунктом `l`. При первом запуске используется английский язык.

Перед использованием `agvpn` необходимо войти в аккаунт AdGuard VPN. Если вход не выполнен, программа покажет инструкцию и не будет выполнять VPN-команды:

```bash
adguardvpn-cli login
```

Следуйте инструкциям в терминале или браузере, затем снова запустите `agvpn`. Для выхода из аккаунта:

```bash
agvpn logout
```

## Обновление

```bash
git -C ~/agvpn pull && ~/agvpn/install.sh
```

или повторно запустите установку одной командой.

## Как обновить версию и опубликовать её в GitHub

Версия задаётся в `bin/agvpn`:

```python
VERSION = "2.0.0"
```

После исправлений измените номер, например на `2.0.1`, и добавьте в начало `CHANGELOG.md` раздел с номером версии, датой и списком изменений. Обновите текущую версию в README, затем выполните:

```bash
python3 -m py_compile bin/agvpn
git diff --check
git status
git add README.md CHANGELOG.md bin/agvpn bin/bash-completion.sh
git commit -m "Release 2.0.1"
git push origin main
git tag -a v2.0.1 -m "Release 2.0.1"
git push origin v2.0.1
```

Если используется другая ветка, узнайте её имя командой `git branch --show-current` и замените `main` в команде `git push`.

После публикации обновите установленную программу:

```bash
cd ~/agvpn
./install.sh
agvpn --version
```

Версия отображается в интерактивном меню под заголовком статуса.

Теги сохраняют точный снимок каждого выпуска. Для отдельной страницы выпуска в GitHub откройте **Releases → Draft a new release**, выберите тег и скопируйте описание соответствующей версии из `CHANGELOG.md`.


## Удаление

```bash
rm -f ~/.local/bin/agvpn
rm -f ~/.local/share/bash-completion/completions/agvpn
rm -rf ~/.config/agvpn
```
