{ pkgs, ... }:

{
  services.polybar = {
    enable = true;

    package = pkgs.polybar.override {
      i3Support = true;
      alsaSupport = true;
      iwSupport = true;
      githubSupport = true;
    };


    script = "${pkgs.polybar}/bin/polybar bar &";
  };

  xdg.configFile."polybar/config.ini".source = ./config/polybar/config.ini;
  xdg.configFile."polybar/bars.ini".source = ./config/polybar/bars.ini;
  xdg.configFile."polybar/colors.ini".source = ./config/polybar/colors.ini;
  xdg.configFile."polybar/modules.ini".source = ./config/polybar/modules.ini;
  xdg.configFile."polybar/user_modules.ini".source = ./config/polybar/user_modules.ini;
}
