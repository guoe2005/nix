{ config, pkgs, ... }:

{ networking.extraHosts = ''
 
151.101.42.217  cache.nixos.org
151.101.110.217  cache.nixos.org
199.232.46.217  cache.nixos.org
146.75.122.217  cache.nixos.org
151.101.78.217  cache.nixos.org

20.205.243.166  github.com

'';
}