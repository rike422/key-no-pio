# Description:
#   Get ticket title from Redmine Api.
#
# Commands:
#   http://redmine.hoge.com/issues/<ticket_id> - Get ticket title.

async = require 'async'

redmineUri = process.env.REDMINE_URI
redmineApiAccessKey = process.env.REDMINE_API_ACCESS_KEY
console.log(redmineUri)
module.exports = (robot) ->
  robot.hear new RegExp(redmineUri + '/issues/[0-9]+', 'g'), (msg) ->
    getAsyncTicketName = (ticketId, i) ->
      (next) ->
        console.log("#{redmineUri}/issues/#{ticketId}.json")
        msg.http("#{redmineUri}/issues/#{ticketId}.json")
          .query(key: redmineApiAccessKey)
          .get() (err, res, body) ->
            if res.statusCode == 200 or res.statusCode == 304
              msg.send "=>##{ticketId} #{JSON.parse(body).issue.subject}"
            else
              msg.send "=>##{ticketId}  そのチケットはありませんでした。（´・ω・｀）"
            next()
    task = []
    for url, i in msg.match
      ticketId = url.match /[0-9]+/g
      task.push getAsyncTicketName ticketId, i

    async.series task