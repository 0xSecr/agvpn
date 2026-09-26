# agvpn

Удобная консольная оболочка над AdGuard VPN CLI (Python 3).

## Возможности

- интерактивное меню и полноценный CLI
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
```

## Обновление

```bash
git -C ~/agvpn pull && ~/agvpn/install.sh
```

или повторно запустите установку одной командой.

## Удаление

```bash
rm -f ~/.local/bin/agvpn
rm -f ~/.local/share/bash-completion/completions/agvpn
rm -rf ~/.config/agvpn
```
