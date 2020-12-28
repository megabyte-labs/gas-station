#!/bin/bash
rm -rf group_vars
rm -rf host_vars
rm -rf inventories
ln -s ./environments/dev/group_vars group_vars
ln -s ./environments/dev/host_vars host_vars
ln -s ./environments/dev/inventories inventories
