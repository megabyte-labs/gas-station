#!/bin/bash

# Running this file will point the symlinks (group_vars/, host_vars/, inventories/) to
# this environment.

SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")

rm -f "$SCRIPT_DIR/../../group_vars"
ln -s "$SCRIPT_DIR/group_vars" "$SCRIPT_DIR/../../group_vars"
rm -f "$SCRIPT_DIR/../../host_vars"
ln -s "$SCRIPT_DIR/host_vars" "$SCRIPT_DIR/../../host_vars"
rm -f "$SCRIPT_DIR/../../inventories"
ln -s "$SCRIPT_DIR/inventories" "$SCRIPT_DIR/../../inventories"
