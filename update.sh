#!/bin/bash

set -euo pipefail

DATE=$(date '+%Y-%m-%d_%H-%M-%S')

sudo snapper create -d "__{$DATE}__"
echo "Snapshot created: __{$DATE}__"

sudo zypper refresh
sudo zypper update -y -l
echo "System updated successfully."

sudo reboot now