-- Add items
require ("prototypes.items.onboard_computer_item")
require ("prototypes.items.onboard_military_computer_item")

-- Add recipes
require ("prototypes.recipes.onboard_computer_recipe")
require ("prototypes.recipes.onboard_military_computer_recipe")

-- Add technology research
require ("prototypes.technologies.onboard_computer_technology")
require ("prototypes.technologies.onboard_military_computer_technology")

-- Add equipments
require ("prototypes.equipment.onboard_computer_equipment")
require ("prototypes.equipment.onboard_military_computer_equipment")

if settings.startup["vehicle-grid"] then
    data:extend({
        {
            type = "equipment-grid",
            name = "onboard-car-equipment-grid",
            width = 2,
            height = 2,
            equipment_categories = {"armor"}
        }
    })
    for _, car in pairs(data.raw["car"]) do
        if car.equipment_grid == nil then
            car.equipment_grid = "onboard-car-equipment-grid"
        end
    end
end
