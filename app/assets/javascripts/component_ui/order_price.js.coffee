@OrderPriceUI = flight.component ->
  flight.compose.mixin @, [OrderInputMixin]

  @attributes
    precision: gon.market.bid_precision
    variables:
      input: 'price'
      known: 'volume'
      output: 'total'

  @getLastPrice = ->
    Number gon.ticker.last

  @toggleAlert = (event) ->
    lastPrice = @getLastPrice()

    switch
      when !@value
        @trigger 'place_order::price_alert::hide'
      when @value > (lastPrice)
        @trigger 'place_order::price_alert::show', {label: 'price_high'}
      when @value < (lastPrice)
        @trigger 'place_order::price_alert::show', {label: 'price_low'}
      else
        @trigger 'place_order::price_alert::hide'

  @onOutput = (event, order) ->
    price = order.total.div order.volume
    @$node.val price

  @after 'initialize', ->
    @on 'focusout', @toggleAlert
