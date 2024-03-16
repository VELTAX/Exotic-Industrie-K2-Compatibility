local ei_lib = require("const.lib")
local matter = require("__Krastorio2__.lib.public.data-stages.matter-util")
local _td = table.deepcopy

--====================================================================================================
-- Function
--====================================================================================================

function swap_ingredient_in_all_recipes(oldIngredientName, newIngredientName, excludedRecipes, craftingCategories)
    -- Create a local helper function to check if a recipe is excluded
    local function is_recipe_excluded(recipeName)
        for _, excludedRecipeName in ipairs(excludedRecipes) do
            if recipeName == excludedRecipeName then
                return true
            end
        end
        return false
    end

    -- Create a local helper function to check if a recipe's category matches the filter
    local function is_category_matched(recipeCategory)
        if not craftingCategories then
            return true -- No filter provided, so no need to check category
        elseif type(craftingCategories) == "string" then
            return recipeCategory == craftingCategories
        elseif type(craftingCategories) == "table" then
            for _, category in ipairs(craftingCategories) do
                if recipeCategory == category then
                    return true
                end
            end
        end
        return false -- No match found
    end

    for recipeName, recipe in pairs(data.raw.recipe) do
        if not is_recipe_excluded(recipeName) and is_category_matched(recipe.category) then
            if recipe.ingredients then
                -- Handle normal ingredient list
                swap_or_remove_ingredient(recipe.ingredients, oldIngredientName, newIngredientName)
            end
            if recipe.normal and recipe.normal.ingredients then
                -- Handle normal mode specific ingredient list
                swap_or_remove_ingredient(recipe.normal.ingredients, oldIngredientName, newIngredientName)
            end
            if recipe.expensive and recipe.expensive.ingredients then
                -- Handle expensive mode specific ingredient list
                swap_or_remove_ingredient(recipe.expensive.ingredients, oldIngredientName, newIngredientName)
            end
        end
    end
end


function swap_or_remove_ingredient(ingredients, oldIngredientName, newIngredientName)
    local foundOldIngredient = false
    local foundNewIngredient = false
    local oldIngredientIndex = nil

    for i, ingredient in ipairs(ingredients) do
        local ingredientName = ingredient.name or ingredient[1]
        if ingredientName == oldIngredientName then
            foundOldIngredient = true
            oldIngredientIndex = i
        elseif ingredientName == newIngredientName then
            foundNewIngredient = true
        end
    end

    if foundOldIngredient then
        if foundNewIngredient then
            -- New ingredient is already in the recipe, remove the old one
            table.remove(ingredients, oldIngredientIndex)
        else
            -- New ingredient not found, replace the old one with the new one
            if ingredients[oldIngredientIndex].name then
                ingredients[oldIngredientIndex].name = newIngredientName
            else
                ingredients[oldIngredientIndex][1] = newIngredientName
            end
        end
    end
end

--====================================================================================================
-- Merge
--====================================================================================================



--====================================================================================================
-- Swap ingredients
--====================================================================================================
local excludedRecipes = {}

swap_ingredient_in_all_recipes("iron-gear-wheel", modprefix.."iron-mechanical-parts", excludedRecipes)
swap_ingredient_in_all_recipes("steel-gear-wheel", modprefix.."steel-mechanical-parts", excludedRecipes)
swap_ingredient_in_all_recipes("glass", modprefix.."glass", excludedRecipes)
swap_ingredient_in_all_recipes("sand", modprefix.."sand", excludedRecipes)
swap_ingredient_in_all_recipes("iron-beam", modprefix.."iron-beam", excludedRecipes)
swap_ingredient_in_all_recipes("steel-beam", "steel-plate", excludedRecipes)
swap_ingredient_in_all_recipes("ei_lithium-crystal", "lithium", excludedRecipes)
swap_ingredient_in_all_recipes("ammonia", "ei_ammonia-gas", excludedRecipes)
swap_ingredient_in_all_recipes("hydrogen", "ei_hydrogen-gas", excludedRecipes)


local excludedRecipes = {
    ["ei_copper-mechanical-parts"] = true,
    ["ei_iron-mechanical-parts"] = true,
    ["automation-core"] = true,
    ["ei_steam-engine"] = true,
}

swap_ingredient_in_all_recipes(modprefix.."copper-mechanical-parts", "automation-core", excludedRecipes, "crafting")
swap_ingredient_in_all_recipes(modprefix.."iron-mechanical-parts", "automation-core", excludedRecipes, "crafting")
recipe_swap("assembling-machine-1",modprefix.."copper-mechanical-parts","automation-core",2)
recipe_swap("assembling-machine-2",modprefix.."iron-mechanical-parts","automation-core",3)

recipe_remove_ingredient("automation-core","copper-plate")
recipe_remove_ingredient("automation-core",modprefix.."iron-mechanical-parts")
table.insert(data.raw.recipe["automation-core"].ingredients, {modprefix.."copper-mechanical-parts", 2})
table.insert(data.raw.recipe["automation-core"].ingredients, {modprefix.."iron-mechanical-parts", 2})

--====================================================================================================
-- Modify recipe ingredient and unlock
--====================================================================================================

-- Wind Turbine
add_unlock_recipe(modprefix.."electricity-power","kr-wind-turbine")

-- Inserter
remove_unlock_recipe("logistics","inserter")
remove_unlock_recipe("logistics","long-handed-inserter")

-- Chemical Plant
remove_unlock_recipe("kr-fluids-chemistry","chemical-plant")
add_unlock_recipe("oil-processing","chemical-plant")

-- K2 Crusher unlock
add_unlock_recipe(modprefix.."crusher","kr-crusher")

-- Electronic components
recipe_remove_ingredient("electronic-components",modprefix.."glass")
table.insert(data.raw.recipe["electronic-components"].ingredients, {modprefix.."electron-tube", 2})

-- Advanced circuit
recipe_swap("advanced-circuit",modprefix.."electron-tube","electronic-components",false)

-- Semi-conductor wafer
table.insert(data.raw.recipe[modprefix.."semiconductor"].ingredients, {"silicon", 2})

-- cpu
table.insert(data.raw.recipe[modprefix.."cpu"].ingredients, {"electronic-components", 2})

-- matter-tech-card
table.insert(data.raw.recipe["matter-tech-card"].ingredients, {"ei_fusion-data", 2})

-- singularity-tech-card
table.insert(data.raw.recipe["singularity-tech-card"].ingredients, {"ei_fusion-data", 4})

-- exotic-age-pack
table.insert(data.raw.recipe[modprefix.."exotic-age-tech"].ingredients, {"matter-cube", 1})

-- Water/Water Seperation
remove_unlock_recipe("kr-advanced-chemistry","kr-water")
remove_unlock_recipe("kr-advanced-chemistry","kr-water-separation")

-- Processing Unit 
--local recipe = data.raw.recipe["processing-unit"]
--table.insert(recipe.ingredients, {type = "fluid", name = "nitric-acid", amount = 10})

-- Amonia (KR)
remove_unlock_recipe("kr-advanced-chemistry","ammonia")

-- Nitric Acid
recipe_swap("nitric-acid","ammonia",modprefix.."ammonia-gas",false)

-- Biomethanol
recipe_swap("biomethanol","oxygen",modprefix.."oxygen-gas",false)

-- Hydrogen-chloride
recipe_swap("hydrogen-chloride","hydrogen",modprefix.."hydrogen-gas",false)

-- Lithium Crystal
remove_unlock_recipe("ei_lithium-processing","ei_lithium-crystal")

recipe_swap_output("kr-water-electrolysis", "hydrogen", modprefix.."hydrogen-gas" )

--====================================================================================================
-- -- Modify Tech
--====================================================================================================

data.raw.recipe[modprefix.."computer-age-tech"].category = "t2-tech-cards"
data.raw.recipe[modprefix.."advanced-computer-age-tech"].category = "t2-tech-cards"
data.raw.recipe[modprefix.."knowledge-computer-age-tech"].category = "t2-tech-cards"
data.raw.recipe[modprefix.."quantum-age-tech"].category = "t3-tech-cards"
data.raw.recipe[modprefix.."fusion-quantum-age-tech"].category = "t3-tech-cards"
data.raw.recipe[modprefix.."space-quantum-age-tech"].category = "t3-tech-cards"
data.raw.recipe[modprefix.."exotic-age-tech"].category = "t3-tech-cards"

--====================================================================================================
-- -- Disable recipe
--====================================================================================================

data.raw.recipe["water-from-atmosphere"].enabled = false
data.raw.recipe["basic-tech-card"].enabled = false
data.raw.recipe["kr-wind-turbine"].enabled = false
data.raw.recipe["iron-beam"].enabled = false
data.raw.recipe["steel-beam"].enabled = false
data.raw.recipe["steel-gear-wheel"].enabled = false
data.raw.recipe["ei_battery:lithium"].enabled = false

--====================================================================================================
-- remove unlocked recipe
--====================================================================================================

remove_unlock_recipe("steel-processing","steel-beam")
remove_unlock_recipe("steel-processing","steel-gear-wheel")

