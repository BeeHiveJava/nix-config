{ pkgs, ... }: {

  environment.pathsToLink = [ "/libexec" ];

  services = {
    xserver = {
      enable = true;

      displayManager = {
        lightdm = {
          enable = true;
          extraConfig = ''
            [Seat:*]
            type=xremote
            xserver-share=true
            xserver-hostname=172.27.128.1
            xserver-display-number=0.0
          '';
        };
      };

      desktopManager = {
        xfce = {
          enable = true;
          noDesktop = true;
          enableXfwm = false;
        };

        xterm = {
          enable = false;
        };
      };

      windowManager = {
        i3 = {
          enable = true;
        };
      };
    };

    displayManager = {
      enable = true;
      defaultSession = "xfce+i3";
      autoLogin = {
        enable = true;
        user = "lesley";
      };
    };
  };
}
