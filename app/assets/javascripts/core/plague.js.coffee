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

   initBodyClasses: ->
    classes  = 'js '
    classes += if plague.support.transform3d()
      ' transform3d'
    else
      ' transform2d'
    $('body').removeClass('no-js').addClass(classes)

  storage: (key, value) ->
    if typeof(key) == 'object'
      for name, value of key
        plague.storage(name, value)
    else
      if value == undefined
        if plague.support.localStore()
          localStorage.getItem(key)
        else
          $.cookie(key)
      else
        if plague.support.localStore()
          if value == null
            localStorage.removeItem(key)
          else
            localStorage.setItem(key, value)

  support:

    history: ->
      !!(window.history and history.pushState)

    localStore: ->
      try
        !!localStorage.getItem
      catch error
        false

    _transform3d: ->
      return false unless window.matchMedia?
      result = matchMedia("all and (transform-3d)")
      return true if result.matches
      matchMedia("all and (-#{plague.ext.prefix()}-transform-3d)").matches

    transform3d: ->
      @transform3dCache ||= @_transform3d()
