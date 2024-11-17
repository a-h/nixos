{ pkgs, ... }: {
  # To enable this machine to run its own DNS, set an NS record in the domain registrar.
  # e.g. cmptr.cc -> 65.109.61.232
  services.dnsmasq = {
    enable = true;
    settings = {
      domain = "cmptr.cc"; # The domain to add to the end of hostnames. (eg. "router" -> "router.lan")

      auth-zone = [ "cmptr.cc" "internal.cmptr.cc" ]; # Make dnsmasq authoritative for cmptr.cc and internal.cmptr.cc.
      local = "/internal.cmptr.cc/"; # Define internal domain.

      auth-server = "ns1.cmptr.cc"; # Set the authoritative DNS server name (applies to all zones)

      # TODO: Replace the internal IP later.
      host-record = [
        "ns1.cmptr.cc,65.109.61.232"
        "ns1.internal.cmptr.cc,192.168.1.1"
        "cmptr.cc,65.109.61.232"
        "minio.cmptr.cc,65.109.61.232"
      ];

      address = "/.cmptr.cc/65.109.61.232"; # Point all subdomains to the server.

      # Additional hosts files for dynamic updates.
      # TODO: Manage these files using a systemd service that updates them.
      # The file structure is a simple line:
      # 65.109.61.232 minio.cmptr.cc
      addn-hosts = [
        "/mnt/secrets/dnsmasq/external.hosts"
        "/mnt/secrets/dnsmasq/internal.hosts"
      ];

      # Sensible config
      stop-dns-rebind = true; # Prevent DNS rebinding attacks.
      domain-needed = true; # Don't forward DNS requests without dots/domain parts to upstream servers.
      bogus-priv = true; # If a private IP lookup (192.168.x.x, etc.) fails, it will be answered with "no such domain", instead of forwarded to upstream.
      no-resolv = true; # Don't read upstream servers from /etc/resolv.conf
      no-hosts = true; # Don't obtain any hosts from /etc/hosts, as this would make 'localhost' this machine for all clients!

      # Custom DNS options
      server = [ "1.1.1.1" "1.0.0.1" ]; # Upstream DNS servers.

      # Bind to public and internal interfaces.
      interface = "enp41s0"; # External interface.
    };
  };

  systemd.services."create-empty-hosts-files" = {
    description = "Create external.hosts and internal.hosts files if they don't exist";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c 'mkdir -p /mnt/secrets/dnsmasq && touch /mnt/secrets/dnsmasq/external.hosts && touch /mnt/secrets/dnsmasq/internal.hosts && chown root:dnsmasq /mnt/secrets/dnsmasq/* && chmod 640 /mnt/secrets/dnsmasq/*'";
      User = "root";
    };
  };

  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];

  environment.systemPackages = [
    # Run dig @127.0.0.1 minio.cmptr.cc to check if the DNS server is working.
    pkgs.dnsutils
  ];
}
