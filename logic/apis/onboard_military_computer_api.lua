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
                return self.entity.health
            end
        },
        getAmmo = {
            "car.getAmmo() - Returns the number of ammo remaining",
            function(self)
                local car = self.entity
                local inventory = car.get_inventory(defines.inventory.car_ammo)

                if inventory ~= nil then
                    return inventory.get_contents()
                end
            end
        },
        selectWeapon = {
            "car.selectWeapon(index) - Select a car weapon",
            function(self, index)
                local car = self.entity

                if car.passenger and type(index) == "number" then
                    car.passenger.selected_gun_index = index
                end
            end
        },
        shootOnPosition = {
            "car.shootOnPosition(position)",
            function(self, position)
                local car = self.entity

                if car.passenger then
                    car.passenger.shooting_state = {
                        state = defines.shooting.shooting_selected,
                        position = position
                    }
                end
            end
        }
    }
}]]
--}
