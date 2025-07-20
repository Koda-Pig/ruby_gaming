require 'ruby2d'

set width: 536
set height: 506

Image.new('background.png')

circle = Circle.new(
	opacity: 0.5,
	color: '#000000',
	x: 20,
	y: 20,
	radius: 80,
)

sprite = Sprite.new(
	'pig.png',
	x: 100,
	y: 100,
	clip_width: 60,
	animations: { fly: 1..3 }
)

on :key_held do |event|
	case event.key
	when 'up'
		sprite.y -= 1
	when 'right'
		sprite.x += 1
	when 'down'
		sprite.y += 1
	when 'left'
		sprinte.x -= 1
	end
end


show