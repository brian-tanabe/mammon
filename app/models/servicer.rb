class Servicer < ApplicationRecord
  belongs_to :source_type
  belongs_to :user
end
