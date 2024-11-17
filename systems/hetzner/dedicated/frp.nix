{}: {
  # https://github.com/fatedier/frp
  #
  # From a client, use an SSH tunnel to connect to the server (for now, can migrate to TLS later).
  #
  # ssh -L 7000:localhost:7000 adrian@65.109.61.232
  #
  # Then run the client:
  #
  # frpc --config ./frpc.toml
  #
  # The client TOML file should look like:
  #
  # # frpc.toml
  # serverAddr = "127.0.0.1"
  # serverPort = 7000
  #
  # [[proxies]]
  # name = "web"
  # type = "http"
  # localPort = 8080
  # customDomains = ["web.example.com"]
  #
  # Now, `curl -H "Host: web.example.com" http://65.109.61.232` will proxy to localhost:8080 on the frp client.
  services.frp = {
    enable = true;
    role = "server";
    settings = {
      # Make FRP only accessible via localhost, use SSH tunneling to connect a client.
      # ssh -i ~/.ssh/id_rsa -L 7000:localhost:7000 user@your_server_ip
      # Then configure frpc to connect to localhost:7000.
      bindAddr = "127.0.0.1";
      # Nginx will proxy from 80 on the server to localhost:9090.
      vhostHTTPPort = 9090;
      allowPorts = [
        { start = 10000; end = 11000; } # For TCP connections.
      ];
    };
  };

  networking.firewall.allowedTCPPortRanges = [
    { from = 10000; to = 11000; }
  ];
}
