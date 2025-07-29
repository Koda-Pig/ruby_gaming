require_relative 'constants'

BG_LAYERS_COUNT = 8
# 2 images per layer so that they can be tiled one after the other
BG_IMAGES_PER_LAYER = 2

class BackgroundLayer
  # Makes these properties on the class readable + writable
  attr_accessor :images, :speed_multiplier

  def initialize(image_path, layer_index)
    @images = []
    @is_last = layer_index == BG_LAYERS_COUNT - 1
    if @is_last
      @speed_multiplier = 1 # last layer (in foreground) has base speed rate
    else
      @speed_multiplier = layer_index * 0.01
    end

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

  def swap(image, side)
    if side == 'left'
      image.x += BG_IMAGES_PER_LAYER * $GAME_WIDTH
    elsif side == 'right'
      image.x -= BG_IMAGES_PER_LAYER * $GAME_WIDTH
    end
  end

  def update(direction, base_speed)
    movement = base_speed * @speed_multiplier

    @images.each do |image|
      if direction == 'right'
        image.x -= movement
      elsif direction == 'left'
        image.x += movement
      else
        raise ArgumentError, "invalid direction #{direction}. Must be 'right' or 'left'"
      end

      # Wrap around / tiling logic
      off_screen_left = image.x + $GAME_WIDTH < 0
      off_screen_right = image.x > $GAME_WIDTH
      swap(image, 'left') if off_screen_left
      swap(image, 'right') if off_screen_right
    end
  end
end