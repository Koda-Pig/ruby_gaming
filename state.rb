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
		@attack_timer = Timer.new(2.0)
  end

	def fall
		@action = "falling_#{@last_direction}"
	end
	def jump
		@action = "jumping_#{@last_direction}"
	end
	def attack
		@action = "attacking_#{@last_direction}"
	end
	def sit
		@action = "sitting_#{@last_direction}"
	end
	def run
		@action = "running_#{@last_direction}"
	end
	def stand
		@action = "standing_#{@last_direction}"
	end

	def start_attack_timeout
		@attack_timer.start
		@can_attack = false
	end

	def end_attack_timeout
		@attack_timer.reset
		@can_attack = true
	end
	
	def is_on_ground?
    @sprite.y >= $GAME_HEIGHT - @sprite.height
  end

	def is_below_floor?
		@sprite.y > $GAME_HEIGHT - @sprite.height
	end

	def update
		# Roll timer logic
		end_attack_timeout if @attack_timer.expired?
		@attack_timer.update

		# player position
		@sprite.y += @velocity_y

		if is_on_ground?
			@velocity_y = 0
		else
			@velocity_y += PLAYER_WEIGHT
		end

		if is_below_floor?
			@sprite.y = $GAME_HEIGHT - @sprite.height
		end

			# handle each state
		case @.action
		when 'standing_right'
			sprite.play(animation: :stand, loop: true)
		when 'standing_left'
			sprite.play(animation: :stand, loop: true, flip: :horizontal)
		when 'running_right'
			sprite.play(animation: :run, loop: true)
			update_background('right')
		when 'running_left'
			sprite.play(animation: :run, loop: true, flip: :horizontal)
			update_background('left')
		when 'jumping_right'
			sprite.play(animation: :jump, loop: true)
			if is_on_ground?
				velocity_y -= 20
			end
			# Only move when user is also holding directional key
			if pressed_keys.include?('right')
				update_background('right')
			end
		when 'jumping_left'
			sprite.play(animation: :jump, loop: true, flip: :horizontal)
			if is_on_ground?
				velocity_y -= 20
			end
			# Only move when user is also holding directional key
			if pressed_keys.include?('left')
				update_background('left')
			end
		when 'sitting_right'
			sprite.play(animation: :sit, loop: true)
		when 'sitting_left'
			sprite.play(animation: :sit, loop: true, flip: :horizontal)
		when 'attacking_right'
			sprite.play(animation: :attack, loop: true)
			update_background('right', ATTACK_ACCELERATION)
		when 'attacking_left'
			sprite.play(animation: :attack, loop: true, flip: :horizontal)
			update_background('left', ATTACK_ACCELERATION)
		when 'falling_right'
			sprite.play(animation: :fall, loop: true)
			# Only move when user is also holding directional key
			if pressed_keys.include?('right')
				update_background('right')
			end
		when 'falling_left'
			sprite.play(animation: :fall, loop: true, flip: :horizontal)
			# Only move when user is also holding directional key
			if pressed_keys.include?('left')
				update_background('left')
			end
		end

		if !is_on_ground?
			if @action.start_with?('attack') && !@pressed_keys.include?('space')
				start_attack_timeout
				if @velocity_y > 0
					fall
				else
					jump
				end
			elsif @pressed_keys.include?('space') && @can_attack
				attack
			elsif @velocity_y > 0
				fall
			end
		# all other player states must be entered from on the ground
		elsif is_on_ground?
			if @action.start_with?('attacking')
				start_attack_timeout
			end
			if @pressed_keys.include?('up') && !@pressed_keys.include?('space')
				jump
			elsif @pressed_keys.include?('down')
				sit
			elsif @pressed_keys.include?('right') || @pressed_keys.include?('left')
				run
			else
				stand
			end
		end
	end
end

