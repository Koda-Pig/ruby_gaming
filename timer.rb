require_relative 'constants'

# In Ruby, ⁠1 / 60 performs integer division and returns ⁠0,
# while ⁠1.0 / 60.0 performs floating-point division, yielding ⁠0.016666666666666666.
# Use floats for accurate decimal results.

class Timer
	attr_accessor :duration, :remaining, :active

	def initialize(duration = 5.0, x = 10, y = 10, radius = 20)
		@duration = duration
		@x = x
		@y = y
		@remaining = duration
		@active = false
		@max_radius = radius
		
		@background_circle = Circle.new(
			x: @x + @max_radius,
			y: @y + @max_radius,
			radius: @max_radius,
			color: '#555555',
		)
		@progress_circle = Circle.new(
			x: @x + @max_radius,
			y: @y + @max_radius,
			radius: @max_radius - 2,
			color: 'green',
		)
	end

	def update
		if @active && @remaining > 0
			@remaining -= 1.0 / 60.0 # Subtract frame time (assuming 60 Fps)
			@progress_circle.color = 'red'

			# Get progress (0 - 1)
			progress = @remaining / @duration

			# Shrink circle based on progress
			@progress_circle.radius = (@max_radius - 2) * progress

		elsif @remaining <= 0 && @active
			@remaining = 0
			@active = false
			reset_visual
		end
	end

	def expired?
		@remaining <= 0
	end

	def start
		@active = true
		if expired? #. reset timer if it was expired
			reset
		end
	end

	def reset
		@remaining = @duration
		@active = false # reset timer but don't start it
		@progress_circle.radius = @max_radius - 2
		@progress_circle.color = 'green'
	end
end