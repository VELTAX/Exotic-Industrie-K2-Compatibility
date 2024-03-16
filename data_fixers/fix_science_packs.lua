-- loop over all techs and check if any of their prerequisits contain
-- a pack they dont, if so add it to the tech

local exclude_knowledge = {
    ["ei_knowledge-tech"] = true,
    ["ei_knowledge-tech-2"] = true,
    ["ei_knowledge-tech-3"] = true,
}

local to_add = {}

for tech_id,_ in pairs(data.raw.technology) do

    local tech = data.raw.technology[tech_id]

    -- skip techs that end with :dummy
    if string.sub(tech_id, -6) == ":dummy" then
        goto continue
    end
    if tech_id == "ei_temp" then
        goto continue
    end

    if not tech.prerequisites then
        goto continue
    end
    if #tech.prerequisites == 0 then
        goto continue
    end

    -- first collect list of all science packs from all prerequisits
    local prereq_packs = {}

    for _,prereq in ipairs(tech.prerequisites) do

        local prereq_tech = data.raw.technology[prereq]

        if not prereq_tech.unit then
            goto skip
        end
        if not prereq_tech.unit.ingredients then
            goto skip
        end

        for _,pack in ipairs(prereq_tech.unit.ingredients) do
            
            if not exclude_knowledge[pack[1]] then
                prereq_packs[pack[1]] = true
            end

        end

        ::skip::

    end


    -- now check if tech contains all prerequisit packs, if not add them
    if not tech.unit then
        goto continue
    end
    if not tech.unit.ingredients then
        goto continue
    end
    if #tech.unit.ingredients == 0 then
        goto continue
    end
    if #tech.unit.ingredients == 1 then
        if exclude_knowledge[tech.unit.ingredients[1][1]] then
            goto continue
        end
    end


    for i,_ in pairs(prereq_packs) do

        local missing = true

        for _,pack in ipairs(tech.unit.ingredients) do
            if pack[1] == i then
                missing = false
            end
        end

        if missing then
            table.insert(to_add, {tech_id, i})
        end

    end
    
    ::continue::

end

for i,v in ipairs(to_add) do

    local tech = v[1]
    local pack = v[2]

    log("Added "..pack.." to "..tech)

    data.raw.technology[tech].unit.ingredients = table.deepcopy(data.raw.technology[tech].unit.ingredients)
    table.insert(data.raw.technology[tech].unit.ingredients, {pack, 1})
    
end

-- Remove prerequisite

for index, tech in pairs(data.raw.technology) do
    if tech.prerequisites then
        local prerequisitesToRemove = {}
        for i, prereq in ipairs(tech.prerequisites) do
            -- Checking if the prerequisite name starts with "automation-science-pack"
            if string.sub(prereq, 1, string.len("automation-science-pack")) == "automation-science-pack" then
                table.insert(prerequisitesToRemove, prereq)
            end
            if string.sub(prereq, 1, string.len("kr-basic-fluid-handling")) == "kr-basic-fluid-handling" then
                table.insert(prerequisitesToRemove, prereq)
            end
            if string.sub(prereq, 1, string.len("kr-steam-engine")) == "kr-steam-engine" then
                table.insert(prerequisitesToRemove, prereq)
            end
            if string.sub(prereq, 1, string.len("kr-advanced-lab")) == "kr-advanced-lab" then
                table.insert(prerequisitesToRemove, prereq)
            end
            if string.sub(prereq, 1, string.len("kr-singularity-lab")) == "kr-singularity-lab" then
                table.insert(prerequisitesToRemove, prereq) 
            end
        end
        -- Remove the identified prerequisites
        for _, prereqToRemove in ipairs(prerequisitesToRemove) do
            remove_prerequisite(index, prereqToRemove)
        end
    end
end


for index, tech in pairs(data.raw.technology) do
    if tech.prerequisites then
        local prerequisitesToRemove = {}
        for i, prereq in ipairs(tech.prerequisites) do
            -- Checking if the prerequisite name starts with "automation-science-pack"
            if string.sub(prereq, 1, string.len("kr-advanced-tech-card")) == "kr-advanced-tech-card" then
                table.insert(prerequisitesToRemove, prereq)
            end         
        end
        -- Remove the identified prerequisites
        for _, prereqToRemove in ipairs(prerequisitesToRemove) do
            swap_prerequisites(index, prereqToRemove, modprefix.."moon-exploration")
        end
    end
end
