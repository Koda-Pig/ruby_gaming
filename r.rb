require 'ruby2d'
require_relative 'constants'
require_relative 'background'
require_relative 'timer'

set title: 'ruby gaming'

pressed_keys = Set.new
@player_state = 'standing_right'
last_direction = 'right'
@player_can_attack = true
velocity_y = 0

set width: $GAME_WIDTH
set height: $GAME_HEIGHT

# Image dimensions: 8400 × 182
# Sprite frame dimensions: 200x182
# 16800 / 200 = 84 columns
# All animations in this sprite sheet point right
# use the 'flip' property for left pointing animations
@player = Sprite.new(
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

# Timer
@attack_timer = Timer.new(2.0)

def reset_attack
	if @player_state.start_with?('attack')
		@attack_timer.start
		@player_can_attack = false
	end
end

# event handlers
on :key_down do |event|
	case event.key
	when 'up'
		pressed_keys << 'up' 
	when 'right'
		pressed_keys << 'right'
		last_direction = 'right'
	when 'down'
		pressed_keys << 'down'
	when 'left'
		pressed_keys << 'left'
		last_direction = 'left'
	when 'space'
		pressed_keys << 'space'
	# close the window
	when 'escape'
		close
	end
end

on :key_up do |event|
	@player.stop
	pressed_keys.delete(event.key)
	# Disable attacking and start the countdown timer once player
	# stops attacking (releases the space key)
	if event.key == 'space'
		reset_attack
	end
end

# animation loop
update do
	is_on_ground = @player.y >= $GAME_HEIGHT - @player.height

	# Roll timer logic
	@attack_timer.update

	if @attack_timer.expired?
		@player_can_attack = true
		@attack_timer.reset
	end

	# set player state according to user input
	if !is_on_ground
		if @player_state.start_with?('attack') && !pressed_keys.include?('space')
			if velocity_y > 0
				@player_state = "falling_#{last_direction}"
			else
				@player_state = "jumping_#{last_direction}"
			end
		elsif velocity_y > 0
			@player_state = "falling_#{last_direction}"
		elsif pressed_keys.include?('space') && @player_can_attack
			@player_state = "attacking_#{last_direction}"
		end
	# all other player states must be entered from on the ground
	elsif is_on_ground
		if pressed_keys.include?('up') && !pressed_keys.include?('space')
			@player_state = "jumping_#{last_direction}"
		elsif pressed_keys.include?('down')
			@player_state = "sitting_#{last_direction}"
		elsif pressed_keys.include?('right') || pressed_keys.include?('left')
			@player_state = "running_#{last_direction}"
		else
			@player_state = "standing_#{last_direction}"
		end
	end

	# player position
	@player.y += velocity_y

	if is_on_ground
		velocity_y = 0
	else
		velocity_y += PLAYER_WEIGHT
	end

	# prevent player falling through floor
	if @player.y > $GAME_HEIGHT - @player.height
		@player.y = $GAME_HEIGHT - @player.height
	end

	# handle each state
	case @player_state
	when 'standing_right'
		@player.play(animation: :stand, loop: true)
	when 'standing_left'
		@player.play(animation: :stand, loop: true, flip: :horizontal)
	when 'running_right'
		@player.play(animation: :run, loop: true)
		update_background('right')
	when 'running_left'
		@player.play(animation: :run, loop: true, flip: :horizontal)
		update_background('left')
	when 'jumping_right'
		@player.play(animation: :jump, loop: true)
		if is_on_ground
			velocity_y -= 20
		end
		# Only move when user is also holding directional key
		if pressed_keys.include?('right')
			update_background('right')
		end
	when 'jumping_left'
		@player.play(animation: :jump, loop: true, flip: :horizontal)
		if is_on_ground
			velocity_y -= 20
		end
		# Only move when user is also holding directional key
		if pressed_keys.include?('left')
			update_background('left')
		end
	when 'sitting_right'
		@player.play(animation: :sit, loop: true)
	when 'sitting_left'
		@player.play(animation: :sit, loop: true, flip: :horizontal)
	when 'attacking_right'
		@player.play(animation: :attack, loop: true)
		update_background('right', ATTACK_ACCELERATION)
	when 'attacking_left'
		@player.play(animation: :attack, loop: true, flip: :horizontal)
		update_background('left', ATTACK_ACCELERATION)
	when 'falling_right'
		@player.play(animation: :fall, loop: true)
		# Only move when user is also holding directional key
		if pressed_keys.include?('right')
			update_background('right')
		end
	when 'falling_left'
		@player.play(animation: :fall, loop: true, flip: :horizontal)
		# Only move when user is also holding directional key
		if pressed_keys.include?('left')
			update_background('left')
		end
	end
end

show