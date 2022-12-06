/* eslint-disable no-console, sonarjs/no-nested-template-literals, prefer-named-capture-group */
import chalk from 'chalk'
import stringBreak from 'string-break'

const MESSAGE_MAX_WIDTH = 80

// eslint-disable-next-line no-control-regex, security/detect-unsafe-regex
export const LOG_DECORATOR_REGEX = /[\u001B\u009B][#();?[]*(?:\d{1,4}(?:;\d{0,4})*)?[\d<=>A-ORZcf-nqry]/gu

/**
 * Styles log messages that use markdown
 *
 * @param {string} message - The message to style
 * @returns {string} The styled message
 */
function styler(message) {
  const emphasized = /`(.*)`/gu
  const bolded = /\*(.*)\*/gu

  return message.replaceAll(emphasized, chalk.bgGray.white(' $1 ')).replaceAll(bolded, chalk.bold('$1'))
}

/**
 * Logs an informational message with pleasant styling
 *
 * @param {string} title - The title to show in emphasized styling
 * @param {string} message - The instructions for the operation
 */
export function logInstructions(title, message) {
  console.log(`\n${chalk.white.bgBlueBright.bold(`   ${title}   `)}`)
  const formattedMessage =
    process.stdout.columns > MESSAGE_MAX_WIDTH ? stringBreak(message, MESSAGE_MAX_WIDTH).join('\n') : message
  console.log(`\n${formattedMessage}\n`)
}

/**
 * Logs a message that is limited in width
 *
 * @param {string} message - Message to ensure max-width on
 */
export function logRaw(message) {
  const formattedMessage =
    process.stdout.columns > MESSAGE_MAX_WIDTH ? stringBreak(message, MESSAGE_MAX_WIDTH).join('\n') : message
  console.log(`${formattedMessage}\n`)
}

/**
 * Logs a regular message
 *
 * @param {string} message - The message
 */
export function info(message) {
  console.log(`${chalk.blue(`●`)} ${styler(message)}`)
}

/**
 * Logs an error message
 *
 * @param {string} message - The message
 */
export function error(message) {
  console.log(`\n${chalk.white.bgRedBright.bold(`   ERROR   `)}\n${chalk.white.bold(`┗`)} ${styler(message)}\n`)
}

/**
 * Logs a message with a star next to it
 *
 * @param {string} message - The message
 */
export function star(message) {
  console.log(`\n⭐ ${styler(message)}\n`)
}

/**
 * Logs a success message
 *
 * @param {string} message - The message
 */
export function success(message) {
  console.log(`${chalk.green.bold(`✔`)} ${styler(message)}`)
}

/**
 * Logs a warning message
 *
 * @param {string} message - The message
 */
export function warn(message) {
  console.log(`\n${chalk.black.bgYellowBright.bold(`    WARN   `)}\n${chalk.white.bold(`┗`)} ${styler(message)}\n`)
}

const funcs = {
  error,
  info,
  star,
  success,
  warn
}

const LOG_TYPE_INDEX = 2
const LOG_MESSAGE_INDEX = 3

// eslint-disable-next-line security/detect-object-injection
if (process.argv.length > LOG_TYPE_INDEX && typeof funcs[process.argv[LOG_TYPE_INDEX]] === 'function') {
  // eslint-disable-next-line security/detect-object-injection
  funcs[process.argv[LOG_TYPE_INDEX]](process.argv[LOG_MESSAGE_INDEX])
}
