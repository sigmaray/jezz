# Code is crap
# TODO: Refactor

$ ->
  if $('#carousel_page').length
    page = 1
    scrollPos = 0
    oldScrollPos = 0
    imgs = []

    downloadPics = (pic, page = 1, per_page = PER_PAGE) ->
      imgs = []
      url = 'https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=' + API_KEY + '&text=' + pic + '&safe_search=1&page=' + page + '&per_page=' + per_page
      $.ajax({
        dataType: "json"
        url: url + '&format=json&jsoncallback=?'
        success: (data) ->
          if !data["photos"]?
            notify(JSON.stringify(["Problem with data", data]))
          else
            $.each data.photos.photo, (i, item) ->
              # src = 'http://farm' + item.farm + '.static.flickr.com/' + item.server + '/' + item.id + '_' + item.secret + '_m.jpg'
              src = 'http://farm' + item.farm + '.static.flickr.com/' + item.server + '/' + item.id + '_' + item.secret + '_h.jpg'
              # bigImageSrc = 'http://farm' + item.farm + '.static.flickr.com/' + item.server + '/' + item.id + '_' + item.secret + '_c.jpg'
              # bigImageSrc = 'http://farm' + item.farm + '.static.flickr.com/' + item.server + '/' + item.id + '_' + item.secret + '_h.jpg'
              flickrUrl = 'https://www.flickr.com/photos/' + item.owner + '/' + item.id
              imgs.push({src: src, flickrUrl: flickrUrl})
            initCarousel()
        error: (jqXHR, textStatus, errorThrown) ->
          notify(JSON.stringify(['AJAX Error', jqXHR, textStatus, errorThrown]))
      })

    addPics = ->
      downloadPics($('#searchInput').val(), page, CAROUSEL_PER_PAGE)
      page++

    doStuff = (e) ->
      # console.log('L89')
      if tmout?
          # console.log(["l41", 'clearing timeout'])
          window.clearTimeout(tmout)

      # console.log('L90')
      imgs = []
      page = 0
      addPics()

    handleEvents = ->
      $('#goButton').click ->
        doStuff()

      $('#searchInput').keypress (e)->
        if e.which == 13
          doStuff()

      $('#hint_links  a').click ->
        $('#searchInput').val(($(this).text().trim()))
        doStuff()

    calculateImageMaxHeight = ->
      mh = Math.floor($(document).height() / 100) * 75
      if mh > 300
        mh -= 30
      mh

    initCarousel = ->
      i = 0
      # console.log('L107')
      searchText = $('#searchInput').val()
      showImageAndStartTimer = ->
        $('#img_container').html('');

        # $('#img_container').append($('<img>').attr('src', imgs[i].src));


        # Crappy crap
        # Make image not overflow
        # $('#img_container').html('');

        $('#img_container').append(
          $('<a>').attr('href', imgs[i].flickrUrl).attr('target', '_blank').append(
            $('<img/>').attr('src', imgs[i].src).attr('style', 'max-height: ' + calculateImageMaxHeight() + 'px;')
          )
        )
        i++;
        if i < imgs.length
          window.tmout = window.setTimeout(showImageAndStartTimer, CAROUSEL_TIMEOUT_MILLISECONDS);
        else
          page++
          imgs = []
          downloadPics(searchText, page)
      showImageAndStartTimer()


    # console.log("L132")
    handleEvents()
    # console.log("L133")
    addPics()

# console.log('L137')
