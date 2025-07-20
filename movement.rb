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
# 1626 × 194 || 6 frames
# 271
sprite = Sprite.new(
	'pig.png',
	x: 100,
	y: 100,
	clip_width: 271,
	animations: { fly: 1..6 }
)
Text.new(
	'rooooooo',
	x: 100,
	y: 10,
	size: 42,
	color: 'teal'
)
sound = Sound.new('blip.wav')
music = Sound.new('bg-moo.mp3', loop: true)
music.play

on :key_held do |event|
	sprite.play(animation: :fly)
	case event.key
	when 'up'
		sprite.y -= 1
	when 'right'
		sprite.x += 1
	when 'down'
		sprite.y += 1
	when 'left'
		sprite.x -= 1
	end
end

on :key_up do
	sprite.stop
end
show