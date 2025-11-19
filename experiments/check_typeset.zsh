setopt localoptions glob nullglob

check_typeset
local a=("one" "two three")
local no_such_variable=$(typeset -p asdfasdf)
echo "if:"
[[ "$no_suc" = *"no such variable"* ]] \
    && echo "\tno such variable"
    || echo "\tFAIL"

echo "case:"
case "$no_such_variable" in
    *"no such variable"*)
        echo "\tno such variable"
        ;;
    *)
        echo "\tFAIL"
        ;;
esac
