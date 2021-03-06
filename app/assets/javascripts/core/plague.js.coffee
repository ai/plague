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
      plague.scroll.unwatch()

    end: ->
      @animating = false
      plague.scroll.watch()
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
