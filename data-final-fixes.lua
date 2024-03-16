require("const.functions")

--====================================================================================================
-- -- CHECK FOR MOD
--====================================================================================================

if not mods["Krastorio2"] then
    return
end

-- 
 
require("data_fixers.tech")
require("data_fixers.recipes")
require("data_fixers.remove_science_packs")
require("data_fixers.fix_science_packs")
require("data_fixers.add_science_packs")


if data.raw["lab"]["ei_big-lab"] then
    -- If it does, insert your custom science pack into its inputs
    table.insert(data.raw["lab"]["ei_big-lab"].inputs, "matter-tech-card")
    table.insert(data.raw["lab"]["ei_big-lab"].inputs, "singularity-tech-card")
end

recipe_swap(modprefix.."dark-age-lab","automation-core",modprefix.."iron-mechanical-parts",false)

local electric_offshore_pump = data.raw["assembling-machine"]["kr-electric-offshore-pump"]  
electric_offshore_pump.energy_source = {
    type = "void"
}

--====================================================================================================
-- Fix Pumpjack
--====================================================================================================

local steam_pumpjack = data.raw["mining-drill"]["ei_steam-oil-pumpjack"]  
steam_pumpjack.resource_categories = {type =  "oil"}

local deep_pumpjack = data.raw["mining-drill"]["ei_deep-pumpjack"]
table.insert(deep_pumpjack.resource_categories,  "oil")