from utils import KofeaDotsModule

desktopModule = KofeaDotsModule("desktop-base")
desktopModule.add_dotfiles([
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
])
desktopModule.add_otherfiles([
    ".themes/catppucin-mocha-rosewater"
], copy=True)
desktopModule.require_packages(
    pacman = [
        "hyprland",
        "bluez",
        "bluez-utils",
        "blueman",
        "brightnessctl",
        "udiskie", # Manage removable media (Auto mounts drives)],
        "kitty", # Terminal
        "firefox", # Minimal browser
        "xdg-desktop-portal-hyprland",
        "xdg-desktop-portal-gtk",
        "xdg-desktop-portal-hyprland",
        "archlinux-xdg-menu",
        "libnotify", # for notifications
        "qt5-wayland", # wayland support in qt5
        "qt6-wayland", # wayland support in qt6
        "libsecret",
        "polkit-gnome",
        "gnome-keyring",
        "xdg-user-dirs",
        "nwg-look",
        # --------- App stores ---------
        "flatpak",
        "gnome-software", # GUI for flatpak
    ]
)
