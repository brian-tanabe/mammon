class Transaction < ApplicationRecord
	belongs_to :user
	belongs_to :source

	enum transaction_type: [:sale, :return, :payment, :fee, :adjustment]
end
