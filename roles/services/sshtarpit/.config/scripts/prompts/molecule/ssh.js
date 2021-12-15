import inquirer from 'inquirer'
import { execSync } from 'node:child_process'
import { decorateSystem } from '../lib/decorate-system.js'
import { logInstructions, LOG_DECORATOR_REGEX } from '../lib/log.js'

/**
 * Prompts the user for the operating system they wish to launch and test the
 * Ansible play against.
 *
 * @returns {string} The operating system string, lowercased
 */
async function promptForDesktop() {
  const choices = ['Archlinux', 'CentOS', 'Debian', 'Fedora', 'macOS', 'Ubuntu', 'Windows']
  const choicesDecorated = choices.map((choice) => decorateSystem(choice))
  const response = await inquirer.prompt([
    {
      choices: choicesDecorated,
      message: 'Which desktop operating system would you like to test the Ansible play against?',
      name: 'operatingSystem',
      type: 'list'
    }
  ])

  const DECORATION_LENGTH = 2

  return response.operatingSystem.replace(LOG_DECORATOR_REGEX, '').toLowerCase().slice(DECORATION_LENGTH)
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
  const environment = await promptForDesktop()
  execSync(`task ansible:test:molecule:virtualbox:converge:cli -- ${environment}`, { stdio: 'inherit' })
}

run()
