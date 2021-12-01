import chalk from 'chalk'

/**
 * Styles prompt choices for files
 *
 * @param {string} name - The file/directory
 * @returns {string} The file/directory with an icon
 */
export function decorateFiles(name) {
  return `${chalk.cyanBright('◼')} ${name}`
}
