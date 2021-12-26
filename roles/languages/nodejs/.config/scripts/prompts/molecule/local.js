import inquirer from 'inquirer'
import { execSync } from 'node:child_process'
import { logInstructions } from '../lib/log.js'

/**
 * Prompts the user for sudo password which is required in all cases
 * since Molecule first ensures Python is installed with sudo privileges.
 *
 * @returns {string} The sudo password
 */
async function promptForSudoPass() {
  const response = await inquirer.prompt([
    {
      message: 'What is the sudo password for the current user?',
      name: 'sudoPass',
      type: 'password'
    }
  ])

  return response.sudoPass
}

/**
 * Main script logic
 *
 * @returns {Promise} Promise that resolves to an execSync
 */
async function run() {
  logInstructions(
    'Run Molecule Locally',
    'This testing option is provided for cases where you would like to locally test the Ansible play with' +
      ' Molecule. This option assumes that the current user has sudo privileges.' +
      ' A sudo password is required for all roles because Molecule has a step where' +
      ' it ensures Python is installed with `become: true`. The sudo password could potentially be logged' +
      ' in clear text if logging is in verbose mode so be careful when using this method. If you only want' +
      " to install the play (without leveraging Molecule's features like testing for idempotency and running" +
      ' test cases), then a more secure method would be to run "ansible localhost --ask-sudo-pass -m' +
      ' include_role -a name=<role_name>" after installing the role and its dependencies with ansible-galaxy.'
  )
  const sudoPass = await promptForSudoPass()
  // eslint-disable-next-line functional/no-try-statement
  try {
    return execSync(`TEST_PASSWORD=${sudoPass} task ansible:test:molecule:local:test`, { stdio: 'inherit' })
  } catch {
    // eslint-disable-next-line no-process-exit
    return process.exit(1)
  }
}

run()
