import chalk from 'chalk'
import inquirer from 'inquirer'
import { execSync } from 'node:child_process'
import { info, logInstructions, LOG_DECORATOR_REGEX } from '../lib/log.js'

/**
 * Prompts the user for details required for provisioning via SSH
 *
 * @returns {string} The operating system string, lowercased
 */
async function promptForSSHDetails() {
  const response = await inquirer.prompt([
    {
      message: 'What is the target\'s IP address or FQDN?',
      name: 'host',
      type: 'input'
    },
    {
      message: 'What is the username of a user that has both sudo privileges and SSH?',
      name: 'user',
      type: 'input',
      default: 'ansible'
    },
    {
      message: 'What is the user\'s sudo password?',
      name: 'password',
      type: 'password',
      default: 'ansible'
    },
    {
      message: 'What port should the SSH connection be made over?',
      name: 'port',
      type: 'input',
      default: '22'
    }
  ])
  info('SSH connection details acquired')

  return response
}

/**
 * Main script logic
 */
async function run() {
  logInstructions(
    'Remote Ansible Molecule Test via SSH',
    'This testing option is provided for cases where you would like to remotely test the Ansible play' +
      ' on remote machines via SSH. The prompts will ask you for the host IP address or FQDN, user, and' +
      ' and password. Before running this test, you should ensure that you can already connect to the machine' +
      ' via SSH (i.e. the ~/.ssh keys should already be set up).'
  )
  const details = await promptForSSHDetails()
  execSync(`TEST_HOST=${details.host} TEST_PASSWORD=${details.password} TEST_PORT=${details.port}
    TEST_SSH_USER=${details.user} TEST_USER=${details.user} task ansible:test:molecule:ssh:cli`, { stdio: 'inherit' })
}

run()
