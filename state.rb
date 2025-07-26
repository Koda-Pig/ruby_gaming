require_relative 'constants'

class PlayerState
  attr_accessor :pressed_keys, :action, :can_attack

  def initialize(initial_action)
		@action = initial_action
		@pressed_keys = Set.new
		@can_attack = true
  end
end

