import inquirer from 'inquirer'
import { execSync } from 'node:child_process'
import { logInstructions } from '../lib/log.js'

/**
 * Prompts the user for details required for provisioning via SSH
 *
 * @returns {string} The operating system string, lowercased
 */
async function promptForSSHDetails() {
  const response = await inquirer.prompt([
    {
      message: "What is the target's IP address or FQDN?",
      name: 'host',
      type: 'input'
    },
    {
      default: '22',
      message: 'What port should the SSH connection be made over?',
      name: 'port',
      type: 'input'
    },
    {
      default: 'root',
      message: 'What is the username of a user that has both sudo and SSH privileges?',
      name: 'user',
      type: 'input'
    }
  ])

  if (response.user !== 'root') {
    const sudoPass = await inquirer.prompt([
      {
        message: "What is the user's sudo password?",
        name: 'password',
        type: 'password'
      }
    ])

    return { ...sudoPass, ...response }
  }

  return { password: '', ...response }
}

/**
 * Main script logic
 *
 * @returns {Promise} Promise that resolves to an execSync
 */
async function run() {
  logInstructions(
    'Remote Ansible Molecule Test via SSH',
    'This testing option is provided for cases where you would like to remotely test the Ansible play' +
      ' on remote machines via SSH. The prompts will ask you for the host IP address or FQDN, user, and' +
      ' and password. Before running this test, you should ensure that you can already connect to the machine' +
      ' via SSH (i.e. the ~/.ssh keys should already be set up). This test assumes that SSH does' +
      ' not require any passwords to establish the connection.'
  )
  const details = await promptForSSHDetails()
  // eslint-disable-next-line functional/no-try-statement
  try {
    return execSync(
      `TEST_HOST=${details.host} TEST_PASSWORD=${details.password} TEST_BECOME_PASSWORD=${details.password} \
      TEST_PORT=${details.port} TEST_SSH_USER=${details.user} TEST_USER=${details.user} poetry run \
      task ansible:test:molecule:ssh:cli`,
      { stdio: 'inherit' }
    )
  } catch {
    // eslint-disable-next-line no-process-exit
    return process.exit(1)
  }
}

run()
