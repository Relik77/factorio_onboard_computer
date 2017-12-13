data:extend({
    {
        type = "battery-equipment",
        name = "onboard-computer-equipment",
        icon_size = 32,
        sprite =
        {
            filename = "__onboard_computer__/graphics/icons/onboard-computer-equipment.png",
            width = 64,
            height = 64,
            priority = "medium"
        },
        shape =
        {
            width = 2,
            height = 2,
            type = "full"
        },
        energy_source =
        {
            type = "electric",
            buffer_capacity = "2MJ",
            input_flow_limit = "1MW",
            output_flow_limit = "1MW",
            usage_priority = "terciary"
        },
        categories = {"armor"}
    },
})