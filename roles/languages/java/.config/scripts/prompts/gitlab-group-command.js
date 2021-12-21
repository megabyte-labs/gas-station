import inquirer from 'inquirer'
import { writeFileSync } from 'node:fs'

/**
 * Open editor where user can create the bash script they wish to run.
 *
 * @returns {string} The bash script the user created
 */
async function promptForScript() {
  const response = await inquirer.prompt([
    {
      message: 'Enter the bash script',
      name: 'bashScript',
      type: 'editor'
    }
  ])

  return response.bashScript
}

/**
 * Main script logic
 */
async function run() {
  const script = await promptForScript()
  writeFileSync('.cache/gitlab-group-script.sh', script)
  // eslint-disable-next-line no-console
  console.log('.cache/gitlab-group-script.sh')
}

run()
