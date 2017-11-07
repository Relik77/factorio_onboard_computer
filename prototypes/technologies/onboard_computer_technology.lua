data:extend({
    {
        type = "technology",
        name = "onboard-computer-technology",
        icon = "__onboard_computer__/graphics/icons/onboard-computer-technology.png",
        icon_size = 128,
        effects =
        {
            {
                type = "unlock-recipe",
                recipe = "onboard-computer-recipe"
            }
        },
        prerequisites = {"computer-gauntlet-technology", "automobilism", "robotics"},
        unit =
        {
            count = 200,
--            count = 1,
            ingredients =
            {
                {"science-pack-1", 1},
                {"science-pack-2", 1},
                {"science-pack-3", 1},
                {"high-tech-science-pack", 1},
            },
            time = 30
        },
        order = "e-d"
    },
})