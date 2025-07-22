require 'ruby2d'

pressed_keys = Set.new
player_state = nil
canvas_width = 536
canvas_height = 506
sprite_width = 200
sprite_height = 182
last_direction = 'right'

set width: canvas_width
set height: canvas_height

# Image dimensions: 8400 × 182
# Sprite frame dimensions: 200x182
# 16800 / 200 = 84 columns
# All animations in this sprite sheet point right
# use the 'flip' property for left pointing animations
sprite = Sprite.new(
	'dog_sprite_horiz.png',
	x: canvas_width / 2 - sprite_width / 2,
	y: canvas_height / 2 - sprite_height / 2,
	width: sprite_width,
	height: sprite_height,
	clip_width: sprite_width,
	clip_height: sprite_height,
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
	end
end

on :key_up do |event|
	sprite.stop
	pressed_keys.delete(event.key)
end


update do
	if pressed_keys.include?('up')
		if last_direction == 'right'
			player_state = 'jumping_right'
		else
			player_state = 'jumping_left'
		end
	elsif pressed_keys.include?('space')
		if last_direction == 'right'
			player_state = 'rolling_right'
		else
			player_state = 'rolling_left'
		end
	elsif pressed_keys.include?('down')
		if last_direction == 'right'
			player_state = 'sitting_right'
		else
			player_state = 'sitting_left'
		end
	elsif pressed_keys.include?('right')
		player_state = 'running_right'
	elsif pressed_keys.include?('left')
		player_state = 'running_left'
	elsif last_direction == 'right'
		player_state = 'standing_right'
	else
		player_state = 'standing_left'
	end

	case player_state
	when 'standing_right'
		sprite.play(animation: :stand, loop: true)
	when 'standing_left'
		sprite.play(animation: :stand, loop: true, flip: :horizontal)
	when 'running_right'
		sprite.play(animation: :run, loop: true)
	when 'running_left'
		sprite.play(animation: :run, loop: true, flip: :horizontal)
	when 'jumping_right'
		sprite.play(animation: :jump, loop: true)
	when 'jumping_left'
		sprite.play(animation: :jump, loop: true, flip: :horizontal)
	when 'sitting_right'
		sprite.play(animation: :sit, loop: true)
	when 'sitting_left'
		sprite.play(animation: :sit, loop: true, flip: :horizontal)
	when 'rolling_right'
		sprite.play(animation: :roll, loop: true)
	when 'rolling_left'
		sprite.play(animation: :roll, loop: true, flip: :horizontal)
	end
end


show