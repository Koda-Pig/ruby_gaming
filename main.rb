require 'ruby2d'

pressed_keys = Set.new
canvas_width = 536
canvas_height = 506
sprite_width = 200
sprite_height = 182

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

sprite.play(animation: :stand, loop: true)

on :key_down do |event|
	case event.key
	when 'up'
		# sprite.y -= 5
		sprite.play(animation: :jump, loop: true)
		pressed_keys << 'up' 
	when 'right'
		# sprite.x += 5
		sprite.play(animation: :run, loop: true)
		pressed_keys << 'right'
	when 'down'
		# sprite.y += 5
		sprite.play(animation: :sit, loop: true)
		pressed_keys << 'down'
	when 'left'
		# sprite.x -= 5
		sprite.play(animation: :run, flip: :horizontal, loop: true)
		pressed_keys << 'left'
	when 'space'
		# sprite.x -= 5
		sprite.play(animation: :roll, loop: true)
		pressed_keys << 'space'
	end
end

on :key_up do |event|
	sprite.stop
	sprite.play(animation: :stand, loop: true)
	pressed_keys.delete(event.key)
end

show