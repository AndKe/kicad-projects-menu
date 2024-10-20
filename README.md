# kicad-project-menu
_________________

A bash script that lets you choose which project to open when starting KiCad, making it easy to open multiple projects, or jump right into the one you wish to work on.


## 💾 Installation/usage

Modify kicad-projects.sh as needed:
change **PROJECT_DIR="$HOME/KiCad"** as needed to reflect the path of your projects
You can run kicad-projects.sh locally or copy it into /usr/local/bin

```bash
kicad-projects.sh
```

## 💻 GUI / menu integration.

If you wish to add it to the desktop menu, change the kicad-projects.desktop file as required:

```
Icon=/snap/kicad/14/meta/gui/kicad.svg
Exec=gnome-terminal -- bash -c '$HOME/kicad-projects.sh'

```
(verify that the icon path matches your system, and the location of kicad_projects.sh)


