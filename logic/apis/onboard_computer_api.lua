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
                local car = self.__entity
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
                local car = self.__entity
                if car.passenger then
                    car.passenger.riding_state = {
                        acceleration = acceleration,
                        direction = car.passenger.riding_state.direction
                    }
                end
            end
        },
        _getDistance = {
            "private function car:_getDistance(position)",
            function(self, position)
                local car = self.__entity

                return math.sqrt((car.position.x - position.x)^2 + (car.position.y - position.y)^2)
            end
        },
        _hasItem = {
            "private function car:_hasItem(name...)",
            function(self, ...)
                local car = self.__entity

                local inventory = car.grid
                if inventory == nil then
                    return false
                else
                    inventory = inventory.get_contents()
                end
                for i, name in pairs({...}) do
                    if inventory[name] and inventory[name] > 0 then
                        return true
                    end
                end
                return false
            end
        },
        hasPassenger = {
            "car.hasPassenger() - Return true if a player is in the car",
            function(self)
                local car = self.__entity

                return car.passenger and not self._driverIsBot
            end
        },
        getPosition = {
            "car.getPosition() - Returns the current position of the car",
            function(self)
                local car = self.__entity

                return car.position
            end
        },
        getSpeed = {
            "car.getSpeed() - Return the speed of the car in km/h",
            function(self)
                local car = self.__entity

                return (car.speed * 60 * 60 * 60) / 1000
            end
        },
        getOrientation = {
            "car.getOrientation() - Return the orientation of the car",
            function(self)
                local car = self.__entity

                return car.orientation
            end
        },
        scanSurface = {
            "car.scanSurface(position) - Scan a position in a radius of 20 tiles, return true or false if the car will collides at and return the tile name",
            function(self, position)
                local car = self.__entity

                if self:_getDistance(position) > 20 then
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
                local car = self.__entity
                local inventory = car.get_inventory(defines.inventory.fuel)

                if inventory ~= nil then
                    return inventory.get_contents()
                end
            end
        },
        getCargo = {
            "car.getCargo() - Returns the contents of the car",
            function(self)
                local car = self.__entity
                local inventory = car.get_inventory(defines.inventory.car_trunk)

                if inventory ~= nil then
                    return inventory.get_contents()
                end
            end
        },
        trafficInformation = {
            "car.trafficInformation() - Scan trafic in a radius of 20 tiles, return entities information",
            function(self)
                local player = self.__player
                local car = self.__entity
                local position = car.position
                local result = {}
                local area = {
                    left_top = {
                        x = position.x - 20,
                        y = position.y - 20
                    },
                    right_bottom = {
                        x = position.x + 20,
                        y = position.y + 20
                    }
                }

                local entities = car.surface.find_entities_filtered({
                    area = area,
                    type = "player",
                    force = player.force
                })
                for index, entity in pairs(entities) do
                    local speed = 0
                    if entity.player.walking_state.walking then
                        speed = 10
                    end
                    table.insert(result, {
                        type = entity.type,
                        name = entity.player.name,
                        position = entity.position,
                        distance = self._getDistance(entity.position),
                        orientation = entity.orientation,
                        speed = speed
                    })
                end

                entities = car.surface.find_entities_filtered({
                    area = area,
                    type = "car",
                    force = player.force
                })
                for index, entity in pairs(entities) do
                    if entity ~= car and self._hasItem({entity = entity}, "onboard-computer-equipment", "onboard-military-computer-equipment") then
                        table.insert(result, {
                            type = entity.type,
                            name = entity.name,
                            position = entity.position,
                            distance = self._getDistance(entity.position),
                            orientation = entity.orientation,
                            speed = self.getSpeed({entity = entity})
                        })
                    end
                end

                return result
            end
        },
        getWaypoint = {
            "car.getWaypoint(name) - Find a waypoint by its name, and return its position",
            function(self, name)
                local waypoint = self.__getWaypoint(name)
                if waypoint then
                    return waypoint.position
                end
                return nil
            end
        },
        startEngine = {
            "car.startEngine() - Starts the car engine",
            function(self)
                local player = self.__player
                local car = self.__entity

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
                local car = self.__entity

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
