from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

import getpass
import logging
import logging.config
import os
import socket

try:
     from raven import setup_logging, Client
     from raven.handlers.logging import SentryHandler
     HAS_RAVEN = True
except ImportError:
     HAS_RAVEN = False

from ansible.plugins.callback import CallbackBase


class CallbackModule(CallbackBase):
    """
    Ansible sentry callback plugin based on the logstash callback plugin
    ansible.cfg:
        callback_plugins   = <path_to_callback_plugins_folder>
        callback_whitelist = sentry
    and put the plugin in <path_to_callback_plugins_folder>
    Requires:
        python-raven
    This plugin makes use of the following environment variables:
        SENTRY_DSN        (required): The full private DSN
    """

    CALLBACK_VERSION = 2.0
    CALLBACK_TYPE = 'aggregate'
    CALLBACK_NAME = 'sentry'
    CALLBACK_NEEDS_WHITELIST = True

    SENTRY_DSN = os.getenv('SENTRY_DSN')
    SENTRY_LOGGING = {
        'version': 1,
        'disable_existing_loggers': True,
        'handlers': {
            'sentry': {
                'level': 'ERROR',
                'class': 'raven.handlers.logging.SentryHandler',
                'dsn': SENTRY_DSN,
            },
        },
        'loggers': {
            'ansible-sentry': {
                'level': 'DEBUG',
                'propagate': True,
            },
        }
    }

    def __init__(self):
        super(CallbackModule, self).__init__()

        if not self.SENTRY_DSN or not HAS_RAVEN:
            self._disable_plugin()
        else:
            self.client = self._load_sentry_client()
            self.logger = self._setup_logging()

    def _setup_logging(self):
        logging.config.dictConfig(self.SENTRY_LOGGING)
        return logging.getLogger(name='ansible-sentry')

    def _load_sentry_client(self):
        client = Client(self.SENTRY_DSN)
        setup_logging(handler=SentryHandler(client))
        return client

    def _disable_plugin(self):
        self.disabled = True
        self._display.warning(
            "python-raven package or SENTRY_DSN environment variable not found, plugin %s disabled" % os.path.basename(__file__))

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
        extra = self._data_dict(result, self.playbook)
        self.logger.error('Ansible {} - Task execution FAILED; Host: {}; Message: {}'.format(
            self.playbook, result._host.get_name(), self._dump_results(result._result)), extra=extra)

    def v2_runner_on_unreachable(self, result):
        extra = self._data_dict(result, self.playbook)
        self.logger.error('Ansible {} - Task execution UNREACHABLE; Host: {}; Message: {}'.format(
            self.playbook, result._host.get_name(), self._dump_results(result._result)), extra=extra)

    def v2_runner_on_async_failed(self, result):
        extra = self._data_dict(result, self.playbook)
        self.logger.error('Ansible {} - Task async execution FAILED; Host: {}; Message: {}'.format(
            self.playbook, result._host.get_name(), self._dump_results(result._result)), extra=extra)

    def v2_runner_item_on_failed(self, result):
        extra = self._data_dict(result, self.playbook)
        self.logger.error('Ansible {} - Task execution FAILED; Host: {}; Message: {}'.format(
            self.playbook, result._host.get_name(), self._dump_results(result._result)), extra=extra)
