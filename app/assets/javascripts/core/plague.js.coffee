#= require jquery.role
#= require jquery.easing
#= require jquery.cookie

vitality = (root, selector, callback) ->
  content = $(selector, root)
  content = content.add(root.filter(selector))

  if content.length
    for i in content
      do ->
        $$ = (selector) -> $(selector, i)
        el = $(i)
        callback.apply(el, [$, $$, el])

window.plague =

  _vitalities: []

  _alive: false

  data: { }

  on: (selector, callback) ->
    $(document).ready -> vitality($('body'), selector, callback)

  live: (selector, callback) ->
    @_vitalities.push([selector, callback])
    @on(selector, callback)

  enliven: (root) ->
    for [selector, callback] in @_vitalities
      vitality(root, selector, callback)
    root

  documentTitle: (titles...) ->
    titles.push('Инсомнис')
    document.title = titles.join(' — ')

  clearDocumentTitle: ->
    @documentTitle()

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
    classes += 'transform' + if plague.support.transform3d() then '3d' else '2d'
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
        else
          $.cookie(key, value, expires: 365, path: '/')
