require_relative 'constants'

class HealthBar
	attr_accessor :health

  def initialize
		@health = 100
		@base_width = 200
		@background = Rectangle.new(
			x: 20,
			y: 60,
			width: @base_width,
			height: 20,
			color: '#333333',
			opacity: 0.5
		)
		@indicator = Rectangle.new(
			x: 22,
			y: 62,
			width: @base_width - 4,
			height: 16,
			color: '#00ff00'
		)
  end


	def damage(amount)
		@health = [[@health - amount, 100].min, 0].max
		@indicator.width = @base_width * (@health * 0.01);
	end
end
