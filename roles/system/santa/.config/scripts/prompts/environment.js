/* eslint-disable security/detect-non-literal-fs-filename */

import inquirer from 'inquirer'
import * as fs from 'node:fs'
import signale from 'signale'
import { decorateFiles } from './lib/decorate-files.js'
import { logInstructions } from './lib/log.js'

const fatalErrorMessage = 'The logger encountered a fatal error!'

/**
 * Scans a directory for directories inside it
 *
 * @param {string} path - The path to scan for directories in
 * @returns {string[]} An array of directories located in the path
 */
function getDirectories(path) {
  return fs.readdirSync(path).filter((file) => {
    return fs.statSync(`${path}/${file}`).isDirectory()
  })
}

/**
 * Unlinks previous symlink and then relinks.
 *
 * @param {string} element - Path of symlink element
 * @param {string} target - Path of symlink target
 * @param {string} environment - The environment being linked to
 */
function syncLink(element, target, environment) {
  fs.unlinkSync(element)
  fs.symlinkSync(target, element, (error) => {
    if (error) {
      return signale.error(fatalErrorMessage, error)
    }

    return signale.note(`${element} is now linked to environments/${environment}/${element}.`)
  })
}

/**
 * Prompts the user for the environment they wish to use by asking them
 * which folder in the environments/ folder to use to create symlinks
 * to the root of the project.
 *
 * @returns {*} An object with details on whether to show a warning message or a "flawless" success message
 */
async function promptForEnvironment() {
  const choicesDecorated = getDirectories('environments/').map((choice) => decorateFiles(choice))
  const response = await inquirer.prompt([
    {
      choices: choicesDecorated,
      message: 'Which environment would you like to use?',
      name: 'environment',
      type: 'list'
    }
  ])
  const environment = response.environment.replace('◼ ', '')
  // eslint-disable-next-line sonarjs/cognitive-complexity
  const elements = fs.readdirSync(`environments/${environment}/`).map((element) => {
    return new Promise((resolve) => {
      const target = `./environments/${environment}/${element}`
      if (fs.existsSync(element)) {
        fs.lstat(element, (error, stats) => {
          if (error) {
            signale.error(fatalErrorMessage, error)
          }
          if (!stats.isSymbolicLink()) {
            signale.error(
              `The \`${element}\` target in your project root is not a symbolic link. If you plan on using this` +
                ` feature then you should store any folders/files you wish to be considered part` +
                ` of an environment in the \`environments/{{ environment_name }}/\` folder. You can` +
                ` then use this script to handle creating the symbolic links for you. We are skipping` +
                ` the creation of the symlink to \`environments/${environment}/${element}\` because there` +
                ` is a non-symbolic link with the same name in the root of the project.`
            )
            resolve(false)
          }
          syncLink(element, target, environment)
          resolve(true)
        })
      } else {
        fs.symlinkSync(target, element, (error) => {
          if (error) {
            signale.error(fatalErrorMessage, error)
            resolve(false)
          } else {
            signale.note(`${element}/ is now linked to environments/${environment}/${element}.`)
          }
          resolve(true)
        })
      }
    })
  })

  return { environment, warning: elements.includes(false) }
}

/**
 * Main script logic
 */
async function run() {
  logInstructions(
    'Symlink Environment',
    'Answer the prompt below to switch between environments. Each environment' +
      ' should be a folder with folders and files you wish to link to from the root' +
      ' of the project. They should normally consist of a host_vars, group_vars,' +
      ' inventory, and files folder (but can contain any files/folders you wish to link).' +
      ' Each environment should have its own folder in the `environments/` folder titled' +
      ' as the name of the environment. After you select an answer, the script will' +
      ' symlink all of the items in the environments folder to the root as long as there' +
      ' is not anything except a symlink to the target location (i.e. it will overwrite' +
      ' symlinks but not files).'
  )
  const data = await promptForEnvironment()
  if (data.warning) {
    signale.warn(`There was an error linking the ${data.environment} environment.`)
  } else {
    signale.success(`The ${data.environment} environment is now active.`)
  }
}

run()
