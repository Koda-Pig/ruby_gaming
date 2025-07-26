require_relative 'constants'

class PlayerState
  attr_accessor :pressed_keys
	attr_accessor :action
	attr_accessor :can_attack
	attr_accessor :last_direction
	attr_accessor :velocity_y
	attr_accessor :sprite


  def initialize(initial_action)
		@action = initial_action
		@sprite = Sprite.new(
			'dog_sprite_horiz.png',
			x: $GAME_WIDTH / 2 - PLAYER_WIDTH / 2,
			y: PLAYER_HEIGHT * -1, # make him drop from the top for fun
			width: PLAYER_WIDTH,
			height: PLAYER_HEIGHT,
			clip_width: PLAYER_WIDTH,
			clip_height: PLAYER_HEIGHT,
			time: 60,
			animations: {
				stand: 0..6,
				jump: 7..13,
				fall: 14..20,
				run: 21..29,
				sit: 30..34,
				attack: 35..41,
			}
		)
		@pressed_keys = Set.new
		@can_attack = true
		@last_direction = 'right'
		@velocity_y = 0
  end

	def fall(direction)
		@action = "falling_#{last_direction}"
	end
end

