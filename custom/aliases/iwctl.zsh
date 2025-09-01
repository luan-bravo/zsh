# iwd wi-fi manager aliases
alias iwpower="rfkill unblock all && iwctl device wlan0 set-property powered on"
alias iwshow="iwctl station wlan0 show"
alias iwscan="iwctl station wlan0 get-networks"
