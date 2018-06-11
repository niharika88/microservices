require 'mongoid'

class Invoice
  include Mongoid::Document

  field :product_name, type: String
  field :owner, type: String
  field :quantity, type: Integer
  field :status, type: Boolean

  validates :product_name, presence: true
  validates :owner, presence: true
  validates :status, presence: true

  index({ product_name: 'text' })
end