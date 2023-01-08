#!/bin/bash
# Workaround for VoiceError: 17 in wow: https://github.com/firewalld/firewalld/issues/1055
nft add rule inet firewalld filter_INPUT index 1 iifname "lo" accept

#nft list chain inet firewalld filter_INPUT