require 'ruby2d'
require_relative 'constants'
require_relative 'background'

set title: 'ruby gaming'

pressed_keys = Set.new
player_state = nil
last_direction = 'right'
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
		roll: 35..41,
	}
)

# initial player state
player_state = 'standing_right'

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
end

def move_bg(bg)
	puts bg
end

# animation loop
update do
	is_on_ground = @player.y >= $GAME_HEIGHT - @player.height

	# set player state according to user input
	if pressed_keys.include?('space')
		player_state = "rolling_#{last_direction}"
	elsif velocity_y > 0
		player_state = "falling_#{last_direction}"
	elsif is_on_ground
		if pressed_keys.include?('up')
			player_state = "jumping_#{last_direction}"
		elsif pressed_keys.include?('down')
			player_state = "sitting_#{last_direction}"
		elsif pressed_keys.include?('right')
			player_state = 'running_right'
		elsif pressed_keys.include?('left')
			player_state = 'running_left'
		else
			player_state = "standing_#{last_direction}"
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
	case player_state
	when 'standing_right'
		@player.play(animation: :stand, loop: true)
	when 'standing_left'
		@player.play(animation: :stand, loop: true, flip: :horizontal)
	when 'running_right'
		@player.play(animation: :run, loop: true)
		update_background('forward')
	when 'running_left'
		@player.play(animation: :run, loop: true, flip: :horizontal)
		update_background('backward')
	when 'jumping_right'
		@player.play(animation: :jump, loop: true)
		if is_on_ground
			velocity_y -= 20
		end
	when 'jumping_left'
		@player.play(animation: :jump, loop: true, flip: :horizontal)
		if is_on_ground
			velocity_y -= 20
		end
	when 'sitting_right'
		@player.play(animation: :sit, loop: true)
	when 'sitting_left'
		@player.play(animation: :sit, loop: true, flip: :horizontal)
	when 'rolling_right'
		@player.play(animation: :roll, loop: true)
	when 'rolling_left'
		@player.play(animation: :roll, loop: true, flip: :horizontal)
	when 'falling_right'
		@player.play(animation: :fall, loop: true)
	when 'falling_left'
		@player.play(animation: :fall, loop: true, flip: :horizontal)
	end
end

show