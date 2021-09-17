#!/bin/bash
echo "
█████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████

███████  █████  ██████  ██████  ██  ██████     ██    ██        ██    ██   ██     ██████
██      ██   ██ ██   ██ ██   ██ ██ ██          ██    ██       ███    ██   ██    ██
█████   ███████ ██████  ██████  ██ ██          ██    ██ █████  ██    ███████    ███████
██      ██   ██ ██   ██ ██   ██ ██ ██           ██  ██         ██         ██    ██    ██
██      ██   ██ ██████  ██   ██ ██  ██████       ████          ██ ██      ██ ██  ██████

█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗
╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝

 ██████ ██      ███████  █████  ███    ██
██      ██      ██      ██   ██ ████   ██
██      ██      █████   ███████ ██ ██  ██
██      ██      ██      ██   ██ ██  ██ ██
 ██████ ███████ ███████ ██   ██ ██   ████

█████ █████ █████ █████ █████ █████ █████
";

echo
echo "##########################################################"
echo "##### Clean cryptogen certificates #######################"
echo "##########################################################"
rm -rf ./crypto-config/ordererOrganizations
rm -rf ./crypto-config/peerOrganizations
