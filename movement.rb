require 'ruby2d'

set width: 536
set height: 506

Image.new('background.png')

triangle = Triangle.new(
	x1: 320, y1: 50,
	x2: 540, y2: 430,
	x3: 100, y3: 430,
	color: ['green', 'red', 'blue']
)

on :key_held do |event|
	puts 'putted #{event}'
end


show