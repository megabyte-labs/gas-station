import chalk from 'chalk'
import inquirer from 'inquirer'
import { execSync } from 'node:child_process'
import { decorateSystem } from '../lib/decorate-system.js'
import { logInstructions, LOG_DECORATOR_REGEX } from '../lib/log.js'

const MENU_ENTRY_TITLE_WIDTH = 24

/**
 * Prompts the user for the environment group they would like to target
 *
 * @returns {string} The environment group string, lowercased
 */
async function promptForGroup() {
  const DECORATION_LENGTH = 2

  const groups = JSON.parse(execSync("yq eval -o=j '.groups' molecule/default/molecule.yml"))
  const choices = Object.keys(groups).map((key) =>
    // eslint-disable-next-line security/detect-object-injection
    decorateSystem(key.padEnd(MENU_ENTRY_TITLE_WIDTH) + chalk.gray(groups[key]))
  )
  const choicesDecorated = choices.map((choice) => ({
    name: choice,
    short: choice.replace(LOG_DECORATOR_REGEX, '').slice(DECORATION_LENGTH).split(' ')[0]
  }))
  const response = await inquirer.prompt([
    {
      choices: choicesDecorated,
      message: 'What environment(s) would you like to target with this test?',
      name: 'group',
      type: 'list'
    }
  ])

  return response.group.replace(LOG_DECORATOR_REGEX, '').slice(DECORATION_LENGTH).split(' ')[0]
}

/**
 * Main script logic
 *
 * @returns {Promise} Promise that resolves to an execSync
 */
async function run() {
  logInstructions(
    'Ansible Molecule Test via Headless VirtualBox Instances',
    'This particular type of test is the best method for testing Ansible plays. It uses VirtualBox' +
      ' and utilizes headless images. Despite that, running the test across all the supported' +
      ' operating systems is RAM intensive. Ideally, you should have at least 16GB of RAM to run' +
      ' all the tests at once. This type of test is used to generate the compatibility chart so the results' +
      ' of this type of test have the final say.'
  )
  const group = await promptForGroup()
  // eslint-disable-next-line functional/no-try-statement
  try {
    return execSync(
      `ANSIBLE_ENABLE_TASK_DEBUGGER=true task ansible:test:molecule:virtualbox:cli \
      -- ${group}`,
      { stdio: 'inherit' }
    )
  } catch {
    // eslint-disable-next-line no-process-exit
    return process.exit(1)
  }
}

run()
