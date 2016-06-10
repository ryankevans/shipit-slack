utils = require 'shipit-utils'

gitUm = (shipit, cmd) ->
  dir = shipit.config.workspace
  rev = shipit.config.branch or 'HEAD'
  cmd = cmd.replace("%%REV%%", "#{rev}^{commit}")
  shipit.local(cmd, cwd: dir).then (response) ->
    response.stdout.trim()

getGitCommitMsg = (shipit) ->
  gitUm(shipit, 'git log -n 1 --pretty="format:%B" %%REV%%')

getGitName = (shipit) ->
  # cmdRemoteRepo = "git remote show origin -n | grep h.URL | sed 's/.*\\///;s/.git$//'"
  gitUm(shipit, "basename `git rev-parse --show-toplevel`")

getGitRevision = (shipit) ->
  gitUm(shipit, 'git rev-parse --short=10 --verify %%REV%%')

class ShipitGit
  @getDetails: (shipit) ->
    getGitCommitMsg(shipit).then (msg) ->
      getGitRevision(shipit).then (rev) ->
        getGitName(shipit).then (name) ->
          name: name
          rev: rev
          msg: msg

module.exports = ShipitGit
