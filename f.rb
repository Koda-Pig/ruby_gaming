require 'ruby2d'
require_relative 'source/constants'
require_relative 'source/state'
require_relative 'source/enemy'

set title: 'ruby gaming'
set width: $GAME_WIDTH
set height: $GAME_HEIGHT

@state = PlayerState.new('standing_right')
@enemy = Enemy.new('robert')

# event handlers
on :key_down do |event|
	case event.key
	when *VALID_KEYS # using the 'splat' operator here to expand the VALID_KEYS array
		@state.pressed_keys << event.key
		@state.last_direction = event.key if ['left', 'right'].include?(event.key)
	when 'escape'
		close
	end
end

on :key_up do |event|
	@state.sprite.stop
	@state.pressed_keys.delete(event.key)
end

# animation loop
update do
	@state.update
	@enemy.update(@state.current_moving_direction)
end

show