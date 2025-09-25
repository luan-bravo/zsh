set -- "foo" "bar" "baz"
echo $@
echo $@[@]
two=2
echo $@[two-1]
echo $@[two]
echo "${@[two]}"

echo
local -a a=("$@")
a+=("boop")

echo "${a[@]}"
cmd="ls"
$cmd $a[@]

set -- "$@" "boop"
echo 
echo ${@}

unset "${@[2]}"
echo "unset ${@}"
unset -- "${@[2]}"
echo "unset ${@}"

echo "${@[2,$#]}"
echo "${@[2,-1]}"

# can't	to set array
# set -- ("foo" "bar" "baz")

# $@+="beep" # cannot concatenate like in a string.. 
# $@+=("beep") # ...nor push like in an array

argsfn() {
	return "$@"
}

args=$(argsfn)
echo "args $args"
echo "argsfn = $(argsfn)"

set -- $args

echo "$@"
