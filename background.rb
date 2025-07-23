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

@bg_layers = [
  @bg_layer_0,
  @bg_layer_1,
  @bg_layer_2,
  @bg_layer_3,
  @bg_layer_4,
  @bg_layer_5,
  @bg_layer_6,
]

def update_background(direction)
  @bg_layers.each_with_index do |layer, index|
    movement_speed = index * 0.05 # speed increases for each layer for parallax effect
    if direction == 'forward'
      layer.x -= PLAYER_SPEED
    elsif direction == 'backward'
      layer.x += PLAYER_SPEED
    else
      puts "invalid direction #{direction}. Must be 'forward' or 'backward'"
    end
  end
end