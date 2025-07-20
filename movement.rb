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

on :key_held do |event|
	case event.key
	when 'up'
		circle.y -= 1
	when 'right'
		circle.x += 1
	when 'down'
		circle.y += 1
	when 'left'
		circle.x -= 1
	end
end


show