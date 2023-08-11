_: {
  services.easyeffects.enable = true;
  services.easyeffects.preset = "bass_perfect_eq";
  home.file = {
    ".config/easyeffects/output/adv_autogain.json".source =
      ./ee-presets/adv_autogain.json;
    ".config/easyeffects/output/bass_boosted.json".source =
      ./ee-presets/bass_boosted.json;
    ".config/easyeffects/output/bass_perfect_eq.json".source =
      ./ee-presets/bass_perfect_eq.json;
    ".config/easyeffects/output/boosted.json".source =
      ./ee-presets/boosted.json;
    ".config/easyeffects/output/loudness_autogain.json".source =
      ./ee-presets/loudness_autogain.json;
    ".config/easyeffects/output/perfect_eq.json".source =
      ./ee-presets/perfect_eq.json;
    ".config/easyeffects/irs".source = ./ee-presets/irs;
  };
}
