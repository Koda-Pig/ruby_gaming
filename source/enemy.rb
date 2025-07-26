require_relative 'constants'

@enemy_width = 160
@enemy_height = 119

class Enemy
	attr_accessor :x

  def initialize(name)
		@name = name
		@sprite = Sprite.new(
			# 960w / 119h
			'assets/images/sprites/enemy_1.png',
			x: $GAME_WIDTH,
			y: $GAME_HEIGHT - @enemy_height,
			width: @enemy_width,
			height: @enemy_height,
			clip_width: @enemy_width,
			clip_height: @enemy_height,
			time: 60,
			animations: {
				crawl: 0..5,
			}
		)
  end

	def update
		@sprite.x -= 1
	end
end
