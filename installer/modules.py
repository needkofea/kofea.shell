from utils import KOFEA_DOTS, TARGET_DOTS_CONFIG, KofeaDotsModule

class DesktopModule(KofeaDotsModule):
    def __init__(self):
        super().__init__("desktop")


        self.dotfiles = [
            "wal",
            "kitty",
            "sddm",
            "swaylock",
            "starship",
            "ags",
            "hypr",
            "dunst",
            "rofi",
            "waybar",
        ]

    def on_install(self):



        pass
