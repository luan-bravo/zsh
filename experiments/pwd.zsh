pwd
local cmd="$(pwd)"
echo "cmd: $cmd"
local global="$PWD"
echo "global: $global"

echo

pushd /home || echo "'pushd /home' failed" || exit 1
pwd
local cmd="$(pwd)"
echo "cmd: $cmd"
local global="$PWD"
echo "global: $global"
popd || echo "'popd' failed" || exit 1

echo

pwd
local cmd="$(pwd)"
echo "cmd: $cmd"
local global="$PWD"
echo "global: $global"
