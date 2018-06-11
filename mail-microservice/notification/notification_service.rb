class NotificationService

  def self.notify(invoice)
  	UserNotifier.send_invoice_email(invoice.user_id).deliver
    puts "#{invoice} notified to client"
  end
end