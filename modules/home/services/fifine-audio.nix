{
  flake.modules.homeManager.fifineAudio = {
    config,
    pkgs,
    ...
  }: let
    preset = "with_fifine_60pct_fisic_8-12cm";
    initialize = "${pkgs.python3}/bin/python3 ${../../../assets/audio/fifine-init.py}";
  in {
    home.packages = [pkgs.easyeffects];

    xdg.dataFile."easyeffects/input/${preset}.json".source =
      ../../../assets/audio/with_fifine_60pct_fisic_8-12cm.json;

    systemd.user.services.fifine-clean-audio = {
      Unit = {
        Description = "Fifine K688 noise reduction (physical gain 60pct, distance 8-12cm)";
        After = ["pipewire.service" "wireplumber.service" "graphical-session.target"];
        Requires = ["pipewire.service"];
        PartOf = ["graphical-session.target"];
      };
      Service = {
        Type = "simple";
        Environment = [
          "FIFINE_SOURCE=alsa_input.usb-3142_fifine_Microphone-00.analog-stereo"
          "FIFINE_PRESET=${preset}"
          "FIFINE_CONFIG=${config.xdg.configHome}/easyeffects/db/easyeffectsrc"
          "FIFINE_PW_DUMP=${pkgs.pipewire}/bin/pw-dump"
          "FIFINE_WPCTL=${pkgs.wireplumber}/bin/wpctl"
          "FIFINE_EASYEFFECTS=${pkgs.easyeffects}/bin/easyeffects"
        ];
        ExecStartPre = "${initialize} prepare";
        ExecStart = "${pkgs.easyeffects}/bin/easyeffects --service-mode";
        ExecStartPost = "${initialize} activate";
        Restart = "on-failure";
        RestartSec = 3;
        TimeoutStartSec = 45;
        TimeoutStopSec = 5;
      };
      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
