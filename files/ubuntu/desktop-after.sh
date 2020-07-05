#!/bin/bash
nmcli connection modify "NordVPN USA" vpn.secrets password=
nmcli connection modify "NordVPN USA2" vpn.secrets password=
nmcli connection modify "Mullvad LA (UDP 53)" vpn.secrets password=m