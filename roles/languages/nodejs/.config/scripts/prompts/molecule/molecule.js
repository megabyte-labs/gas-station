import chalk from 'chalk'
import inquirer from 'inquirer'
import { execSync } from 'node:child_process'
import { decorateSystem } from '../lib/decorate-system.js'
import { logInstructions, logRaw, LOG_DECORATOR_REGEX } from '../lib/log.js'

const MENU_ENTRY_TITLE_WIDTH = 24

/**
 * Prompts the user for the type of Molecule test they wish to perform
 *
 * @returns {string} The type of test, in lowercase
 */
async function promptForTestType() {
  const DECORATION_LENGTH = 2

  const descriptionMap = [
    'VirtualBox:Headless',
    'VirtualBox:Desktop',
    'Docker',
    'Google Cloud Platform',
    'Local',
    'SSH'
  ]
  const choices = execSync(`yq eval -o=j '.description' molecule/*/molecule.yml`)
    .toString()
    .split('\n')
    .filter((value) => value !== 'null' && value !== '')
    .map((description, index) =>
      // eslint-disable-next-line security/detect-object-injection
      decorateSystem(descriptionMap[index].padEnd(MENU_ENTRY_TITLE_WIDTH) + chalk.gray(description.slice(1, -1)))
    )
  const choicesDecorated = choices.map((choice) => ({
    name: choice,
    short: choice.replace(LOG_DECORATOR_REGEX, '').slice(DECORATION_LENGTH).split(' ')[0]
  }))
  const response = await inquirer.prompt([
    {
      choices: choicesDecorated,
      message: 'What type of test would you like to perform?',
      name: 'testType',
      type: 'list'
    }
  ])

  return response.testType.replace(LOG_DECORATOR_REGEX, '').slice(DECORATION_LENGTH).split(' ')[0]
}

/**
 * Main script logic
 *
 * @returns {Promise} Promise that resolves to an execSync call that runs a Taskfile.yml task
 */
// eslint-disable-next-line max-statements, require-jsdoc, max-lines-per-function
async function run() {
  logInstructions('Molecule Test', 'There are currently five different options for running Molecule tests.\n\n')
  logRaw(chalk.bold('1. VirtualBox:Headless:'))
  logRaw('\nRuns tests using VirtualBox headless VMs. It is the test type used to generate the compatibility chart.\n')
  logRaw(chalk.bold('2. VirtualBox:Desktop:'))
  logRaw(
    '\nRuns tests using a VirtualBox desktop version VM. Use this type of test' +
      ' to run the Ansible play and then open the VirtualBox VM to smoke test the software.\n'
  )
  logRaw(chalk.bold('3. Docker:'))
  logRaw(
    '\nUtilizes Docker to test the Ansible play. It has some limitations such' +
      ' as not being able to test snap installations on all operating systems. It also can only run tests' +
      ' on Linux environments. This is, however, the fastest way to test roles and requires the least amount' +
      ' of RAM.\n'
  )
  logRaw(chalk.bold('4. Local:'))
  logRaw(
    '\nRuns the Ansible play on the local machine. Use this to run the Ansible play on your local' +
      ' machine. You might use this if you want to inspect the software after running the play.\n'
  )
  logRaw(chalk.bold('5. SSH:'))
  logRaw(
    '\nRuns the Ansible play on a remote machine after connecting via SSH. This requires that you' +
      ' already have the SSH credentials configured (i.e. ~/.ssh is setup).'
  )
  logRaw(chalk.bold('6. Google Cloud Platform'))
  logRaw(
    '\nProvisions Google Cloud Platform instances and tests the Ansible play on them. This test requires' +
      ' that you have access to a GCP account and that the proper credentials are in place. For help,' +
      ' see [this guide](https://github.com/ProfessorManhattan/molecule-ansible-google-cloud/blob/master/README.md).' +
      ' Without the environment variables mentioned in the guide set, this task will fail.'
  )
  const testType = await promptForTestType()

  // eslint-disable-next-line functional/no-try-statement
  try {
    if (testType.includes('Local')) {
      return execSync(`task ansible:test:molecule:local`, { stdio: 'inherit' })
    } else if (testType.includes('Headless')) {
      return execSync(`task ansible:test:molecule:virtualbox:prompt`, { stdio: 'inherit' })
    } else if (testType.includes('Docker')) {
      return execSync(`task ansible:test:molecule:docker:prompt`, { stdio: 'inherit' })
    } else if (testType.includes('Desktop')) {
      return execSync(`task ansible:test:molecule:virtualbox:converge:prompt`, { stdio: 'inherit' })
    } else if (testType.includes('SSH')) {
      return execSync(`task ansible:test:molecule:ssh:prompt`, { stdio: 'inherit' })
    } else if (testType.includes('Google')) {
      return execSync(`task ansible:test:molecule:gcp`, { stdio: 'inherit' })
    }

    // eslint-disable-next-line no-process-exit
    return process.exit(1)
  } catch {
    // eslint-disable-next-line no-process-exit
    return process.exit(1)
  }
}

run()
