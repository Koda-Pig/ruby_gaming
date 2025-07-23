# Making games with Ruby (and other bad ideas)

## Resources

1. https://www.ruby2d.com/
2. https://github.com/ruby2d/ruby2d
3. https://youtu.be/dBw2JyV1ZUQ?si=QI_mQLoqqGE56A7i

## The Plan™

Rewrite the player and game state logic written in Typescript from [this repo](https://github.com/Koda-Pig/not-a-pig) to this one in Ruby.

## Todos:

The logic for disabling the ability to attack with the timer has an issue: when the player attacks, the timer is set and they have to wait 5 seconds before they can attack again. This works, unless the user stops attacking (stops holding space) before they hit the ground. This is because the timer is only set when the player hits the ground after an attack. It was done this way initially because starting the timer and setting `player_can_attack` once the player starts an attack stops the attack animation from playing and stops the user being able to finish attacking.

This is what should happen instead:

1. Once user lets GO of the attack button OR hits the ground, timer starts.
