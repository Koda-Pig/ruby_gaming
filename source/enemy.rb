require_relative 'constants'

class Enemy
	attr_accessor :x
	attr_accessor :sprite

  def initialize(name)
		@name = name
		@enemy_width = 160
		@enemy_height = 119
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
		@circle = Circle.new(
			x: @sprite.x + @sprite.width * 0.5,
			y: @sprite.y + @sprite.height * 0.5,
			radius: @sprite.width * 0.5,
			opacity: 0.5
		)
		@sprite.play(animation: :crawl, loop: true)
  end

	def update(player_movement_direction)
		case player_movement_direction
		when 'left'
			@sprite.x += PLAYER_SPEED
			@circle.x += PLAYER_SPEED
		when 'right'
			@sprite.x -= PLAYER_SPEED + ENEMY_SPEED
			@circle.x -= PLAYER_SPEED + ENEMY_SPEED
		when nil
			@sprite.x -= ENEMY_SPEED
			@circle.x -= ENEMY_SPEED
		end
	end
end
