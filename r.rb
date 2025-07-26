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

	@state.update

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