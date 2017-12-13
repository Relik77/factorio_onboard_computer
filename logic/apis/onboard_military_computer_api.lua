--return {
return [[return {
    name = "car",
    description = "Military computer detected ! Car api upgraded, functions to engage your enemies added.",
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
        if inventory["onboard-military-computer-equipment"] and inventory["onboard-military-computer-equipment"] > 0 then
            return true
        end
        return false
    end,
    events = {
    },
    prototype = {
        getHealth = {
            "car.getHealth() - Return the health of the car",
            function(self)
                return self.__entity.health
            end
        },
        getShield = {
            "car.getShield() - Return the shield of the car",
            function(self)
                local car = self.__entity
                local inventory = car.grid

                return inventory.shield
            end
        },
        getEnergy = {
            "car.getEnergy() - Return the energy stored in all batteries of the car",
            function(self)
                local car = self.__entity
                local inventory = car.grid

                return inventory.available_in_batteries
            end
        },
        getAmmo = {
            "car.getAmmo() - Returns the number of ammo remaining",
            function(self)
                local car = self.__entity
                local inventory = car.get_inventory(defines.inventory.car_ammo)

                if inventory ~= nil then
                    return inventory.get_contents()
                end
            end
        },
        selectWeapon = {
            "car.selectWeapon(index) - Select a car weapon",
            function(self, index)
                local car = self.__entity
                local driver = car.get_driver()

                if driver and type(index) == "number" then
                    driver.selected_gun_index = index
                end
            end
        },
        shootOnPosition = {
            "car.shootOnPosition(position) - Shoot on given position",
            function(self, position)
                local car = self.__entity
                local driver = car.get_driver()

                if driver then
                    --driver.update_selected_entity(position)
                    driver.shooting_state = {
                        state = defines.shooting.shooting_enemies,
                        position = position
                    }
                end
            end
        },
        stopShooting = {
            "car.stopShooting() - Stop shooting",
            function(self)
                local car = self.__entity
                local driver = car.get_driver()

                if driver then
                    driver.shooting_state = {
                        state = defines.shooting.not_shooting,
                        position = driver.shooting_state.position
                    }
                end
            end
        },
        detectEnemies = {
            "car.detectEnemies(radius, position) - Detect enemies in a radius around the given position (maximum detection distance: 25)",
            function(self, radius, position)
                local player = self.__player
                local car = self.__entity
                local result = {}

                if not position then
                    position = car.position
                end
                if not radius then
                    radius = 25
                end
                local area = {
                    left_top = {
                        x = position.x - radius,
                        y = position.y - radius
                    },
                    right_bottom = {
                        x = position.x + radius,
                        y = position.y + radius
                    }
                }
                if math.abs(area.left_top.x - car.position.x) > 25 then area.left_top.x = car.position.x - 25 end
                if math.abs(area.left_top.y - car.position.y) > 25 then area.left_top.y = car.position.y - 25 end
                if math.abs(area.right_bottom.x - car.position.x) > 25 then area.right_bottom.x = car.position.x + 25 end
                if math.abs(area.right_bottom.y - car.position.y) > 25 then area.right_bottom.y = car.position.y + 25 end

                local entities = car.surface.find_entities_filtered({
                    area = area,
                    force = "enemy"
                })
                for index, entity in pairs(entities) do
                    local distance = self:_getDistance(entity.position)
                    if distance <= radius and player.force ~= entity.force and not player.force.get_friend(entity.force) and entity.valid and entity.health > 0 then
                        table.insert(result, {
                            type = entity.type,
                            name = entity.name,
                            position = entity.position,
                            distance = distance,
                            health = entity.health
                        })
                    end
                end

                table.sort(result, function(a,b)
                    return a.distance < b.distance
                end)
                return result
            end
        },
        detectAllies = {
            "car.detectAllies(radius, position) - Detect allies in a radius around the given position (maximum detection distance: 25)",
            function(self, radius, position)
                local player = self.__player
                local car = self.__entity
                local result = {}

                if not position then
                    position = car.position
                end
                if not radius then
                    radius = 25
                end
                local area = {
                    left_top = {
                        x = position.x - radius,
                        y = position.y - radius
                    },
                    right_bottom = {
                        x = position.x + radius,
                        y = position.y + radius
                    }
                }
                if math.abs(area.left_top.x - car.position.x) > 25 then area.left_top.x = car.position.x - 25 end
                if math.abs(area.left_top.y - car.position.y) > 25 then area.left_top.y = car.position.y - 25 end
                if math.abs(area.right_bottom.x - car.position.x) > 25 then area.right_bottom.x = car.position.x + 25 end
                if math.abs(area.right_bottom.y - car.position.y) > 25 then area.right_bottom.y = car.position.y + 25 end

                local entities = car.surface.find_entities_filtered({
                    area = area,
                    force = player.force
                })
                for index, entity in pairs(entities) do
                    local distance = self:_getDistance(entity.position)
                    if distance <= radius and (player.force == entity.force or player.force.get_friend(entity.force)) and entity.valid and entity.health > 0 then
                        table.insert(result, {
                            type = entity.type,
                            name = entity.name,
                            position = entity.position,
                            distance = distance,
                            health = entity.health
                        })
                    end
                end

                table.sort(result, function(a,b)
                    return a.distance < b.distance
                end)
                return result
            end
        }
    }
}]]
--}
