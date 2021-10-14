class Player < ApplicationRecord
	validates :email, uniqueness: true, presence: true

	before_create :set_rank

	private

	def set_rank
		lowest_rank = Player.order(current_rank: :desc).first&.current_rank
		if lowest_rank
			self.current_rank = lowest_rank + 1
		end
	end
end
