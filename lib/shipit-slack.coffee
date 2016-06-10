utils = require 'shipit-utils'
Slack = require 'node-slack'
ShipitGit = require './shipit-git'

module.exports = (gruntOrShipit) ->
  shipit = utils.getShipit(gruntOrShipit)

  utils.registerTask shipit, 'slack:notify', ->
    slack = new Slack(shipit.config.slack.webhookUrl)
    ShipitGit.getDetails(shipit).then (commit) ->
      username = commit.name
      username += " (#{shipit.environment})" if shipit.environment != "production"
      slack.send {
        text: "[#{commit.rev}] #{commit.msg}"
        username: username
      }

  shipit.on 'published', ->
    shipit.start 'slack:notify' if shipit.config.slack?.webhookUrl
