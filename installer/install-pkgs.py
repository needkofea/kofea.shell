#! /usr/bin/env python3
import pyjson5
from pathlib import Path

# Expected Package List Json structure
# {
#   "group_name": {
#   "method_name (i.e, pacman, yay or rust)": [
#           "package_a",
#           "package_b",
#           "package_c"
#       ]
#   }

class PackageManager:
    def install(self, names: list[str], update=False):
        raise NotImplementedError()

class CargoPkgManager(PackageManager):
    def install(self, names: list[str], update=False):
        print("[Cargo] - Installing packages:\n", "\n".join(names))
        pass

class PacmanPkgManager(PackageManager):
    def install(self, names: list[str], update=False):
        print("[Pacman] - Installing packages:\n", "\n".join(names))
        pass

class YayPkgManager(PackageManager):
    def install(self, names: list[str], update=False):
        print("[Yay] - Installing packages:\n", "\n".join(names))
        pass

pkgManagers = {
    "cargo": CargoPkgManager(),
    "pacman": PacmanPkgManager(),
    "yay": YayPkgManager(),
}

def install_pkg_group(group_name: str, pkglist: dict):
    try:
        group: dict = pkglist[group_name]
        for key, value in group.items():
            pkgManagers[key].install(value)
        pass
    except KeyError:
        print(f"Error: could not find package group '{group_name}' in pkgList!")



def install_self():
    with open(f"{Path(__file__).parent}/packages.jsonc", "r") as f:
        pkgList = pyjson5.load(f)
    install_pkg_group("shell", pkgList)
    install_pkg_group("desktop", pkgList)
    install_pkg_group("apps", pkgList)
    pass


if __name__ == "__main__":
    install_self()
