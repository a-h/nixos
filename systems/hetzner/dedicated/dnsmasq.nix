{ pkgs, ... }: {
  # To enable this machine to run its own DNS, set an NS record in the domain registrar.
  # e.g. cmptr.cc -> 65.109.61.232
  services.dnsmasq = {
    enable = true;
    extraConfig = ''
      # Set domain.
      domain=cmptr.cc

      # Make dnsmasq authoritative for cmptr.cc
      auth-zone=cmptr.cc

      # Define internal domain.
      auth-zone=internal.cmptr.cc
      local=/internal.cmptr.cc/

      # Set the authoritative DNS server name (applies to all zones)
      auth-server=ns1.cmptr.cc

      # Define NS records for cmptr.cc and internal.cmptr.cc
      host-record=ns1.cmptr.cc,65.109.61.232
      host-record=ns1.internal.cmptr.cc,192.168.1.1  # Replace with your internal IP

      # Set up the primary A record for cmptr.cc
      host-record=cmptr.cc,65.109.61.232

      # Manual definitions for *.cmptr.cc
      host-record=minio.cmptr.cc,65.109.61.232

      # Wildcard subdomains pointing to your server.
      address=/.cmptr.cc/65.109.61.232

      # Additional hosts files for dynamic updates.
      # TODO: Manage these files using a systemd service that updates them.
      # The file structure is a simple line:
      # 65.109.61.232 minio.cmptr.cc
      addn-hosts=/mnt/secrets/dnsmasq/external.hosts
      addn-hosts=/mnt/secrets/dnsmasq/internal.hosts

      # Bind to public and internal interfaces.
      interface=enp41s0  # External interface.
      # interface=enp42s0  # Internal interface. Replace with your actual internal interface.

      # Security options.
      stop-dns-rebind
    '';
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
