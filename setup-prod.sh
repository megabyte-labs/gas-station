#!/bin/bash
rm -rf group_vars
rm -rf host_vars
rm -rf inventories
ln -s ./environments/prod/group_vars group_vars
ln -s ./environments/prod/host_vars host_vars
ln -s ./environments/prod/inventories inventories
