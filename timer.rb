require_relative 'constants'

# In Ruby, ⁠1 / 60 performs integer division and returns ⁠0,
# while ⁠1.0 / 60.0 performs floating-point division, yielding ⁠0.016666666666666666.
# Use floats for accurate decimal results.

class Timer
	attr_accessor :duration, :remaining, :active

	def initialize(duration = 5.0, x = 10, y = 10)
		@duration = duration
		@remaining = duration
		@active = false
		
		@text = Text.new(
			"Timer: #{@remaining.round(1)}",
			x: x,
			y: y,
			size: 20,
			color: 'white'
		)
	end

	def update
		if @active && @remaining > 0
			@remaining -= 1.0 / 60.0 # Subtract frame time (assuming 60 Fps)

			@text.text = "Timer: #{@remaining.round(1)}"
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
		@text.text = "Timer: #{@remaining.round(1)}"
		@text.color = 'white'
	end
end