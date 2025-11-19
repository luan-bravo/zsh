#!/usr/bin/env zsh

local arr=("one" "two" "three")
local str="four five six"

set -- "${arr[@]}" "${=str}" "bar"

echo "2: $2" # two
echo "5: $5" # five
echo "foo: $7" # bar
