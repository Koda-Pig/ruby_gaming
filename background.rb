require_relative 'constants'

BG_LAYERS_COUNT = 7

class BackgroundLayer
  # Makes these properties on the class readable + writable
  attr_accessor :images, :speed_multiplier

  def initialize(image_path, layer_index)
    @speed_multiplier = layer_index * 0.5
    @images = []

    # First image starts at x = -$GAME_WIDTH (off-screen to the left)
    @images << Image.new(
      image_path,
      x: -$GAME_WIDTH, y: 0,
      width: $GAME_WIDTH, height: $GAME_HEIGHT
    )

    # Second starts at x = 0 (visible on screen)
    @images << Image.new(
      image_path,
      x: 0, y: 0,
      width: $GAME_WIDTH, height: $GAME_HEIGHT
    )
  end

  def update(direction, base_speed)
    movement = base_speed * @speed_multiplier

    @images.each do |image|
      if direction == 'forward'
        image.x -= movement
      elsif direction == 'backward'
        image.x += movement
      else
        puts "invalid direction #{direction}. Must be 'forward' or 'backward'"
      end

      # Wrap around / tiling logic
      # If image has moved off completely to left side
      if image.x + $GAME_WIDTH < 0
        # Find the rightmost image and position this one after it
        image.x += 2 * $GAME_WIDTH
      end
      # if image has moved off completely to right side
      if image.x > $GAME_WIDTH
        # find leftmost image and position this one before it
        image.x -= 2 * $GAME_WIDTH
      end
    end
  end
end

@bg_layers = []
BG_LAYERS_COUNT.times do |i|
  @bg_layers << BackgroundLayer.new("backgrounds/layers/layer_#{i}.webp", i)
end

def update_background(direction)
  @bg_layers.each do |layer|
    layer.update(direction, PLAYER_SPEED)
  end
end