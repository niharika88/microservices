require 'sneakers'
require 'json'

require_relative '../model/invoice'
require_relative '../queue/queue_connection'

Mongoid.load!('mongoid.config', 'development')

class OrderWorker
  include Sneakers::Worker
  from_queue 'orders'

  def work(message)
  	begin
      
    if invoice_created?
    	ForeverAlone.new(invoice, 30.minutes).ensure
      puts "#{ invoice.id } created"
      QueueConnection.publish(invoice.to_json)
      puts "#{ invoice } published"
    else
      puts "#{ invoice } couldn't be created"
    end

    ack!
    rescue ForeverAlone::MessageIsNotUnique => ex
      reject!
    end
  end
  end

  def invoice_created?(invoice)
    invoice = JSON.parse(message)
    invoice['status'] = true
    invoice = Invoice.new(invoice)
    result   = invoice.save
  end

end