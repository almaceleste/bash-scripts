#!/bin/bash

# show passed argument in th kdialog
# GNU Affero GPL 3.0 🄯 2022 almaceleste

kdialog --title "show-arg" --msgbox "$@"
echo "$@" > /tmp/test/alma/show-arg

exit 0