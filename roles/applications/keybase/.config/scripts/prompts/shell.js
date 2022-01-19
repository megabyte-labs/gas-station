import inquirer from 'inquirer'
import { execSync } from 'node:child_process'
import { decorateSystem } from './lib/decorate-system.js'
import { logInstructions, LOG_DECORATOR_REGEX } from './lib/log.js'

/**
 * Prompts the user for the operating system they wish to launch a shell session with.
 *
 * @returns {string} The selected operating system, lowercased, in the format the Taskfile is expecting
 */
async function promptForShell() {
  const choices = [
    'Archlinux',
    'CentOS 7',
    'CentOS 8',
    'Debian 9',
    'Debian 10',
    'Fedora 33',
    'Fedora 34',
    'Ubuntu 18.04',
    'Ubuntu 20.04',
    'Ubuntu 21.04'
  ]
  const choicesDecorated = choices.map((choice) => decorateSystem(choice))
  const response = await inquirer.prompt([
    {
      choices: choicesDecorated,
      message: 'Which operating system would you like to open up a terminal session with?',
      name: 'operatingSystem',
      type: 'list'
    }
  ])

  const DECORATION_LENGTH = 2

  return response.operatingSystem
    .replace(LOG_DECORATOR_REGEX, '')
    .toLowerCase()
    .slice(DECORATION_LENGTH)
    .replace(' ', '-')
}

/**
 * Main script logic
 */
async function run() {
  logInstructions(
    'Launch Docker Shell Environment',
    'Open a shell session quickly, safely, and easily using Docker.' +
      'Select an option from the prompt below to download and shell into a Docker environment.' +
      ' The environment will be automatically deleted after you exit the terminal session.'
  )
  const choice = await promptForShell()
  execSync(`task common:shell:cli -- ${choice}`, { stdio: 'inherit' })
}

run()
