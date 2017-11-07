data:extend({
    {
        type = "technology",
        name = "onboard-military-computer-technology",
        icon = "__onboard_computer__/graphics/icons/onboard-military-computer-technology.png",
        icon_size = 128,
        effects =
        {
            {
                type = "unlock-recipe",
                recipe = "onboard-military-computer-recipe"
            }
        },
        prerequisites = {"onboard-computer-technology", "tanks", "military-4"},
        unit =
        {
            count = 400,
--            count = 1,
            ingredients =
            {
                {"science-pack-1", 1},
                {"science-pack-2", 1},
                {"science-pack-3", 1},
                {"military-science-pack", 1},
                {"high-tech-science-pack", 1},
            },
            time = 30
        },
        order = "e-d"
    },
})