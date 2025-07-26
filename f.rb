require 'ruby2d'
require_relative 'source/constants'
require_relative 'source/state'
require_relative 'source/enemy'

set title: 'ruby gaming'
set width: $GAME_WIDTH
set height: $GAME_HEIGHT

@player = PlayerState.new('standing_right')
@enemy = Enemy.new('robert')

def centered(position, size)
	position + size * 0.5
end

def is_colliding?(sprite_a, sprite_b)
	# check if radius's overlap
	# calculate the distance between their centers and compare it to the sum of their radii
	centered_a_x = centered(sprite_a.x, sprite_a.width)
	centered_b_x = centered(sprite_b.x, sprite_b.width)
	centered_a_y = centered(sprite_a.y, sprite_a.height)
	centered_b_y = centered(sprite_b.y, sprite_b.height)
	radii_a = [sprite_a.width, sprite_a.height].max * 0.5
	radii_b = [sprite_b.width, sprite_b.height].max * 0.5

	dist_between_centers = (centered_a_x - centered_b_x).abs + (centered_a_y - centered_b_y).abs
	sum_of_radii = radii_a + radii_b

	return sum_of_radii > dist_between_centers
end

# event handlers
on :key_down do |event|
	case event.key
	when *VALID_KEYS # using the 'splat' operator here to expand the VALID_KEYS array
		@player.pressed_keys << event.key
		@player.last_direction = event.key if ['left', 'right'].include?(event.key)
	when 'escape'
		close
	end
end

on :key_up do |event|
	@player.sprite.stop
	@player.pressed_keys.delete(event.key)
end

# animation loop
update do
	@player.update
	@enemy.update(@player.current_moving_direction)
	is_colliding?(@player.sprite, @enemy.sprite)
end

show