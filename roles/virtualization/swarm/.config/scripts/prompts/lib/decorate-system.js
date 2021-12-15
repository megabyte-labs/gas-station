import chalk from 'chalk'

/**
 * Styles prompt choices for operating systems by
 * adding a styled dot next to the OS entry.
 *
 * @param {string} name - The operating system name, in any format
 * @returns {string} The name with a styled dot prepended to the string
 */
export function decorateSystem(name) {
  const lower = name.toLowerCase()
  if (lower.includes('archlinux')) {
    return `${chalk.cyan('●')} ${name}`
  } else if (lower.includes('centos')) {
    return `${chalk.magenta('●')} ${name}`
  } else if (lower.includes('debian')) {
    return `${chalk.red('●')} ${name}`
  } else if (lower.includes('fedora')) {
    return `${chalk.blue('●')} ${name}`
  } else if (lower.includes('ubuntu')) {
    return `${chalk.yellow('●')} ${name}`
  } else if (lower.includes('mac')) {
    return `${chalk.white('●')} ${name}`
  } else if (lower.includes('windows')) {
    return `${chalk.green('●')} ${name}`
  }

  return `${chalk.black('●')} ${name}`
}
