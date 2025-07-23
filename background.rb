require_relative 'constants'

image_props = {
  x: 0, y: 0,
  width: $GAME_WIDTH, height: $GAME_HEIGHT
}

@bg_layer_0 = Image.new(
	'backgrounds/layers/layer_0.webp',
  **image_props 
)
@bg_layer_1 = Image.new(
	'backgrounds/layers/layer_1.webp',
  **image_props 
)
@bg_layer_2 = Image.new(
	'backgrounds/layers/layer_2.webp',
  **image_props 
)
@bg_layer_3 = Image.new(
	'backgrounds/layers/layer_3.webp',
  **image_props 
)
@bg_layer_4 = Image.new(
	'backgrounds/layers/layer_4.webp',
  **image_props 
)
@bg_layer_5 = Image.new(
	'backgrounds/layers/layer_5.webp',
  **image_props 
)
@bg_layer_6 = Image.new(
	'backgrounds/layers/layer_6.webp',
  **image_props 
)


def update_background(time)
  puts "Updating background at #{time}"
end