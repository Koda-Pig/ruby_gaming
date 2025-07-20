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
	x1: 320, y1: 50,
	x2: 540, y2: 430,
	x3: 100, y3: 430,
	color: ['green', 'red', 'blue']
)


show