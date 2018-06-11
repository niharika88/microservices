#get all orders
get '/list' do
  Order.all.to_json
end

# create a new order and notify invoice service about new order
post '/create' do
  params = JSON.parse request.body.read
  order = Order.new(params)
  if order.save
    # push message to invoice service
    # QueueConnection will publish order to message broker and message contains
    # order details.
    begin
      ForeverAlone.new(params, 30.minutes).ensure
      QueueConnection.queue.publish(params.to_json)
      'Order created'
      ack!
    rescue ForeverAlone::MessageIsNotUnique => ex
      reject!
    end
  end
  else
    status 422
    body params.to_json
  end
end
