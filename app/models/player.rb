class Player < ApplicationRecord
	validates :email, uniqueness: true
end
