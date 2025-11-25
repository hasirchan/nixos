{ config, lib, pkgs, inputs, ... }:

{
  programs.firefox = {
    enable = true;
    profiles.default =  {
      extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
        ublock-origin
        asbplayer
        violentmonkey
        videospeed
      ];
      settings = {
        "extensions.autoDisableScopes" = 0;
        "extensions.enabledScopes" = 15;
        "browser.fullscreen.autohide" = false;
      };
    };
    profiles.i2p = {
      isDefault = false;
      id = 1;
      settings = {
        "browser.fullscreen.autohide" = false;

        "network.proxy.type" = 1;
        "network.proxy.http" = "localhost";
        "network.proxy.http_port" = 4444;
        "network.proxy.ssl" = "localhost";
        "network.proxy.ssl_port" = 4444;
        "network.proxy.socks" = "localhost";
        "network.proxy.socks_port" = 4447;
        "network.proxy.share_proxy_settings" = true;
        
        "privacy.trackingprotection.enabled" = true;
        "privacy.resistFingerprinting" = true;
        # "media.peerconnection.ice.default_address_only" = true;
        "media.peerconnection.enabled" = false;
        "network.http.sendRefererHeader" = 0;
        "network.captive-portal-service.enabled" = false;
        "toolkit.telemetry.enabled" = false;
        "privacy.donottrackheader.enabled" = true;
        "geo.enabled" = false;
        "browser.safebrowsing.malware.enabled" = false;
        "browser.safebrowsing.phishing.enabled" = false;
        "browser.safebrowsing.downloads.enabled" = false;
        "webgl.disabled" = true;
        "javascript.options.wasm" = false;
        "javascript.options.wasm_baselinejit" = false;
        "javascript.options.wasm_ionjit" = false;
        "network.dns.echconfig.enabled" = true;
        "network.dns.http3_echconfig.enabled" = true;
        "network.trr.mode" = 5;
      };
    };
  };
}
