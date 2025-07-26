require_relative 'constants'

class PlayerState
  attr_accessor :pressed_keys
	attr_accessor :action
	attr_accessor :can_attack
	attr_accessor :last_direction
	attr_accessor :velocity_y

  def initialize(initial_action)
		@action = initial_action
		@pressed_keys = Set.new
		@can_attack = true
		@last_direction = 'right'
		@velocity_y = 0
  end

	def fall(direction)
		@action = "falling_#{last_direction}"
	end
end

