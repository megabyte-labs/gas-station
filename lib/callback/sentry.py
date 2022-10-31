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

    def _load_sentry_client(self):
        client = sentry_sdk.init(
          dsn=self.SENTRY_DSN,
          release="1.0.0",
          debug=False
        )
        return client

    def _disable_plugin(self):
        self.disabled = True
        self._display.warning(
            "The SENTRY_DSN environment variable was not found, plugin %s disabled" % os.path.basename(__file__))

    def _set_extra(self, result, scope, playbook):
      scope.set_extra('ansible_user', getpass.getuser())
      scope.set_extra('ansible_initiator', socket.getfqdn())
      scope.set_context('ansible_data', vars(result))
      scope.set_context('ansible_result', result._result)
      scope.set_extra('ansible_task', result._task)
      scope.set_extra('ansible_host', result._host.get_name())
      scope.set_context('ansible_host_data', result._host.serialize())

    def v2_playbook_on_start(self, playbook):
        self._playbook_path = playbook._file_name
        self._playbook_name = os.path.splitext(os.path.basename(self._playbook_path))[0]
        sentry_sdk.add_breadcrumb(
          category='playbook',
          message=self._playbook_name,
          level='info',
        )

    def v2_playbook_on_play_start(self, play):
        self._play_name = play.get_name()
        sentry_sdk.add_breadcrumb(
          category='play',
          message=self._play_name,
          level='info',
        )

    def v2_runner_on_ok(self, result):
        sentry_sdk.add_breadcrumb(
          category='ok',
          message=result._task,
          level='info'
        )

    def v2_runner_on_skipped(self, result):
        sentry_sdk.add_breadcrumb(
          category='skip',
          message=result._task,
          level='info'
        )

    def v2_playbook_on_include(self, included_file):
        sentry_sdk.add_breadcrumb(
          category='include',
          message=included_file,
          level='info'
        )

    def v2_playbook_on_task_start(self, task, is_conditional):
        sentry_sdk.add_breadcrumb(
          category='task',
          message=task._task,
          level='info'
        )

    def _log_error(self, result, ignore_errors=False):
        with sentry_sdk.push_scope() as scope:
          self._set_extra(result, scope, self._playbook_name)
          sentry_sdk.capture_message(result._task, 'fatal')
          client = sentry_sdk.Hub.current.client
          if client is not None:
            client.close(timeout=4.0)

    def v2_runner_on_failed(self, result, ignore_errors=False):
      self._log_error(result)

    def v2_runner_on_unreachable(self, result):
      self._log_error(result)

    def v2_runner_on_async_failed(self, result):
        self._log_error(result)

    def v2_runner_item_on_failed(self, result):
        self._log_error(result)
