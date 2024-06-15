if mods["Moon_Logic"] then
    local item_name = "mlc"
    local item_subgroup = "circuit-network"

    local item = data.raw.item[item_name]
    item.order = "cube-" .. item_name
    item.subgroup =  item_subgroup

    local recipe = data.raw.recipe[item_name]
    recipe.ingredients = {
      {"arithmetic-combinator", 4},
      {"decider-combinator", 2},
      {"cube-advanced-circuit", 5},
    }

    recipe.category = "cube-fabricator-handcraft"
  
    local technology = data.raw.technology["mlc"]
    technology.unit = tech_cost_unit("1b", 100)
    technology.prerequisites = {
      "cube-combinatorics",
      "cube-advanced-electronics"
    }

    add_mystery_recipe(1, "mlc", "arithmetic-combinator")
    add_mystery_recipe(1, "mlc", "decider-combinator")
  end
  