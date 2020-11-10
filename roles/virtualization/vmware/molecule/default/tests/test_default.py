# Copyright 2018 VMware, Inc. All Rights Reserved.
# SPDX-License-Identifier: MIT OR GPL-3.0-only
import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_hosts_file(host):
    f = host.file('/usr/bin/vmware')

    assert f.exists
    assert f.user == 'root'
    assert f.group == 'root'
