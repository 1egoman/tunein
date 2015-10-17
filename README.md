Tunein Radio npm module
===

Everything returns a promise.

### tunein.searchForShow("seach terms")
Searches for a specified show. Returns a list of shows.

### tunein.getEpisodesOfShow(show)
Specify a show, and it will return a list of episodes of that show.

### tunein.getStreamData(episodes[0])
Specify an episode to get the location of the stream for the specified episode.

## Coffeescript Example
```coffee
tunein.searchForShow("stuff you should know").then (show) ->
  console.log show[0].name

  tunein.getEpisodesOfShow(show[0]).then (episodes) ->
    console.log episodes[0].name

    tunein.getStreamData(episodes[0]).then (stream) ->
      console.log stream
```
