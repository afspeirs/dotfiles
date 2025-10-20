function ip() {
  if [ "$#" -eq 0 ] || [ "$1" = "-h" ]; then
    cat <<'EOF'
Display various IP addresses.

Usage:
  $ ip local            # Display local private IPv4 address
  $ ip public           # Display public IPv4 address
  $ ip <interface>      # Display IPv4 address of a specific interface
  $ ip -h               # Show this help message

Examples:
  $ ip local
  $ ip public
  $ ip eth0
EOF
    return 0
  fi

  local arg="$1"

  case "$arg" in
    "local")
      ifconfig | grep "inet " | grep -Fv 127.0.0.1 | awk '{print $2}'
      ;;
    "public")
      if exists curl; then
        printf "%s\n" "$(curl -4s ifconfig.me)"
      else
        echo "🔴 Error: curl is not installed. Cannot get public IP."
        return 1
      fi
      ;;
    *)
      # Assume it's an interface name
      if ifconfig "$arg" >/dev/null 2>&1; then
        ifconfig "$arg" | grep "inet " | grep -Fv 127.0.0.1 | awk '{print $2}'
      else
        echo "🔴 Error: Invalid argument or interface: $arg"
        echo "   Run 'ip -h' for usage."
        return 1
      fi
      ;;
  esac
}
