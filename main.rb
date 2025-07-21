require 'ruby2d'

set width: 536
set height: 506

pressed_keys = []

# Image dimensions: 8400 × 182
# Sprite frame dimensions: 200x182
# 16800 / 200 = 84 columns
# All animations in this sprite sheet point right
# use the 'flip' property for left pointing animations
sprite = Sprite.new(
	'dog_sprite_horiz.png',
	x: 100,
	y: 100,
	width: 200,
	height: 182,
	clip_width: 200,
	clip_height: 182,
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

on :key_held do |event|
	case event.key
	when 'up'
		sprite.y -= 5
		sprite.play(animation: :jump)
		pressed_keys << 'up' 
		puts pressed_keys
	when 'right'
		sprite.x += 5
		sprite.play(animation: :run)
	when 'down'
		sprite.y += 5
		sprite.play(animation: :sit)
	when 'left'
		sprite.x -= 5
		sprite.play(animation: :run, flip: :horizontal)
	end
end

# on :key_up do
# 	sprite.stop
# end

show