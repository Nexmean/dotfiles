#!/usr/bin/env sh
set -e

cd "$(dirname "$0")"

if [ "$(hostname)" = "buildkitsandbox" ]; then
    daemon="--no-daemon"
else
    daemon=""
fi

if ! command -v nix >/dev/null 2>&1; then
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm ${daemon}
    # shellcheck source=/dev/null
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

nix develop -c task switch
