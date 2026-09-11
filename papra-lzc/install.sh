#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== lzc-papra: build .lpk ==="
cd "$SCRIPT_DIR"
lzc-cli project build

LPK=$(find . -maxdepth 1 -name "*.lpk" -type f | sort -r | head -1)
echo
echo "Built: $LPK"
echo
echo "Install from PowerShell (WSL networking limitation):"
echo "  cp $LPK /mnt/c/Users/fede9/Desktop/"
echo "  powershell.exe -Command \"lzc-cli app install C:\\Users\\fede9\\Desktop\\$(basename "$LPK")\""
echo
echo "Status:    powershell.exe -Command \"lzc-cli app status cloud.lazycat.app.papra\""
echo "Log:       powershell.exe -Command \"lzc-cli app log cloud.lazycat.app.papra\""
echo "Uninstall: powershell.exe -Command \"lzc-cli app uninstall cloud.lazycat.app.papra\""
