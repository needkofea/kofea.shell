from pathlib import Path
import os

USER_HOME = os.environ["HOME"];
KOFEA_DOTS = f"{USER_HOME}/kofea.shell/dots"
DOTS_CONFIG = f"{USER_HOME}/.config"
DOTS_LOCAL = f"{USER_HOME}/.local"

def install_symlink(src: Path, dst: Path ):

    src = src.absolute()
    dst = dst.absolute()

    if dst.exists():
        # Make backup

        if dst.is_symlink():
            print(f"Will existing symlink at: {dst}")
            os.remove(dst)
        else:
            print(f"Conflicting path detected at: {dst}! Backing up to {dst}.install-bak")

    os.symlink(src, dst )
    print(f"Created symlink at {src} -> {dst}")


def install_target(target: str, dst_dir: str = DOTS_CONFIG):
    src = Path(KOFEA_DOTS) / Path(target)
    dst = Path(dst_dir) / target
    install_symlink(src, dst)
