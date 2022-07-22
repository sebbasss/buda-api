class Market < ApplicationRecord
  # Adding a basic validation, to confirm the presence of name and spread.
  validates :name, :spread, presence: true
end
