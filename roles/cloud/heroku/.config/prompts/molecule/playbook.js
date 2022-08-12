import chalk from 'chalk'
import inquirer from 'inquirer'
import { execSync } from 'node:child_process'
import * as fs from 'node:fs'
import { decorateFiles } from '../lib/decorate-files.js'
import { logInstructions, logRaw, LOG_DECORATOR_REGEX } from '../lib/log.js'

/**
 * Scans a directory for files inside of it
 *
 * @param {string} path - The path to scan for files in
 * @returns {string[]} An array of files located in the path
 */
function getFiles(path) {
  // eslint-disable-next-line security/detect-non-literal-fs-filename
  return fs.readdirSync(path).filter((file) => {
    // eslint-disable-next-line security/detect-non-literal-fs-filename
    return fs.statSync(`${path}/${file}`).isFile()
  })
}

/**
 * Prompts the user for the inventory file they wish to use
 *
 * @returns {string} The type of test, in lowercase
 */
async function promptForInventory() {
  const choicesDecorated = getFiles('inventories/').map((choice) => decorateFiles(choice))
  const response = await inquirer.prompt([
    {
      choices: choicesDecorated,
      message: 'Which inventory would you like to use?',
      name: 'environment',
      type: 'list'
    }
  ])
  const DECORATION_LENGTH = 2

  return response.environment.replace(LOG_DECORATOR_REGEX, '').slice(DECORATION_LENGTH)
}

/**
 * Main script logic
 *
 * @returns {Promise} Promise that resolves to execSync calls that run the main.yml playbook
 */
// eslint-disable-next-line require-jsdoc
async function run() {
  logInstructions('Run the Playbook', 'These set of prompts will run the main.yml playbook after you specify:\n\n')
  logRaw(chalk.bold('1. The "environment"'))
  logRaw(
    '\nThe environment is a collection of folders that should, at the very minimum, include "files",' +
      ' "group_vars", "host_vars", and "inventories". Each folder in the "environments" folder constitutes a' +
      ' different environment. By using environments, you can seperate different sets of variables/files or even' +
      ' seperate your private variables out into a sub-module.\n'
  )
  logRaw(chalk.bold('2. An inventory file'))
  logRaw(
    '\nThe Ansible inventory stored in the "inventories" folder. This will generally be a YML file with host' +
      ' connection information that also correlates the inventory with the proper host_vars and group_vars.' +
      ' It is assumed that your sudo username and password are encrypted inside the inventory (via "ansible-vault").'
  )

  // eslint-disable-next-line functional/no-try-statement
  try {
    execSync(`task environment`, { stdio: 'inherit' })
    const inventory = await promptForInventory()

    return execSync(`task playbook -- ${inventory}`, { stdio: 'inherit' })
  } catch {
    // eslint-disable-next-line no-process-exit
    return process.exit(1)
  }
}

run()
