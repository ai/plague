#= require jquery.role
#= require jquery.easing

vitality = (root, selector, callback) ->
  content = $(selector, root)
  content = content.add(root.filter(selector))

  if content.length
    $$ = (selector) -> $(selector, content)
    for i in content
      el = $(i)
      callback.apply(el, [$, $$, el])

window.plague =

  _vitalities: [],

  on: (selector, callback) ->
    $(document).ready -> vitality($('body'), selector, callback)

  _alive: false

  live: (selector, callback) ->
    @_vitalities.push([selector, callback])
    @on(selector, callback)

  enliven: (root) ->
    for [selector, callback] in @_vitalities
      vitality(root, selector, callback)
    root

  title: (titles...) ->
    titles.push('Инсомнис')
    document.title = titles.join(' — ')

  animating: false

  animationWaiters: []

  animationStart: ->
    @animating = true

  animation:

    animating: false

    _waiters: []

    start: ->
      @animating = true

    end: ->
      @animating = false
      while waiter = @_waiters.pop()
        waiter()

    wait: (callback) ->
      if @animating
        @_waiters.push(callback)
      else
        callback()

  support:

    history: ->
      !!(window.history and history.pushState)

    localStore: ->
      try
        !!localStorage.getItem
      catch error
        false
