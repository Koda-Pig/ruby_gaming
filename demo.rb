require 'ruby2d'

set width: 536
set height: 506

Image.new('background.png')

Square.new(
	opacity: 0.5,
	color: '#000000',
	x: 400,
	y: 10,
	size: 50,
)

Circle.new(
	opacity: 0.5,
	color: '#000000',
	x: 20,
	y: 20,
	radius: 80,
)

Triangle.new(
	opacity: 0.5,
	color: '#000000',
	x1: 0,
	x2: 50,
	x3: 0,
	y1: 0,
	y2: 0,
	y3: 50,
)

show