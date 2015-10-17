Promise = require "promise"
request = require "request"
cheerio = require "cheerio"

ROOT_URL = "http://tunein.com"

exports.searchForShow = (phrase) ->
  new Promise (resolve, reject) ->
    podcasts = []

    request "#{ROOT_URL}/search?query=#{encodeURIComponent phrase}", (err, resp, body) ->
      if err
        reject err
      else
        $ = cheerio.load body

        # get all programs
        $("h2:contains(Program) + .group li.guide-item").each (pct, p) ->
          podcast = $ p

          # extract the parts we care about
          podcast_name = podcast.find("h3.title").text()
          podcast_desc = podcast.find(".subtitle").text()
          podcast_link = ROOT_URL + podcast.find("a.overlay-hover-trigger").attr "href"

          # create the object
          podcasts.push
            name: podcast_name
            desc: podcast_desc
            external_link: podcast_link

        resolve podcasts


# get all episodes of a specified show
exports.getEpisodesOfShow = (show) ->
  new Promise (resolve, reject) ->
    request show.external_link, (err, resp, body) ->
      if err
        reject err
      else
        $ = cheerio.load body

        episodes = []

        # get all episodes
        $(".topic-pager .topic").each (tct, t) ->
          show = $ t

          episode_name = show.find(".info h3").text()
          episode_desc = show.find(".topic-description").text()
          episode_link = ROOT_URL + show.find("a.overlay-hover-trigger").attr 'href'

          # get the url of the stream
          stream_info_url = body.match /StreamUrl\":\"(.*?),/

          episodes.push
            name: episode_name
            desc: episode_desc.toString().trim()
            external_link: episode_link
            stream_info_url: stream_info_url and stream_info_url[1] or null

        resolve episodes


exports.getStreamData = (show) ->
  new Promise (resolve, reject) ->
    request show.stream_info_url, (err, resp, body) =>
      if err
        reject err
      else
        data = body.slice(1, body.length-2)
        if streams = JSON.parse data
          resolve streams
        else
          reject()

#
#
#
# exports.searchForShow("stuff you should know").then (show) ->
#   console.log show[0].name
#
#   exports.getEpisodesOfShow(show[0]).then (episodes) ->
#     console.log episodes[0].name
#
#     exports.getStreamData(episodes[0]).then console.log.bind(console)
