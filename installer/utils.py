from pathlib import Path
import os
import time

USER_HOME = os.environ["HOME"];
KOFEA_HOME = f"{USER_HOME}/kofea.shell/"
KOFEA_DOTS = f"{KOFEA_HOME}/dots"
KOFEA_SYSTEM = f"{KOFEA_HOME}/system"
DOTS_CONFIG = f"{USER_HOME}/.config"
DOTS_LOCAL = f"{USER_HOME}/.local"

KOFEA_HOME_PATH = Path(KOFEA_HOME)

def install_symlink(src: Path, dst: Path ):

    src = src.absolute()
    dst = dst.absolute()

    has_conflict = dst.exists() or dst.is_symlink() or dst.is_file() or dst.is_dir();
    if has_conflict:
        endpoint = dst.resolve()

        if dst.is_symlink() and KOFEA_HOME_PATH in endpoint.parents:
            print(f"Will update existing symlink at: {dst}")
            os.remove(dst)
        else:
            # Make backup
            epoch_s = round(time.time())
            backup = dst.parent / f"{dst.name}.{epoch_s}.install-bak"
            print(f"Conflicting path detected at: {dst}! Backing up to {backup}")
            os.renames(dst, backup)

    os.symlink(src, dst )
    print(f"Created symlink at {src} -> {dst}")


def install_target(target: str, src_dir: str = KOFEA_DOTS, dst_dir: str = DOTS_CONFIG):
    src = Path(src_dir) / Path(target)
    dst = Path(dst_dir) / target
    install_symlink(src, dst)


class TargetInstaller:
    def __init__(self, src_dir: str, dst_dir: str = DOTS_CONFIG):
        self.src_dir = src_dir
        self.dst_dir = dst_dir

    def install(self, target: str):
        install_target(target, self.src_dir, self.dst_dir)
