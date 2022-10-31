from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

import getpass
import logging
import logging.config
import os
import socket
import sentry_sdk

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

        if not self.SENTRY_DSN:
            self._disable_plugin()
        else:
            self.client = self._load_sentry_client()
            sentry_sdk.capture_message('Heyyyy here', 'error')

    def _load_sentry_client(self):
        client = sentry_sdk.init(
          dsn=self.SENTRY_DSN,
          release="1.0.0",
          debug=True
        )
        return client

    def _disable_plugin(self):
        self.disabled = True
        self._display.warning(
            "The SENTRY_DSN environment variable was not found, plugin %s disabled" % os.path.basename(__file__))

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

    def _set_extra(self, result, scope, playbook):
      scope.set_context('ansible_user', getpass.getuser())
      scope.set_context('ansible_initiator', socket.getfqdn())
      scope.set_context('ansible_data', vars(result))
      scope.set_context('ansible_result', result._result)
      scope.set_context('ansible_task', result._task)
      scope.set_context('ansible_host', result._host.get_name())
      scope.set_context('ansible_host_data', result._host.serialize())


    def v2_playbook_on_start(self, playbook):
        self.playbook = playbook._file_name

    def v2_runner_on_failed(self, result, ignore_errors=False):
        with sentry_sdk.push_scope() as scope:
          self._set_extra(result, scope, self.playbook)
          sentry_sdk.capture_message(self._dump_results(result._result), 'fatal')
          client = sentry_sdk.Hub.current.client
          if client is not None:
            client.close(timeout=4.0)

    def v2_runner_on_unreachable(self, result):
        print('Sentry handling unreachable failure event.')
        extra = self._data_dict(result, self.playbook)
        with sentry_sdk.push_scope() as scope:
          scope.set_extra('debug', extra)
          sentry_sdk.capture_message('Ansible {} - Task execution UNREACHABLE; Host: {}; Message: {}'.format(
            self.playbook, result._host.get_name(), self._dump_results(result._result)), 'fatal')

    def v2_runner_on_async_failed(self, result):
        print('Sentry handling async failure event.')
        extra = self._data_dict(result, self.playbook)
        with sentry_sdk.push_scope() as scope:
          scope.set_extra('debug', extra)
          sentry_sdk.capture_message('Ansible {} - Task async execution FAILED; Host: {}; Message: {}'.format(
            self.playbook, result._host.get_name(), self._dump_results(result._result)), 'fatal')

    def v2_runner_item_on_failed(self, result):
        print('Sentry handling item failure event.')
        extra = self._data_dict(result, self.playbook)
        with sentry_sdk.push_scope() as scope:
          scope.set_extra('debug', extra)
          sentry_sdk.capture_message('Ansible {} - Task execution FAILED; Host: {}; Message: {}'.format(
            self.playbook, result._host.get_name(), self._dump_results(result._result)), 'fatal')
