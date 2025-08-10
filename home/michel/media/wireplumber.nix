{
  xdg.configFile."wireplumber/wireplumber.conf.d/50-bluez-config.conf".text = ''
      monitor.bluez.properties = {
      bluez5.roles = [ a2dp_sink a2dp_source hfp_hf hfp_ag ]
      bluez5.codecs = [ aac sbc_xq sbc ]
      bluez5.enable-sbc-xq = true
      bluez5.enable-msbc = true,
      bluez5.enable-hw-volume = true
      bluez5.hfphsp-backend = "native"
    }
  '';
}
