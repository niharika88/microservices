require 'sneakers'
require 'json'

require_relative '../notification/notification_service'


class InvoiceMailWorker
  include Sneakers::Worker
  from_queue 'invoice'

  def work(message)
    invoice = JSON.parse(message)

    begin
    ForeverAlone.new(invoice, 30.minutes).ensure
    NotificationService.notify(invoice)
    ack!
    rescue ForeverAlone::MessageIsNotUnique => ex
      reject!
    end
  end
  end
end