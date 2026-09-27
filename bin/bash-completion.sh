# adguardvpn-cli bash completion script

# Helper variable for common options available for all commands
_adguardvpn_cli_common_opts="-h --help --help-all"

_adguardvpn_cli_login() {
  local opts="-u --username -p --password ${_adguardvpn_cli_common_opts}"
  COMPREPLY=($(compgen -W "${opts}" -- "$cur"))
}

_adguardvpn_cli_connect() {
  local opts="-f --fastest -v --verbose --no-fork --ppid-file --pid-file -l --location -4 --ipv4only -6 --ipv6only -y --yes --log-to-file --no-progress --boot ${_adguardvpn_cli_common_opts}"

  case "$prev" in
    -l|--location)
      local IFS=$'\n'
      COMPREPLY=($(adguardvpn-cli list-locations --bash-completion "${cur}"))
      ;;
    *)
      COMPREPLY=($(compgen -W "${opts}" -- "$cur"))
      ;;
  esac
}

_adguardvpn_cli_site_exclusions() {
  local opts="add remove show clear mode ${_adguardvpn_cli_common_opts}"
  local subcmd_opts=""
  case "${COMP_WORDS[2]}" in
    mode)
      subcmd_opts="general selective ${_adguardvpn_cli_common_opts}"
      ;;
    add|remove|show|clear)
      subcmd_opts="--for-mode ${_adguardvpn_cli_common_opts}"
      ;;
  esac

  case "$prev" in
    --for-mode)
      subcmd_opts="general selective ${_adguardvpn_cli_common_opts}"
      ;;
  esac

  if [[ -n "$subcmd_opts" ]]; then
    COMPREPLY=($(compgen -W "${subcmd_opts}" -- "$cur"))
  else
    COMPREPLY=($(compgen -W "${opts}" -- "$cur"))
  fi
}

_adguardvpn_cli_update() {
  local opts="-y --yes -v --verbose ${_adguardvpn_cli_common_opts}"
  COMPREPLY=($(compgen -W "${opts}" -- "$cur"))
}

_adguardvpn_cli_config() {
  local opts="set-mode set-dns set-socks-port set-socks-host set-socks-username set-socks-password clear-socks-auth set-change-system-dns set-tun-routing-mode create-route-script set-crash-reporting set-telemetry set-update-channel set-protocol set-post-quantum set-show-hints set-debug-logging set-show-notifications set-bound-if-override show ${_adguardvpn_cli_common_opts}"
  local subcmd_opts=""

  case "${COMP_WORDS[2]}" in
    set-mode)
      subcmd_opts="socks tun"
      ;;
    set-dns)
      if [ "${COMP_CWORD}" -eq 3 ]; then
        subcmd_opts="default"  # Allowing 'default' explicitly, user can type other valid addresses
      else
        subcmd_opts=" "
      fi
      ;;
    set-socks-port|set-socks-username|set-socks-password|clear-socks-auth)
      subcmd_opts=" "
      ;;
    set-socks-host)
      subcmd_opts="-u --username -p --password 127.0.0.1"
      ;;
    set-change-system-dns|set-crash-reporting|set-show-hints|set-debug-logging|set-protocol|set-post-quantum|set-show-notifications)
      subcmd_opts="on off"
      ;;
    set-tun-routing-mode)
      subcmd_opts="auto script none"
      ;;
    set-update-channel)
      subcmd_opts="beta nightly release"
      ;;
    show|create-route-script)
      subcmd_opts=" "  # 'show' takes no additional arguments
      ;;
  esac

  if [[ -n "$subcmd_opts" ]]; then
    COMPREPLY=($(compgen -W "${subcmd_opts}" -- "$cur"))
  else
    COMPREPLY=($(compgen -W "${opts}" -- "$cur"))
  fi
}

_adguardvpn_cli_completion() {
  local cur prev command
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"

  # Find the main command in the input
  for word in "${COMP_WORDS[1]}"; do
    case "$word" in
      login|logout|list-locations|connect|disconnect|status|license|config|check-update|export-logs|update|site-exclusions)
        command="$word"
        break
        ;;
    esac
  done

  # Call the appropriate function based on the main command found
  case "$command" in
    login)
      _adguardvpn_cli_login
      ;;
    connect)
      _adguardvpn_cli_connect
      ;;
    update)
      _adguardvpn_cli_update
      ;;
    config)
      _adguardvpn_cli_config
      ;;
    site-exclusions)
      _adguardvpn_cli_site_exclusions
      ;;
    *)
      if [[ $COMP_CWORD -eq 1 ]]; then
        local main_opts="login logout list-locations connect disconnect status license config check-update export-logs update site-exclusions language lang menu ${_adguardvpn_cli_common_opts} -v --version"
        COMPREPLY=($(compgen -W "${main_opts}" -- "$cur"))
      else
        local main_opts="${_adguardvpn_cli_common_opts}"
        COMPREPLY=($(compgen -W "${main_opts}" -- "$cur"))
      fi
      ;;
  esac

  return 0
}

if [ -n "$ZSH_VERSION" ]; then
  if ! (which compinit &> /dev/null); then
    autoload -U +X compinit && compinit
    autoload -U +X bashcompinit && bashcompinit
  fi
fi

complete -F _adguardvpn_cli_completion adguardvpn-cli
