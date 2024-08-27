# mv-bash-alias-auto-updater

**Status: UNTESTED**

## Overview

`mv-bash-alias-auto-updater` is a Bash script designed to automatically update the `.bashrc` file when a directory containing `.sh` or `.py` scripts is moved using the `mv` command. This script ensures that any paths to these scripts referenced in `.bashrc` are updated to reflect their new locations.

## Features

- Monitors the `mv` command to detect when directories are moved.
- Identifies `.sh` and `.py` scripts referenced in `.bashrc`.
- Automatically updates `.bashrc` with the new paths of moved scripts.
- Works dynamically by detecting the current user's home directory.

## Installation

To install and set up the alias for easy usage:

```
REPO_URL="https://github.com/ForDefault/mv-bash-alias-auto-updater.git" && \
REPO_NAME=$(basename $REPO_URL .git) && \
username=$(whoami) && \
git clone $REPO_URL && \
cd $REPO_NAME && \
chmod +x alias-updater.sh && \
if ! grep -q 'alias mv=' ~/.bashrc; then \
  echo 'alias mv="/home/'"$username"'/'"$REPO_NAME"'/alias-updater.sh"' >> ~/.bashrc; \
fi
```
