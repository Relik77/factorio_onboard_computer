--return {
return [[return {
    name = "car",
    description = "The car API provides functions for work with a car",
    entities = function(entity)
        if entity.type ~= "car" then
            return false
        end

        local inventory = entity.grid
        if inventory == nil then
            return false
        else
            inventory = inventory.get_contents()
        end
        if inventory["onboard-computer-equipment"] and inventory["onboard-computer-equipment"] > 0 then
            return true
        end
        if inventory["onboard-military-computer-equipment"] and inventory["onboard-military-computer-equipment"] > 0 then
            return true
        end
        return false
    end,
    events = {
        on_script_kill = function(self)
            self:stopEngine()
        end
    },
    prototype = {
        __init = {
            "os.__init() - Init API",
            function(self)
                self._driverIsBot = false
            end
        },
        _setDirection = {
            "private function car:_setDirection(direction)",
            function(self, direction)
                local car = self.entity
                if car.passenger then
                    car.passenger.riding_state = {
                        acceleration = defines.riding.acceleration.nothing,
                        direction = direction
                    }
                end
            end
        },
        _setAcceleration = {
            "private function car:_setAcceleration(acceleration)",
            function(self, acceleration)
                local car = self.entity
                if car.passenger then
                    car.passenger.riding_state = {
                        acceleration = acceleration,
                        direction = car.passenger.riding_state.direction
                    }
                end
            end
        },
        hasPassenger = {
            "car.hasPassenger() - Return true if a player is in the car",
            function(self)
                local car = self.entity

                return car.passenger and not self._driverIsBot
            end
        },
        getPosition = {
            "car.getPosition() - Returns the current position of the car",
            function(self)
                local car = self.entity

                return car.position
            end
        },
        getSpeed = {
            "car.getSpeed() - Return the speed of the car in km/h",
            function(self)
                local car = self.entity

                return (car.speed * 60 * 60 * 60) / 1000
            end
        },
        getOrientation = {
            "car.getOrientation() - Return the orientation of the car",
            function(self)
                local car = self.entity

                return car.orientation
            end
        },
        scanSurface = {
            "car.scanSurface(position) - Scan a position in a radius of 20 tiles, return true or false if the car will collides at and return the tile name",
            function(self, position)
                local car = self.entity

                position.x = math.floor(position.x + 0.5)
                position.y = math.floor(position.y + 0.5)

                if math.abs(car.position.x - position.x) > 20 or math.abs(car.position.y - position.y) > 20 then
                    return nil, nil
                end

                local tile = car.surface.get_tile(position.x, position.y)
                if tile.collides_with("player-layer") then
                    return true, tile.name
                end

                return car.surface.find_non_colliding_position(car.name, position, 1, 1) == nil, tile.name
            end
        },
        getFuel = {
            "car.getFuel() - Returns the fuel in the tank of the car",
            function(self)
                local car = self.entity
                local inventory = car.get_inventory(defines.inventory.fuel)

                if inventory ~= nil then
                    return inventory.get_contents()
                end
            end
        },
        getCargo = {
            "car.getCargo() - Returns the contents of the car",
            function(self)
                local car = self.entity
                local inventory = car.get_inventory(defines.inventory.car_trunk)

                if inventory ~= nil then
                    return inventory.get_contents()
                end
            end
        },
        startEngine = {
            "car.startEngine() - Starts the car engine",
            function(self)
                local player = self.player
                local car = self.entity

                if not car.passenger then
                    self._driverIsBot = true
                    car.passenger = car.surface.create_entity({
                        name = "player",
                        force = player.force,
                        position = car.position
                    })
                end
            end
        },
        stopEngine = {
            "car.stopEngine() - Stop the car engine",
            function(self)
                local car = self.entity

                self:brake()
                if self._driverIsBot and car.passenger and car.passenger.valid then
                    car.passenger.destroy()
                    self._driverIsBot = false
                end
            end
        },
        accelerate = {
            "car.accelerate() - Press the gas pedals",
            function(self)
                self:_setAcceleration(defines.riding.acceleration.accelerating)
            end
        },
        brake = {
            "car.brake() - Press the brake pedal",
            function(self)
                self:_setAcceleration(defines.riding.acceleration.braking)
            end
        },
        reverse = {
            "car.reverse() - Put the car into reverse",
            function(self)
                self:_setAcceleration(defines.riding.acceleration.reversing)
            end
        },
        turnRight = {
            "car.turnRight() - Turn the steering wheel to the right",
            function(self)
                self:_setDirection(defines.riding.direction.right)
            end
        },
        turnLeft = {
            "car.turnLeft() - Turn the steering wheel to the left",
            function(self)
                self:_setDirection(defines.riding.direction.left)
            end
        },
        straight = {
            "car.straight() - Put back the wheels straight",
            function(self)
                self:_setDirection(defines.riding.direction.straight)
            end
        }
    }
}]]
--}
