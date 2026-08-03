{ pkgs }:
{
  systemStatus = pkgs.writeShellScript "quickshell-system-status" ''
    read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat
    idle_a=$((idle + iowait))
    total_a=$((user + nice + system + idle + iowait + irq + softirq + steal))

    ${pkgs.coreutils}/bin/sleep 0.2

    read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat
    idle_b=$((idle + iowait))
    total_b=$((user + nice + system + idle + iowait + irq + softirq + steal))

    total_delta=$((total_b - total_a))
    idle_delta=$((idle_b - idle_a))
    if [ "$total_delta" -gt 0 ]; then
      cpu=$((100 * (total_delta - idle_delta) / total_delta))
    else
      cpu=0
    fi

    mem="$(LC_ALL=C ${pkgs.procps}/bin/free | ${pkgs.gawk}/bin/awk '/^Mem:/ { printf "%d", ($3 * 100) / $2 }')"
    load="$(${pkgs.coreutils}/bin/cut -d ' ' -f 1 /proc/loadavg)"
    temp_file="$(${pkgs.findutils}/bin/find /sys/class/thermal -name temp -print -quit 2>/dev/null || true)"

    if [ -n "$temp_file" ] && [ -r "$temp_file" ]; then
      temp_raw="$(${pkgs.coreutils}/bin/cat "$temp_file")"
      temp="$((temp_raw / 1000))"
      ${pkgs.jq}/bin/jq -n --argjson cpu "$cpu" --argjson mem "$mem" --arg load "$load" --argjson temp "$temp" \
        '{cpu: $cpu, mem: $mem, load: $load, temp: $temp}'
    else
      ${pkgs.jq}/bin/jq -n --argjson cpu "$cpu" --argjson mem "$mem" --arg load "$load" \
        '{cpu: $cpu, mem: $mem, load: $load, temp: null}'
    fi
  '';

  networkStatus = pkgs.writeShellScript "quickshell-network-status" ''
    wifi_line="$(${pkgs.networkmanager}/bin/nmcli -t -f active,ssid,signal dev wifi 2>/dev/null | ${pkgs.gnugrep}/bin/grep '^yes:' | ${pkgs.coreutils}/bin/head -n 1)"
    if [ -n "$wifi_line" ]; then
      ssid="$(printf "%s" "$wifi_line" | ${pkgs.coreutils}/bin/cut -d : -f 2)"
      signal="$(printf "%s" "$wifi_line" | ${pkgs.coreutils}/bin/cut -d : -f 3)"
      ${pkgs.jq}/bin/jq -n --arg ssid "$ssid" --argjson signal "''${signal:-0}" \
        '{type: "wifi", ssid: $ssid, signal: $signal}'
    elif ${pkgs.networkmanager}/bin/nmcli -t -f state general 2>/dev/null | ${pkgs.gnugrep}/bin/grep -q connected; then
      ${pkgs.jq}/bin/jq -n '{type: "ethernet", ssid: null, signal: null}'
    else
      ${pkgs.jq}/bin/jq -n '{type: "none", ssid: null, signal: null}'
    fi
  '';

  wifiList = pkgs.writeShellScript "quickshell-wifi-list" ''
    ${pkgs.networkmanager}/bin/nmcli -t -f SSID,SIGNAL,SECURITY,IN-USE dev wifi list 2>/dev/null \
      | ${pkgs.gawk}/bin/awk -F: 'NF>=4 && $1!="" {
          active=($4=="*")?"true":"false";
          secure=($3=="" || $3=="--")?"false":"true";
          signal=($2==""?0:$2);
          gsub(/"/,"\\\"",$1);
          printf "{\"ssid\":\"%s\",\"signal\":%s,\"secure\":%s,\"active\":%s}\n",$1,signal,secure,active
        }' \
      | ${pkgs.jq}/bin/jq -s 'unique_by(.ssid) | sort_by(-.signal)'
  '';

  wifiConnect = pkgs.writeShellScript "quickshell-wifi-connect" ''
    ssid="$1"
    exec ${pkgs.networkmanager}/bin/nmcli device wifi connect "$ssid"
  '';

  brightnessStatus = pkgs.writeShellScript "quickshell-brightness-status" ''
    ${pkgs.brightnessctl}/bin/brightnessctl -m 2>/dev/null | ${pkgs.gawk}/bin/awk -F, '{gsub(/%/,"",$4); print $4}'
  '';

  calendarAgenda = pkgs.writeShellScript "quickshell-calendar-agenda" ''
    ${pkgs.khal}/bin/khal list now 14d --format '{start-date}|{start-time}|{title}' 2>/dev/null \
      | ${pkgs.gawk}/bin/awk -F'|' 'NF>=3 {
          gsub(/"/,"\\\"",$3);
          printf "{\"date\":\"%s\",\"time\":\"%s\",\"title\":\"%s\"}\n",$1,$2,$3
        }' \
      | ${pkgs.jq}/bin/jq -s '.'
  '';
}
