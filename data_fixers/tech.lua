-- Dark Age

remove_prerequisite("gun-turret", "military")
remove_prerequisite("gun-turret", "automation-science-pack")
remove_prerequisite("logistics", "automation-science-pack")
remove_prerequisite("kr-shelter", "automation-science-pack")

add_prerequisite(modprefix.."burner-assembler", "kr-automation-core")
add_prerequisite("kr-shelter", modprefix.."dark-age")
add_prerequisite("kr-automation-core", modprefix.."dark-age")
add_prerequisite("kr-iron-pickaxe", modprefix.."dark-age")

-- Steam Age

add_prerequisite(modprefix.."steam-assembler", "kr-automation-core")
add_prerequisite(modprefix.."steam-crusher", "kr-automation-core")

-- Electricity Age

add_prerequisite("kr-electric-mining-drill-mk2", "automation-3")
remove_prerequisite("kr-electric-mining-drill-mk2", "kr-electric-mining-drill")

add_prerequisite("kr-crusher", modprefix.."electricity-power")

remove_prerequisite("kr-greenhouse", "kr-stone-processing")
add_prerequisite("kr-greenhouse", modprefix.."electricity-power")
add_prerequisite("kr-greenhouse", modprefix.."glass")

remove_prerequisite("optics", "kr-stone-processing")

remove_prerequisite("oil-processing", "kr-fluids-chemistry")

add_prerequisite("kr-fuel", modprefix.."destill-tower")
remove_prerequisite("kr-fuel", "oil-processing")

add_prerequisite("kr-fluids-chemistry", modprefix.."electricity-age")
remove_prerequisite("kr-fluids-chemistry", "kr-stone-processing")

add_prerequisite("kr-fluid-excess-handling", "fluid-handling")
remove_prerequisite("kr-fluid-excess-handling", "kr-fluids-chemistry")

remove_prerequisite("kr-silicon-processing", "automation-2")

remove_prerequisite("kr-sentinel", "kr-stone-processing")
add_prerequisite("kr-sentinel", "optics")

add_prerequisite(modprefix.."computer-age", "kr-research-server")

-- Computer Age
add_prerequisite("kr-mineral-water-gathering", modprefix.."computer-age")
remove_prerequisite("kr-mineral-water-gathering", "kr-fluids-chemistry")
remove_prerequisite("kr-mineral-water-gathering", "fluid-handling")

add_prerequisite("kr-steel-fluid-tanks", modprefix.."computer-age")

add_prerequisite("kr-advanced-chemistry",modprefix.."oxygen-gas")
remove_prerequisite("kr-advanced-chemistry", "kr-atmosphere-condensation")

add_prerequisite("kr-air-purification",modprefix.."oxygen-gas")
remove_prerequisite("kr-air-purification", "kr-advanced-chemistry")

-- Simulation Age
add_prerequisite("advanced-radar", "military-4")
add_prerequisite("kr-lithium-sulfur-battery", modprefix.."advanced-computer-age-tech")
add_prerequisite("advanced-electronics-2", "kr-advanced-chemistry")

-- Quantum Age

add_prerequisite(modprefix.."quantum-age", "kr-quantum-computer")
add_prerequisite("kr-fusion-energy", modprefix.."fusion-data")
add_prerequisite("kr-atmosphere-condensation", modprefix.."quantum-age")

-- Fusion Quantum Age

remove_prerequisite("kr-matter-tech-card", "kr-singularity-lab")
add_prerequisite("kr-matter-tech-card", modprefix.."fusion-data")

-- Matter
add_prerequisite("kr-automation", modprefix.."neo-assembler")
remove_prerequisite("kr-automation", "kr-enriched-ores")

-- Deep Exploration
add_prerequisite("kr-singularity-tech-card",modprefix.."deep-exploration")

-- Singularity
add_prerequisite(modprefix.."exotic-age","kr-matter-cube" )
add_prerequisite("kr-intergalactic-transceiver",modprefix.."exotic-age" )

--====================================================================================================
-- -- Disable research
--====================================================================================================

local Tech_to_disable = {"automation-science-pack","kr-steam-engine","kr-electric-mining-drill", "kr-electric-mining-drill-mk2", "kr-electric-mining-drill-mk3","kr-crusher",
"kr-stone-processing","kr-advanced-lab","kr-basic-fluid-handling","kr-singularity-lab","kr-advanced-tech-card","kr-enriched-ores","ei_lithium-battery"}

for i, tech in ipairs(Tech_to_disable) do
   disable_tech(tech)
end

-- To rework
disable_tech("kr-atmosphere-condensation")