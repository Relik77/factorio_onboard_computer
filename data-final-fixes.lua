if settings.startup["onboard-vehicle-grid"].value then
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
