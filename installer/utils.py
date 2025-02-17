from pathlib import Path
import os
import time
import shutil

USER_HOME = os.environ["HOME"];
KOFEA_HOME = f"{USER_HOME}/kofea.shell/"

KOFEA_DOTS = f"{KOFEA_HOME}/dots"

KOFEA_DOTS_ICONS = f"{KOFEA_DOTS}/icons"
KOFEA_DOTS_THEMES = f"{KOFEA_DOTS}/themes"
KOFEA_DOTS_DESKTOP = f"{KOFEA_DOTS}/desktop"
KOFEA_DOTS_TERMINAL = f"{KOFEA_DOTS}/terminal"
KOFEA_DOTS_APPS = f"{KOFEA_DOTS}/apps"

TARGET_DOTS_CONFIG = f"{USER_HOME}/.config"
TARGET_DOTS_LOCAL = f"{USER_HOME}/.local"
TARGET_DOTS_THEMES = f"{USER_HOME}/.themes"
TARGET_DOTS_ICONS = f"{USER_HOME}/.icons"

KOFEA_HOME_PATH = Path(KOFEA_HOME)

USER_HOME_PATH = Path(USER_HOME)

def install_symlink(src: Path, dst: Path , copy: bool = False):

    src = src.absolute()
    dst = dst.absolute()

    if dst == USER_HOME_PATH:
        raise ValueError("Installing directly to home directory is not allowed! Please install to a subdirectory of home")
    has_conflict = dst.exists() or dst.is_symlink() or dst.is_file() or dst.is_dir();

    desc = f"Created symlink at {src} -> {dst}"

    if has_conflict:
        endpoint = dst.resolve()

        if dst.is_symlink() and KOFEA_HOME_PATH in endpoint.parents and not copy:
            desc = f"Updated existing symlink at: {dst}"
            os.remove(dst)
        else:
            # Make backup
            epoch_s = round(time.time())
            backup = dst.parent / f"{dst.name}.{epoch_s}.install-bak"
            print(f"Conflicting path detected at: {dst}! Backing up to {backup}")
            os.renames(dst, backup)

    if copy:
        desc = f"Copied {src} -> {dst} | Do note that installs via copy are not recommended and are only advisable if the program for whatever fails to work with symlinks (i.e SDDM)"
        shutil.copytree(src, dst, dirs_exist_ok=True)
    else:
        os.symlink(src, dst )
    print(desc)


def install_target(target: str, src_dir: str = KOFEA_DOTS, dst_dir: str = TARGET_DOTS_CONFIG, copy: bool = False):
    src = Path(src_dir) / Path(target)
    dst = Path(dst_dir) / target
    install_symlink(src, dst, copy)


class KofeaDotsInstaller:
    def __init__(self, src_dir: str = KOFEA_DOTS, dst_dir: str = USER_HOME):
        self.src_dir =  Path(src_dir)
        self.dst_dir = Path(dst_dir)

    def child(self, child_src_dir: str, dst_dir: str | None = None):
        """
        Creates a new installer from a child source directory. Will have same dest directory otherwise specified
        """
        if (dst_dir == None):
            dst_dir =  str(self.dst_dir)
        return KofeaDotsInstaller(str(self.src_dir / child_src_dir), dst_dir)

    def target(self, child_dst_dir: str):
        """
        Creates a new installer with a new destination directory (relative to current instance's destination directory)
        """

        return KofeaDotsInstaller(str(self.src_dir), str(self.dst_dir / child_dst_dir))

    def install(self, src: str, rel_dir: str = ".", copy: bool = False):
        """
        @param src The source target to install. Can be a file or folder
        @param rel_dir Relative directory (to base destination) target will be installed into. Defaults to "."
        @param copy Copies instead of symlink
        """
        install_symlink(self.src_dir / Path(src), self.dst_dir / Path(rel_dir) / Path(src), copy)


    def copy(self, target: str, rel_dir: str = "."):
        """
        Installs by copying files. Short for GenericInstaller::install(..., copy=True)
        """
        self.install(target, rel_dir, True)
