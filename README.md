# agvpn

Удобная консольная оболочка над AdGuard VPN CLI (Python 3).

## Возможности

- интерактивное меню и полноценный CLI
- быстрое подключение, избранные локации, поиск по локациям с пингом
- читаемый статус: локация, режим, интерфейс, IP, трафик, время сессии
- управление настройками (режим, DNS, SOCKS, протокол, маршрутизация и пр.)
- исключения сайтов (general/selective), профили настроек
- kill switch-проверка утечек DNS/IP, watch-мониторинг, логи

## Зависимости

Требуется `adguardvpn-cli` (устанавливается отдельно с официального сайта AdGuard),
а также Python 3.

## Установка

Одной командой после клонирования:

```bash
git clone https://github.com/0xSecr/agvpn.git && cd agvpn && ./install.sh
```

Либо совсем одной командой (без клонирования, скачивает и запускает):

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/0xSecr/agvpn/main/install.sh)
```

Установка вручную:

```bash
install -Dm 755 bin/agvpn ~/.local/bin/agvpn
install -Dm 755 bin/bash-completion.sh ~/.local/share/bash-completion/completions/agvpn
```

Если `~/.local/bin` не в `PATH`, добавьте:

```bash
printf '\nexport PATH="$HOME/.local/bin:$PATH"\n' >> ~/.bashrc
export PATH="$HOME/.local/bin:$PATH"
```

## Проверка

```bash
adguardvpn-cli --version
agvpn --version
```

## Конфиденциальность

Личные данные VPN (учётные данные, избранное, история) в репозиторий не включаются.
Файлы конфигурации исключены через `.gitignore`.
