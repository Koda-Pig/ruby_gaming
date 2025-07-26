require 'ruby2d'
require_relative 'constants'
require_relative 'background'
require_relative 'timer'
require_relative 'state'

set title: 'ruby gaming'

set width: $GAME_WIDTH
set height: $GAME_HEIGHT

@state = PlayerState.new('standing_right')

# Timer
@attack_timer = Timer.new(2.0)

def start_attack_timeout
	@attack_timer.start
	@state.can_attack = false
end

def end_attack_timeout
	@attack_timer.reset
	@state.can_attack = true
end

# event handlers
on :key_down do |event|
	case event.key
	when *VALID_KEYS # using the 'splat' operator here to expand the VALID_KEYS array
		@state.pressed_keys << event.key
		@state.last_direction = event.key if ['left', 'right'].include?(event.key)
	when 'escape'
		close
	end
end

on :key_up do |event|
	@state.sprite.stop
	@state.pressed_keys.delete(event.key)
end

# animation loop
update do
	# Roll timer logic
	@attack_timer.update
	end_attack_timeout if @attack_timer.expired?

	# set player state according to user input
	if !@state.is_on_ground?
		if @state.action.start_with?('attack') && !@state.pressed_keys.include?('space')
			start_attack_timeout
			if @state.velocity_y > 0
				@state.fall
			else
				@state.action = "jumping_#{@state.last_direction}"
			end
		elsif @state.pressed_keys.include?('space') && @state.can_attack
			@state.action = "attacking_#{@state.last_direction}"
		elsif @state.velocity_y > 0
			@state.fall
		end
	# all other player states must be entered from on the ground
	elsif @state.is_on_ground?
		if @state.action.start_with?('attacking')
			start_attack_timeout
		end
		if @state.pressed_keys.include?('up') && !@state.pressed_keys.include?('space')
			@state.action = "jumping_#{@state.last_direction}"
		elsif @state.pressed_keys.include?('down')
			@state.action = "sitting_#{@state.last_direction}"
		elsif @state.pressed_keys.include?('right') || @state.pressed_keys.include?('left')
			@state.action = "running_#{@state.last_direction}"
		else
			@state.action = "standing_#{@state.last_direction}"
		end
	end

	# player position
	@state.sprite.y += @state.velocity_y

	if @state.is_on_ground?
		@state.velocity_y = 0
	else
		@state.velocity_y += PLAYER_WEIGHT
	end

	# prevent player falling through floor
	if @state.sprite.y > $GAME_HEIGHT - @state.sprite.height
		@state.sprite.y = $GAME_HEIGHT - @state.sprite.height
	end

	# handle each state
	case @state.action
	when 'standing_right'
		@state.sprite.play(animation: :stand, loop: true)
	when 'standing_left'
		@state.sprite.play(animation: :stand, loop: true, flip: :horizontal)
	when 'running_right'
		@state.sprite.play(animation: :run, loop: true)
		update_background('right')
	when 'running_left'
		@state.sprite.play(animation: :run, loop: true, flip: :horizontal)
		update_background('left')
	when 'jumping_right'
		@state.sprite.play(animation: :jump, loop: true)
		if @state.is_on_ground?
			@state.velocity_y -= 20
		end
		# Only move when user is also holding directional key
		if @state.pressed_keys.include?('right')
			update_background('right')
		end
	when 'jumping_left'
		@state.sprite.play(animation: :jump, loop: true, flip: :horizontal)
		if @state.is_on_ground?
			@state.velocity_y -= 20
		end
		# Only move when user is also holding directional key
		if @state.pressed_keys.include?('left')
			update_background('left')
		end
	when 'sitting_right'
		@state.sprite.play(animation: :sit, loop: true)
	when 'sitting_left'
		@state.sprite.play(animation: :sit, loop: true, flip: :horizontal)
	when 'attacking_right'
		@state.sprite.play(animation: :attack, loop: true)
		update_background('right', ATTACK_ACCELERATION)
	when 'attacking_left'
		@state.sprite.play(animation: :attack, loop: true, flip: :horizontal)
		update_background('left', ATTACK_ACCELERATION)
	when 'falling_right'
		@state.sprite.play(animation: :fall, loop: true)
		# Only move when user is also holding directional key
		if @state.pressed_keys.include?('right')
			update_background('right')
		end
	when 'falling_left'
		@state.sprite.play(animation: :fall, loop: true, flip: :horizontal)
		# Only move when user is also holding directional key
		if @state.pressed_keys.include?('left')
			update_background('left')
		end
	end
end

show