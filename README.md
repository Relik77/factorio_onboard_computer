Factorio: OnBoard Computer
==========================

`factorio_onboard_computer` is a Factorio mod that provides add a board computer to your cars and write a Lua program to give them an AI.

Dependencies:
-------------
- [computer_core](https://mods.factorio.com/mods/Relik77/computer_core)
- Any mod that adds an inventory grid to vehicles (eg: [Vehicle Grid](https://mods.factorio.com/mods/Optera/VehicleGrid), [VehicleGrids](https://mods.factorio.com/mods/RubenGass/VehicleGrids), [5Dim's mod - Vehicle](https://mods.factorio.com/mods/McGuten/5dim_vehicle)...)

OnBoard APIs
------------
OnBoard mod add an `On-board computer` item, placed in the equipment grid of a car it gives access to an API ``car``\
The `car API` provides these functions
- `car.hasPassenger()` : Return true if a player is in the car
- `car.getPosition()` : Returns the current position of the car
- `car.getSpeed()` : Return the speed of the car in km/h
- `car.getOrientation()` : Return the orientation of the car
- `car.scanSurface(position)` : Scan a position in a radius of 20 tiles, return true or false if the car will collides at and return the tile name
- `car.getFuel()` : Returns the fuel in the tank of the car
- `car.startEngine()` : Starts the car engine
- `car.stopEngine()` : Stop the car engine
- `car.accelerate()` : Press the gas pedals
- `car.brake()` : Press the brake pedal
- `car.reverse()` : Put the car into reverse
- `car.turnRight()` : Turn the steering wheel to the right
- `car.turnLeft()` : Turn the steering wheel to the left
- `car.straight()` : Put back the wheels straight
- `car.getCargo()` : Returns the contents of the car
- `car.trafficInformation()` : Scan trafic in a radius of 20 tiles, return entities information
- `car.getWaypoint(name)` : Find a waypoint by its name, and return its position

TODO
====
What should be done in the future:
- Military computer : provides functions to detect and engage your enemies
