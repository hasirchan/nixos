#!/usr/bin/env bash
set -euo pipefail

HOST="$1"
HEAD="$2"

BASE="./hosts/$HOST"
SYS="$BASE/system"
USR="$BASE/user"

mkdir -p "$SYS" "$USR"
cp /etc/nixos/hardware-configuration.nix "$SYS/"

if [ "$HEAD" = "yes" ]; then
  cat > "$SYS/default.nix" <<'EOF'
{ config, lib, pkgs, ... }:
{
  imports = [
    ../../_headful/system
    ../../_headful/system/graphical-env/sway
    ./hardware-configuration.nix
  ];
}
EOF

  cat > "$USR/default.nix" <<'EOF'
{ config, lib, pkgs, ... }:

{
  imports = [
    ../../_headful/user
    ../../_headful/user/graphical-env/sway
  ];

}
EOF
else
  cat > "$SYS/default.nix" <<'EOF'
{ config, lib, pkgs, ... }:
{
  imports = [
    ../../_headless/system
    ./hardware-configuration.nix
  ];
}
EOF

  cat > "$USR/default.nix" <<'EOF'
{ config, lib, pkgs, ... }:

{
  imports = [
    ../../_headless/user
  ];

}
EOF
fi
