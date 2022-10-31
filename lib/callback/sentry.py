from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

import getpass
import logging
import logging.config
import os
import socket

try:
     from sentry_sdk import Client
     HAS_SENTRY = True
except ImportError:
     HAS_SENTRY = False

from ansible.plugins.callback import CallbackBase

class CallbackModule(CallbackBase):
    """
    Ansible Sentry callback plugin.
    Modified version of https://gist.github.com/fliphess/7f6dd322388054dd1dcc07f55b1034db#file-sentry-py-L13
    Updated to use the latest Sentry SDK.
    ansible.cfg:
        callback_plugins   = <path_to_callback_plugins_folder>
        callback_whitelist = sentry
    and put the plugin in <path_to_callback_plugins_folder>
    Requires:
        sentry_sdk
    This plugin makes use of the following environment variables:
        SENTRY_DSN        (required): The full private DSN
    """

    CALLBACK_VERSION = 2.0
    CALLBACK_TYPE = 'aggregate'
    CALLBACK_NAME = 'sentry'
    CALLBACK_NEEDS_WHITELIST = True

    SENTRY_DSN = os.getenv('SENTRY_DSN')

    def __init__(self):
        super(CallbackModule, self).__init__()

        if not self.SENTRY_DSN or not HAS_SENTRY:
            self._disable_plugin()
        else:
            self.client = self._load_sentry_client()

    def _load_sentry_client(self):
        client = Client(
          dsn=self.SENTRY_DSN,
          release="0.0.1"
        )
        return client

    def _disable_plugin(self):
        self.disabled = True
        self._display.warning(
            "The sentry_sdk pip package or SENTRY_DSN environment variable were not found, plugin %s disabled" % os.path.basename(__file__))

    def _data_dict(self, result, playbook):
        return {
            "stack": True,
            "ansible_user": getpass.getuser(),
            "ansible_initiator": socket.getfqdn(),
            "ansible_data": vars(result),
            "ansible_result": result._result,
            "ansible_task": result._task,
            "ansible_host": result._host.get_name(),
            "ansible_host_data": result._host.serialize(),
        }

    def v2_playbook_on_start(self, playbook):
        self.playbook = playbook._file_name

    def v2_runner_on_failed(self, result, ignore_errors=False):
        print('Sentry handling failure event.')
        extra = self._data_dict(result, self.playbook)
        with sentry_sdk.push_scope() as scope:
          scope.set_extra('debug', extra)
          sentry_sdk.capture_message('Ansible {} - Task execution FAILED; Host: {}; Message: {}'.format(
            self.playbook, result._host.get_name(), self._dump_results(result._result)), 'error')

    def v2_runner_on_unreachable(self, result):
        print('Sentry handling unreachable failure event.')
        extra = self._data_dict(result, self.playbook)
        with sentry_sdk.push_scope() as scope:
          scope.set_extra('debug', extra)
          sentry_sdk.capture_message('Ansible {} - Task execution UNREACHABLE; Host: {}; Message: {}'.format(
            self.playbook, result._host.get_name(), self._dump_results(result._result)), 'info')

    def v2_runner_on_async_failed(self, result):
        print('Sentry handling async failure event.')
        extra = self._data_dict(result, self.playbook)
        with sentry_sdk.push_scope() as scope:
          scope.set_extra('debug', extra)
          sentry_sdk.capture_message('Ansible {} - Task async execution FAILED; Host: {}; Message: {}'.format(
            self.playbook, result._host.get_name(), self._dump_results(result._result)), 'error')

    def v2_runner_item_on_failed(self, result):
        print('Sentry handling item failure event.')
        extra = self._data_dict(result, self.playbook)
        with sentry_sdk.push_scope() as scope:
          scope.set_extra('debug', extra)
          sentry_sdk.capture_message('Ansible {} - Task execution FAILED; Host: {}; Message: {}'.format(
            self.playbook, result._host.get_name(), self._dump_results(result._result)), 'error')
