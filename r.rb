require 'ruby2d'

pressed_keys = Set.new
player_state = nil
canvas_width = 536
canvas_height = 506
player_width = 200
player_height = 182
last_direction = 'right'
velocity_y = 0
weight = 1

set width: canvas_width
set height: canvas_height

# Image dimensions: 8400 × 182
# Sprite frame dimensions: 200x182
# 16800 / 200 = 84 columns
# All animations in this sprite sheet point right
# use the 'flip' property for left pointing animations
@player = Sprite.new(
	'dog_sprite_horiz.png',
	x: canvas_width / 2 - player_width / 2,
	y: player_height * -1, # make him drop from the top for fun
	width: player_width,
	height: player_height,
	clip_width: player_width,
	clip_height: player_height,
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
	when 'esc'
		close
	end
end

on :key_up do |event|
	@player.stop
	pressed_keys.delete(event.key)
end

# animation loop
update do
	is_on_ground = @player.y >= canvas_height - @player.height

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
		velocity_y += weight
	end

	# prevent player falling through floor
	if @player.y > canvas_height - @player.height
		@player.y = canvas_height - @player.height
	end

	# handle each state
	case player_state
	when 'standing_right'
		@player.play(animation: :stand, loop: true)
	when 'standing_left'
		@player.play(animation: :stand, loop: true, flip: :horizontal)
	when 'running_right'
		@player.play(animation: :run, loop: true)
	when 'running_left'
		@player.play(animation: :run, loop: true, flip: :horizontal)
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