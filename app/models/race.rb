class Race < ApplicationRecord
  has_many :characters
  has_many :subraces
end
