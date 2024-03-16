-- Function to check if an ingredient is already in the technology's ingredients list
function ingredientExists(ingredients, ingredientName)
    for _, ingredient in pairs(ingredients) do
        if ingredient[1] == ingredientName then
            return true
        end
    end
    return false
end

function AddTechIngredient(TechsDict, IngredientList)
    for techName, technology in pairs(data.raw.technology) do
        -- Check if the technology is in the target dictionary
        if TechsDict[techName] then
            -- Technology is targeted for modification
            if technology.unit and technology.unit.ingredients then
                for _, newIngredient in pairs(IngredientList) do
                    -- Check if the ingredient already exists
                    if not ingredientExists(technology.unit.ingredients, newIngredient[1]) then
                        -- Ingredient not found, so add it
                        table.insert(technology.unit.ingredients, newIngredient)
                        print("Added ingredient " .. newIngredient[1] .. " to " .. techName)
                    else
                        print("Ingredient " .. newIngredient[1] .. " already exists in " .. techName)
                    end
                end
            end
        end
    end
end

-- Dark Age
local Techs = {
    "kr-automation-core",
    "kr-iron-pickaxe",
}

local IngredientList = {
    {modprefix.."dark-age-tech", 1},
}

local TechsDict = {}
for _, techName in ipairs(Techs) do
    TechsDict[techName] = true
end

AddTechIngredient(TechsDict, IngredientList)

-- Steam Age

-- Electricity Age
local Techs = {
    "kr-greenhouse",
    "kr-decorations",
    "kr-fluids-chemistry",
    "kr-enriched-ores",
    "kr-steel-fluid-tanks",
}

local IngredientList = {
    {modprefix.."dark-age-tech", 1},
    {modprefix.."steam-age-tech", 1},
    {modprefix.."electricity-age-tech", 1},
}

local TechsDict = {}
for _, techName in ipairs(Techs) do
    TechsDict[techName] = true
end

AddTechIngredient(TechsDict, IngredientList)

-- Computer Age
local Techs = {
    "kr-mineral-water-gathering",
    "kr-bio-fuel",
    "kr-bio-processing",
    "kr-lithium-processing",
    "kr-lithium-sulfur-battery",
}

local IngredientList = {
    {modprefix.."dark-age-tech", 1},
    {modprefix.."steam-age-tech", 1},
    {modprefix.."electricity-age-tech", 1},
    {modprefix.."computer-age-tech", 1},
}

local TechsDict = {}
for _, techName in ipairs(Techs) do
    TechsDict[techName] = true
end

AddTechIngredient(TechsDict, IngredientList)

-- Simulation Age
local Techs = {
    "kr-quantum-computer",
    "kr-advanced-fuel",
    "kr-ai-core",
}

local IngredientList = {
    {modprefix.."dark-age-tech", 1},
    {modprefix.."steam-age-tech", 1},
    {modprefix.."electricity-age-tech", 1},
    {modprefix.."computer-age-tech", 1},
    {modprefix.."advanced-computer-age-tech", 1},
}

local TechsDict = {}
for _, techName in ipairs(Techs) do
    TechsDict[techName] = true
end

AddTechIngredient(TechsDict, IngredientList)

-- Quantum

-- Fusion Quantum
local Techs = {
    "kr-matter-tech-card",
    "kr-fusion-energy",
}

local IngredientList = {
    {modprefix.."dark-age-tech", 1},
    {modprefix.."steam-age-tech", 1},
    {modprefix.."electricity-age-tech", 1},
    {modprefix.."computer-age-tech", 1},
    {modprefix.."advanced-computer-age-tech", 1},
    {modprefix.."knowledge-computer-age-tech", 1},
    {modprefix.."quantum-age-tech", 1},
    {modprefix.."fusion-quantum-age-tech", 1},
}

local TechsDict = {}
for _, techName in ipairs(Techs) do
    TechsDict[techName] = true
end

AddTechIngredient(TechsDict, IngredientList)

-- Matter
local Techs = {
    "kr-improved-pollution-filter",
    "kr-energy-control-unit",
    "kr-imersium-processing",
    "kr-energy-storage",
    "kr-matter-processing",
    "kr-singularity-tech-card",
    "kr-advanced-furnace",
    "kr-automation",
    "kr-power-armor-mk3",
    "kr-robot-battery-plus",
    "kr-laser-artillery-turret",
    "kr-advanced-chemical-plant",
    "kr-advanced-roboports",
    "kr-advanced-pickaxe",
    "kr-advanced-tank",
    "kr-electric-mining-drill-mk3",
    "kr-personal-laser-defense-mk3-equipment",
    "kr-superior-exoskeleton-equipment",
    "kr-logistic-5",
    "kr-superior-inserters",
}

for index, tech in pairs(data.raw.technology) do
    if tech.prerequisites then
        local prerequisitesToRemove = {}
        for i, prereq in ipairs(tech.prerequisites) do
            -- Checking if the prerequisite name starts with "automation-science-pack"
            if string.sub(prereq, 1, string.len("kr-matter-processing")) == "kr-matter-processing" then
                table.insert(Techs, tech.name)
            end
        end
    end
end

local IngredientList = {
    {modprefix.."dark-age-tech", 1},
    {modprefix.."steam-age-tech", 1},
    {modprefix.."electricity-age-tech", 1},
    {modprefix.."computer-age-tech", 1},
    {modprefix.."advanced-computer-age-tech", 1},
    {modprefix.."knowledge-computer-age-tech", 1},
    {modprefix.."quantum-age-tech", 1},
    {modprefix.."fusion-quantum-age-tech", 1},
    {"matter-tech-card", 1},
}

local TechsDict = {}
for _, techName in ipairs(Techs) do
    TechsDict[techName] = true
end

AddTechIngredient(TechsDict, IngredientList)

-- Deep Space

-- Singularity
local Techs = {
    "kr-singularity-tech-card",
    "kr-planetary-teleporter",
    "kr-power-armor-mk4",
    "kr-singularity-beacon",
    "artillery-shell-range-5",
    "artillery-shell-speed-5",
    "energy-weapons-damage-16",
    "follower-robot-count-9",
    "mining-productivity-16",
    "physical-projectile-damage-16",
    "refined-flammables-16",
    "stronger-explosives-16",
    "worker-robots-speed-9",
    "kr-antimatter-reactor",
    "kr-matter-cube",
    "kr-personal-laser-defense-mk4-equipment",
    "kr-antimatter-ammo",
    "kr-antimatter-reactor-equipment",
    "ei_exotic-age",
}

local IngredientList = {
    {modprefix.."dark-age-tech", 1},
    {modprefix.."steam-age-tech", 1},
    {modprefix.."electricity-age-tech", 1},
    {modprefix.."computer-age-tech", 1},
    {modprefix.."advanced-computer-age-tech", 1},
    {modprefix.."knowledge-computer-age-tech", 1},
    {modprefix.."quantum-age-tech", 1},
    {modprefix.."fusion-quantum-age-tech", 1},
    {"matter-tech-card", 1},
    {modprefix.."space-quantum-age-tech", 1},
}

local TechsDict = {}
for _, techName in ipairs(Techs) do
    TechsDict[techName] = true
end

AddTechIngredient(TechsDict, IngredientList)


-- Exotic Age
local Techs = {
    "kr-intergalactic-transceiver",
}

local IngredientList = {
    {modprefix.."dark-age-tech", 1},
    {modprefix.."steam-age-tech", 1},
    {modprefix.."electricity-age-tech", 1},
    {modprefix.."computer-age-tech", 1},
    {modprefix.."advanced-computer-age-tech", 1},
    {modprefix.."knowledge-computer-age-tech", 1},
    {modprefix.."quantum-age-tech", 1},
    {modprefix.."fusion-quantum-age-tech", 1},
    {"matter-tech-card", 1},
    {modprefix.."space-quantum-age-tech", 1},
}

local TechsDict = {}
for _, techName in ipairs(Techs) do
    TechsDict[techName] = true
end

AddTechIngredient(TechsDict, IngredientList)
