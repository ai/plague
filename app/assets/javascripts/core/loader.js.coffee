plague.loader =

    loaded: false

    loading: false

    isSupported: ->
      plague.support.history() and plague.support.localStore()

    start: ->
      return unless @isSupported()

      return if @loading
      @loading = true

      $(window).on 'load', ->
        after '0.5s', -> plague.loader._load()

    ready: (callback) ->
      @_readyCallbacks.add(callback)

    openUrl: (url, data) ->
      history.pushState({ }, '', url)
      plague.loader._openPage(location.pathname, data)

    _lastUrl: null

    _readyCallbacks: jQuery.Callbacks('once memory')

    _load: ->
      return if @loaded

      $.get '/posts', (html) =>
        plague.loader.loaded = true

        current = $('article.page')
        before  = $('<div class="loaded-before" />')
        after   = $('<div class="loaded-after" />')

        beforeCurrent = true
        for page in $(html).filter('article.page')
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

        $('body').addClass('all-posts')
        @_watchUrl()

        @_readyCallbacks.fire()

    _watchUrl: ->
      @_lastUrl = location.pathname

      $(window).on 'popstate', =>
        plague.loader._openPage(location.pathname)

      $(document).on 'click', 'a', ->
        href = $(@).attr('href')
        if href[0] == '/' and not href.match('#')
          plague.loader.openUrl(href)
          false

    _openPage: (url, data) ->
      return if url == @_lastUrl
      @_lastUrl = url

      page = $("article[data-url='#{url}']")
      if page.length
        plague.animation.wait ->
          page.trigger('show-page', data)
      else
        location.href = url
