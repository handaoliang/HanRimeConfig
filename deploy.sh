#!/usr/bin/env zsh
set -euo pipefail

script_dir="${0:A:h}"
squirrel_app="${SQUIRREL_APP:-/Library/Input Methods/Squirrel.app}"
deployer="$squirrel_app/Contents/MacOS/rime_deployer"
shared_data="$squirrel_app/Contents/SharedSupport"
user_data="${RIME_USER_DATA:-$script_dir}"
staging_dir="${RIME_STAGING_DIR:-$user_data/build}"

if [[ ! -x "$deployer" ]]; then
  print -u2 "rime_deployer not found or not executable: $deployer"
  print -u2 "Set SQUIRREL_APP to the Squirrel.app path if it is installed elsewhere."
  exit 1
fi

if [[ ! -d "$shared_data" ]]; then
  print -u2 "Squirrel shared data directory not found: $shared_data"
  print -u2 "Set SQUIRREL_APP to the Squirrel.app path if it is installed elsewhere."
  exit 1
fi

mkdir -p "$staging_dir"

print "Building Rime data..."
print "  user_data:   $user_data"
print "  shared_data: $shared_data"
print "  staging_dir: $staging_dir"

"$deployer" --build "$user_data" "$shared_data" "$staging_dir"

print "Build completed."
