{ pkgs, ... }:

let
  netUsage = pkgs.writeShellApplication {
    name = "net-usage";
    runtimeInputs = [
      pkgs.nftables
      pkgs.vnstat
    ];
    text = ''
      exec ${pkgs.python3}/bin/python3 ${./net-usage.py} "$@"
    '';
  };
in
{
  services.vnstat = {
    enable = true;
    settings = {
      Interface = "enp6s0";
      AlwaysAddNewInterfaces = 1;
      SaveInterval = 1;
    };
  };

  # Keep the existing iptables firewall; never flush other nftables tables.
  networking.firewall.extraCommands = ''
    if ! ${pkgs.nftables}/bin/nft list table ip net_usage >/dev/null 2>&1; then
      ${pkgs.nftables}/bin/nft -f - <<'EOF'
    table ip net_usage {
      set local_ranges {
        type ipv4_addr
        flags interval
        elements = { 192.168.0.0/16, 10.0.0.0/8, 172.16.0.0/12, 100.64.0.0/10 }
      }
      counter internet_rx { }
      counter internet_tx { }
      chain incoming {
        type filter hook prerouting priority -310; policy accept;
        iifname "enp6s0" ip saddr != @local_ranges counter name internet_rx
      }
      chain outgoing {
        type filter hook postrouting priority 110; policy accept;
        oifname "enp6s0" ip daddr != @local_ranges counter name internet_tx
      }
    }
    EOF
    fi
  '';
  # Flush on clean shutdown/reload too, without removing the accounting table.
  networking.firewall.extraStopCommands = ''
    if ${pkgs.nftables}/bin/nft list table ip net_usage >/dev/null 2>&1; then
      ${netUsage}/bin/net-usage --collect
    fi
  '';

  systemd.services.net-usage = {
    description = "Save internet traffic counters";
    requires = [ "firewall.service" ];
    after = [ "firewall.service" ];
    serviceConfig = {
      Type = "oneshot";
      StateDirectory = "net-usage";
      ExecStart = "${netUsage}/bin/net-usage --collect";
    };
  };
  systemd.timers.net-usage = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*:0/5";
      Persistent = true;
    };
  };

  environment.systemPackages = [ netUsage ];
}
