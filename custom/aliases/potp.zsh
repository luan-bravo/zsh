# Pass OTP
potp() {
    [[ $# -ne 1 ]] && {
        ec ${red} "potp: please provide (only) one argument" && return 1
    }
    pass otp "$1"
}
