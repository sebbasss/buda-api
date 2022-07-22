class Market < ApplicationRecord
  validates :name, :spread, presence: true
end
