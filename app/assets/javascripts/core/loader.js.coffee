plague.loader =

    loaded: false

    isSupported: ->
      plague.support.history() and plague.support.localStore()

    start: ->
      return unless @isSupported()
      $(window).bind 'load', ->
        after '0.5s', -> plague.loader._load()

    ready: (callback) ->
      if @loaded
        callback()
      else
        @_readyCallbacks.push(callback)

    openUrl: (url, data) ->
      history.pushState({ }, '', url)
      plague.loader._openPage(location.pathname, data)

    _lastUrl: null

    _readyCallbacks: []

    _load: ->
      return if @loaded

      $.get '/posts', (html) =>
        plague.loader.loaded = true

        current = $('.page-content')
        before  = $('<div class="loaded-before" />')
        after   = $('<div class="loaded-after" />')

        beforeCurrent = true
        for page in $(html).filter('.page-content')
          if beforeCurrent
            if $(page).data('url') != current.data('url')
              before.append(page)
            else
              beforeCurrent = false
          else
            after.append(page)

        beforeScroll = $(window).scrollTop()
        before = plague.enliven(before.children().insertBefore(current))
        after  = plague.enliven(after.children().insertAfter(current))

        if current.is('.title-page')
          $('.post-page').hide()
        else
          $('.title-page, .post-page .next-post').hide()
          height = 0
          for el in before.filter(':not(.title-page)')
            height += $(el).outerHeight()
          $(window).scrollTop(beforeScroll + height)

        @_watchUrl()

        for callack in @_readyCallbacks
          callack()
        @_readyCallbacks = []

    _watchUrl: ->
      @_lastUrl = location.pathname

      $(window).bind 'popstate', =>
        plague.loader._openPage(location.pathname)

      $('a').live 'click', ->
        href = $(@).attr('href')
        plague.loader.openUrl(href) if href[0] == '/'
        false

    _openPage: (url, data) ->
      return if url == @_lastUrl
      @_lastUrl = url

      page = $(".page-content[data-url='#{url}']")
      if page.length
        plague.animation.wait ->
          page.trigger('show-page', data)
      else
        location.href = url
