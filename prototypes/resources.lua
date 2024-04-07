local resource_autoplace = require("__core__/lualib/resource-autoplace")
local noise = require("__core__/lualib/noise")

local deep_core_ore_autoplace = resource_autoplace.resource_autoplace_settings({
  name = "cube-deep-core-vein",
  order = "f",
  base_density = 1,
  base_spots_per_km2 = 0.05,
  has_starting_area_placement = false,
  random_spot_size_minimum = 0.01,
  random_spot_size_maximum = 0.1,
  regular_blob_amplitude_multiplier = 1,
  richness_post_multiplier = 1,
  additional_richness = 150000,
  regular_rq_factor_multiplier = 0.1,
  candidate_spot_count = 22,
})

-- Distance from origin at which fully spawning.
local deep_core_distance = 512
-- Factor where it starts to fade in.
local deep_core_fade_ratio = 3
local deep_core_distance_bonus = 1024
deep_core_ore_autoplace.probability_expression =
    deep_core_ore_autoplace.probability_expression + noise.define_noise_function(function(x, y)
      local d = deep_core_distance * deep_core_distance
      local r = deep_core_fade_ratio * deep_core_fade_ratio
      local c = r / d * (1 - r)
      return noise.clamp(c * (d - x * x - y * y), -1, 0)
    end)
deep_core_ore_autoplace.richness_expression = deep_core_ore_autoplace.richness_expression +
    noise.get_control_setting("cube-deep-core-vein").richness_multiplier *
    noise.get_control_setting("cube-deep-core-vein").size_multiplier * noise.define_noise_function(function(x, y)
      return noise.max(0, deep_core_distance_bonus * ((x * x + y * y)^0.5 - deep_core_distance))
    end)

data:extend({
  {
    type = "resource-category",
    name = "cube-deep-core",
  },

  {
    type = "autoplace-control",
    name = "cube-rare-metals",
    localised_name = {"", "[entity=cube-rare-metals]", {"autoplace-control-names.cube-rare-metals"}},
    order = "c-a",
    richness = true,
    category = "resource",
  },
  {
    type = "autoplace-control",
    name = "cube-deep-core-vein",
    localised_name = { "", "[entity=cube-deep-core-vein] ", { "autoplace-control-names.cube-deep-core-vein" } },
    richness = true,
    order = "b-k",
    category = "resource",
  },

  {
    type = "noise-layer",
    name = "cube-rare-metals",
  },
  {
    type = "noise-layer",
    name = "cube-deep-core-vein",
  },

  {
    type = "resource",
    name = "cube-rare-metals",
    icon = "__Krastorio2Assets__/icons/resources/rare-metals.png",
    icon_size = 64,
    icon_mipmaps = 4,
    flags = {"placeable-neutral"},
    order = "a-b-a",
    subgroup = "raw-resource",
    tree_removal_probability = 0,
    tree_removal_max_distance = 0,
    minable = {
      hardness = 1,
      mining_particle = "stone-particle",
      mining_time = 1,
      result = "cube-raw-rare-metals",
      -- fluid_amount = 25,
      -- required_fluid = "chlorine",
    },
    collision_box = {{-0.1, -0.1}, {0.1, 0.1}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    autoplace = resource_autoplace.resource_autoplace_settings({
      name = "cube-rare-metals",
      order = "d",
      base_density = 8,
      -- base_spots_per_km2 = 0.75,
      has_starting_area_placement = true,
      -- random_spot_size_minimum = 0.25,
      -- random_spot_size_maximum = 3,
      -- regular_blob_amplitude_multiplier = 1,
      regular_rq_factor_multiplier = 1.1,
      starting_rq_factor_multiplier = 1.5,
      candidate_spot_count = 22,
    }),
    stage_counts = {15000, 9500, 5500, 2900, 1300, 400, 150, 80},
    stages = {
      sheet = {
        filename = "__Krastorio2Assets__/resources/rare-metals/rare-metals.png",
        priority = "extra-high",
        width = 64,
        height = 64,
        frame_count = 8,
        variation_count = 8,
        hr_version = {
          filename = "__Krastorio2Assets__/resources/rare-metals/hr-rare-metals.png",
          priority = "extra-high",
          width = 128,
          height = 128,
          frame_count = 8,
          variation_count = 8,
          scale = 0.5,
        },
      },
    },
    stages_effect = {
      sheet = {
        filename = "__Krastorio2Assets__/resources/rare-metals/rare-metals-glow.png",
        priority = "extra-high",
        width = 64,
        height = 64,
        frame_count = 8,
        animation_speed = 3,
        variation_count = 8,
        draw_as_glow = true,
        hr_version = {
          filename = "__Krastorio2Assets__/resources/rare-metals/hr-rare-metals-glow.png",
          priority = "extra-high",
          width = 128,
          height = 128,
          frame_count = 8,
          animation_speed = 3,
          variation_count = 8,
          scale = 0.5,
          draw_as_glow = true,
        },
      },
    },
    effect_animation_period = 5,
    effect_animation_period_deviation = 1,
    effect_darkness_multiplier = 5,
    min_effect_alpha = 0.2,
    max_effect_alpha = 0.3,
    map_color = {r = 0.6, g = 0.3, b = 1},
    mining_visualisation_tint = {r = 0.258, g = 0.960, b = 0.529},
  },
  {
    type = "resource",
    name = "cube-deep-core-vein",
    category = "cube-deep-core",
    icon = "__Krastorio2Assets__/icons/items-with-variations/raw-imersite/raw-imersite.png",
    icon_size = 64,
    icon_mipmaps = 4,
    flags = {"placeable-neutral"},
    order = "a-b-b",
    subgroup = "raw-resource",
    infinite = false,
    highlight = true,
    minimum = 50,
    normal = 350,
    infinite_depletion_amount = 10,
    resource_patch_search_radius = 12,
    tree_removal_probability = 0.65,
    tree_removal_max_distance = 16 * 16,
    minable = {
      hardness = 1,
      mining_time = 1,
      result = "cube-deep-core-ore",
    },
    collision_box = {{ -3.4, -3.4}, {3.4, 3.4}},
    selection_box = {{ -3.5, -3.5}, {3.5, 3.5}},
    autoplace = deep_core_ore_autoplace,
    stage_counts = {0},
    stages = {
      sheet = {
        filename = "__Krastorio2Assets__/resources/imersite/imersite-rift.png",
        priority = "extra-high",
        width = 250,
        height = 250,
        frame_count = 6,
        variation_count = 1,
        scale = 0.8,
        hr_version = {
          filename = "__Krastorio2Assets__/resources/imersite/hr-imersite-rift.png",
          priority = "extra-high",
          width = 500,
          height = 500,
          frame_count = 6,
          variation_count = 1,
          scale = 0.4,
        },
      },
    },
    stages_effect = {
      sheets = {
        {
          filename = "__Krastorio2Assets__/resources/imersite/imersite-rift-glow.png",
          priority = "extra-high",
          width = 250,
          height = 250,
          frame_count = 6,
          variation_count = 1,
          draw_as_glow = true,
          scale = 0.8,
          hr_version = {
            filename = "__Krastorio2Assets__/resources/imersite/hr-imersite-rift-glow.png",
            priority = "extra-high",
            width = 500,
            height = 500,
            frame_count = 6,
            variation_count = 1,
            scale = 0.4,
            draw_as_glow = true,
          },
        },
      },
    },
    effect_animation_period = 5,
    effect_animation_period_deviation = 1,
    effect_darkness_multiplier = 3.5,
    min_effect_alpha = 0.2,
    max_effect_alpha = 0.3,
    map_color = { r = 1, g = 0.5, b = 1 },
    mining_visualisation_tint = { r = 0.792, g = 0.050, b = 0.858 },
    map_grid = false,
  },
})
