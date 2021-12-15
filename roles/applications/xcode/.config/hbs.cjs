const glob = require("glob")
const { execSync } = require('child_process')

module.exports.register = function (Handlebars) {
  /**
   * Import [handlebars-helpers](https://github.com/helpers/handlebars-helpers)
   */
  require('handlebars-helpers')({
    handlebars: Handlebars
  });

  /**
   * Returns files/directories matching glob pattern
   */
  Handlebars.registerHelper('glob', function(pattern, options) {
    const files = glob.sync(pattern)

    return files
  })

  Handlebars.registerHelper('poet', function(input, options) {
    const formulae = execSync('poetry run poet -f ' + input)

    return formulae
  })

  Handlebars.registerHelper('taskfileSort', function(taskfiles, options) {
    const sorted = taskfiles.sort((a, b) => {
      const trim = (str) => str.replace('./.config/taskfiles/', '').replace('/Taskfile-', ':').replace('/Taskfile.yml', '').replace('Taskfile-', '').replace('.yml', '')
      const x = trim(a)
      const y = trim(b)
      if (x < y) {
        return -1
      } else if (x > y) {
        return 1
      } else {
        return 0
      }
    })

    return sorted
  })
}
