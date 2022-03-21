/* eslint-disable no-negated-condition */
import chalk from 'chalk'
import inquirer from 'inquirer'
import { execSync } from 'node:child_process'
import signale from 'signale'
import { decorateFiles } from './lib/decorate-files.js'
import { logInstructions, LOG_DECORATOR_REGEX } from './lib/log.js'

const DECORATION_LENGTH = 2

/**
 * Writes to package.json with jq
 *
 * @param {string} value - The value being written
 * @param {string} location - The jq key of package.json being written to
 * @returns {void}
 */
function writeField(value, location) {
  execSync(
    `TMP="$(mktemp)" && jq --arg field "${value}" '.blueprint.${location} = $field' package.json` +
      ' > "$TMP" && mv "$TMP" package.json',
    {
      stdio: 'inherit'
    }
  )
}

/**
 * Prompts for the name of the project
 *
 * @returns {*} Void
 */
async function promptForName() {
  const currentName = execSync(`jq -r '.blueprint.name' package.json`).toString().trimEnd()
  if (currentName !== 'null') {
    signale.info('The `name` has already been populated')
  } else {
    logInstructions(
      'Project Name',
      'The project name should be a short, capitalized title for the project. The name is used' +
        ' for the GitLab project title, references to the project in documentation,' +
        ' and as a title for the README.md when the blueprint.title is not specified.'
    )
    const response = await inquirer.prompt([
      {
        message: 'Enter a short, descriptive name for the project:',
        name: 'name',
        type: 'input'
      }
    ])
    writeField(response.name, 'name')
    signale.success('Added `name` to package.json')
  }
}

/**
 * Prompts for the title of the project
 *
 * @returns {*} Void
 */
async function promptForTitle() {
  const currentTitle = execSync(`jq -r '.blueprint.title' package.json`).toString().trimEnd()
  if (currentTitle !== 'null') {
    signale.info('The `title` has already been populated')
  } else {
    logInstructions(
      'Project Title',
      'The project title is a longer version of the project name. It is used as the title header of the README.md.'
    )
    const response = await inquirer.prompt([
      {
        message: 'Enter a catchy title for the project:',
        name: 'title',
        type: 'input'
      }
    ])
    writeField(response.title, 'title')
    signale.success('Added `title` to package.json')
  }
}

/**
 * Prompts for a brief description of the project
 *
 * @returns {*} Void
 */
async function promptForDescription() {
  const currentDesc = execSync(`jq -r '.blueprint.description' package.json`).toString().trimEnd()
  if (currentDesc !== 'null') {
    signale.info('The `description` has already been populated')
  } else {
    logInstructions(
      'Description Instructions',
      `${
        'The brief description should describe the project in as few words as possible while' +
        ' still giving users enough information to know exactly what the project is all about.' +
        ' The description should make sense when placed in the following contexts:\n\n'
      }${chalk.white('●')} A project that {{ description }}\n${chalk.white(
        '●'
      )} This repository is home to a project that {{ description }}`
    )
    const response = await inquirer.prompt([
      {
        message: 'Enter a brief description of the project (no more than 100 characters):',
        name: 'description',
        type: 'input'
      }
    ])
    writeField(response.description, 'description')
    signale.success('Added `description` to package.json')
  }
}

/**
 * Asks what group the project belongs to
 *
 * @param {string} gitUrl - The GitLab URL
 * @returns {string} The group
 */
// eslint-disable-next-line max-statements, require-jsdoc
async function promptForGroup(gitUrl) {
  const currentGroup = execSync(`jq -r '.blueprint.group' package.json`).toString().trimEnd()
  if (currentGroup !== 'null') {
    signale.info('The `group` has already been populated')

    return currentGroup
  }
  const guesses = {
    angular: '/apps/',
    ansible: '/ansible-roles/',
    docker: '/docker/',
    go: '/go/',
    npm: '/npm/',
    packer: '/packer/',
    python: '/python/'
  }
  const guess = Object.entries(guesses)
    .map((value) => (gitUrl.includes(value[1]) ? value[0] : false))
    .find((exists) => exists)
  if (guess) {
    // eslint-disable-next-line security/detect-object-injection
    signale.info(`Setting group to \`${guess}\` because the GitLab URL contained \`${guesses[guess]}\``)
    writeField(guess, 'group')

    return guess
  }
  const choices = ['Angular', 'Ansible', 'Docker', 'Go', 'Node.js', 'Packer', 'Python', 'Other']
  const decoratedChoices = choices.map((choice) => decorateFiles(choice))
  const response = await inquirer.prompt([
    {
      choices: decoratedChoices,
      message: 'What group does this project belong to?',
      name: 'group',
      type: 'list'
    }
  ])

  const groupValue = response.group
    .replace('Node.js', 'npm')
    .replace(LOG_DECORATOR_REGEX, '')
    .toLowerCase()
    .slice(DECORATION_LENGTH)
    .replace(' ', '-')
  writeField(groupValue, 'group')
  signale.success('Added `group` to package.json')

  return groupValue
}

const subgroups = {
  angular: {
    app: '/apps/',
    website: '/website/'
  },
  ansible: {
    playbook: '/non-existant-currently/',
    role: '/ansible-roles/'
  },
  docker: {
    'ansible-molecule': '/ansible-molecule/',
    app: '/docker/app/',
    'ci-pipeline': '/ci-pipeline/',
    'docker-compose': '/docker-compose/',
    software: '/docker/software/'
  },
  go: {
    cli: '/go/cli/',
    library: '/go/library/'
  },
  npm: {
    app: '/npm/app/',
    cli: '/npm/cli/',
    config: '/npm/config/',
    library: '/npm/library/',
    plugin: '/npm/plugin/'
  },
  packer: {
    desktop: 'desktop',
    server: 'server'
  },
  python: {
    cli: '/python/cli/',
    library: '/python/library/'
  }
}

const choiceOptions = {
  angular: ['Application', 'Website', 'Other'],
  ansible: ['Playbook', 'Role', 'Other'],
  docker: ['Ansible Molecule', 'Application', 'CI Pipeline', 'Docker Compose', 'Software', 'Other'],
  go: ['CLI', 'Library', 'Other'],
  npm: ['Application', 'CLI', 'Configuration', 'Library', 'Plugin', 'Other'],
  packer: ['Desktop', 'Server', 'Other'],
  python: ['CLI', 'Library', 'Other']
}

/**
 * Asks what subgroup the project belongs to
 *
 * @param {string} gitUrl - The GitLab URL
 * @param {string} group - The project's group
 * @returns {string} The subgroup
 */
// eslint-disable-next-line max-statements, require-jsdoc
async function promptForSubgroup(gitUrl, group) {
  const currentSubgroup = execSync(`jq -r '.blueprint.subgroup' package.json`).toString().trimEnd()
  if (currentSubgroup !== 'null') {
    signale.info('The `subgroup` has already been populated')

    return currentSubgroup
  }
  if (group === 'other') {
    return 'other'
  }
  // eslint-disable-next-line security/detect-object-injection
  const guesses = subgroups[group] ? subgroups[group] : {}
  const guess = Object.entries(guesses)
    .map((value) => (gitUrl.includes(value[1]) ? value[0] : false))
    .find((exists) => exists)
  if (guess) {
    // eslint-disable-next-line security/detect-object-injection
    signale.info(`Setting subgroup to \`${guess}\` because the GitLab URL contained \`${guesses[guess]}\``)
    writeField(guess, 'subgroup')

    return guess
  }
  // eslint-disable-next-line security/detect-object-injection
  const choices = choiceOptions[group]
  const decoratedChoices = choices.map((choice) => decorateFiles(choice))
  const response = await inquirer.prompt([
    {
      choices: decoratedChoices,
      message: 'What sub-group does this project belong to?',
      name: 'subgroup',
      type: 'list'
    }
  ])

  const subgroupValue = response.subgroup
    .replace('Application', 'app')
    .replace('Configuration', 'config')
    .replace(LOG_DECORATOR_REGEX, '')
    .toLowerCase()
    .slice(DECORATION_LENGTH)
    .replace(' ', '-')
  signale.success('Added `subgroup` to package.json')
  writeField(subgroupValue, 'subgroup')

  return subgroupValue
}

/**
 * Prompts for the GitHub repository
 *
 * @returns {string} The GitHub repository
 */
async function githubPrompt() {
  const githubRepo = execSync(`jq -r '.blueprint.repository.github' package.json`).toString().trimEnd()
  if (githubRepo !== 'null') {
    signale.info('The GitHub repository URL in the blueprint data is already present')

    return githubRepo
  }
  const response = await inquirer.prompt([
    {
      message:
        'What is planned GitHub repository HTTPS address' +
        ' (e.g. https://github.com/ProfessorManhattan/ansible-androidstudio)?',
      name: 'github',
      type: 'input'
    }
  ])

  writeField(response.github, 'repository.github')
  signale.success('Added `repository.github` to package.json')

  return response.github
}

/**
 * Prompts for the GitLab repository
 *
 * @returns {string} The GitLab repository
 */
async function gitlabPrompt() {
  const gitlabRepo = execSync(`jq -r '.blueprint.repository.gitlab' package.json`).toString().trimEnd()
  if (gitlabRepo !== 'null') {
    signale.info('The GitLab repository URL in the blueprint data is already present')

    return gitlabRepo
  }
  const response = await inquirer.prompt([
    {
      message: 'What is planned GitLab repository HTTPS address (e.g. https://gitlab.com/megabyte-labs/gas-station)?',
      name: 'gitlab',
      type: 'input'
    }
  ])
  writeField(response.gitlab, 'repository.gitlab')
  signale.success('Added `repository.gitlab` to package.json')

  return response.gitlab
}

/**
 * This step acquires the git repositories by first checking `git remote get-url origin` and
 * then prompting the user for missing information
 *
 * @returns {*} An object containing the GitLab and GitHub repositories
 */
// eslint-disable-next-line max-statements, require-jsdoc
async function getGitRepositories() {
  // eslint-disable-next-line functional/no-try-statement
  try {
    const gitOrigin = execSync(`git remote get-url origin`).toString().trimEnd()
    if (gitOrigin.includes('gitlab.com')) {
      signale.info('Detected GitLab address automatically')
      const github = await githubPrompt()

      return {
        github,
        gitlab: gitOrigin
          .replace('git@gitlab', 'https://gitlab')
          .replace('gitlab.com:', 'gitlab.com/')
          .replace('.git', '')
      }
    } else if (gitOrigin.includes('github.com')) {
      signale.info('Detected GitHub address automatically')
      const gitlab = await gitlabPrompt()

      return {
        github: gitOrigin
          .replace('git@github', 'https://gitlab')
          .replace('github.com:', 'github.com/')
          .replace('.git', ''),
        gitlab
      }
    }
    // eslint-disable-next-line functional/no-throw-statement
    throw Error
  } catch {
    const gitlab = await gitlabPrompt()
    const github = await githubPrompt()

    return {
      github,
      gitlab
    }
  }
}

/**
 * Open editor where user can add markdown for the overview.
 *
 * @returns {*} Void
 */
async function promptForOverview() {
  const currentOverview = execSync(`jq -r '.blueprint.overview' package.json`).toString().trimEnd()
  if (currentOverview !== 'null') {
    signale.info('The `overview` has already been populated')
  } else {
    const response = await inquirer.prompt([
      {
        message: 'Enter an overview for the project',
        name: 'overview',
        type: 'editor'
      }
    ])
    writeField(response.overview, 'overview')
    signale.success('Added `overview` to package.json')
  }
}

/**
 * Main script logic
 */
// eslint-disable-next-line require-jsdoc
async function run() {
  logInstructions(
    'Package Initialization',
    'Provide answers to the following prompts to initialize the project. Some parts of the build process' +
      ' are dependent on some of the answers, so it is important to answer the questions.'
  )

  await promptForName()
  await promptForTitle()
  await promptForDescription()
  const gits = await getGitRepositories()
  const group = await promptForGroup(gits.gitlab)
  await promptForSubgroup(gits.gitlab, group)
  await promptForOverview()
  const slug = gits.gitlab.split('/').at(-1)
  writeField(slug, 'slug')
}

run()
