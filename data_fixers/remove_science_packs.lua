for z=1,3 do
  for index, tech in pairs(data.raw.technology) do
    if tech.unit.ingredients then
      for i, ingredient in ipairs(tech.unit.ingredients) do
        name = ingredient[1] or ingredient.name
        if name then

          if startswith(name,"basic-tech-card") then 
            table.remove(data.raw.technology[index].unit.ingredients, i) 
          end

          if startswith(name,"automation-science-pack") then 
            table.remove(data.raw.technology[index].unit.ingredients, i) 
          end

          if startswith(name,"logistic-science-pack") then 
            table.remove(data.raw.technology[index].unit.ingredients, i) 
          end

          if startswith(name,"military-science-pack") then 
            table.remove(data.raw.technology[index].unit.ingredients, i) 
          end

          if startswith(name,"chemical-science-pack") then 
            table.remove(data.raw.technology[index].unit.ingredients, i) 
          end     

          if startswith(name,"production-science-pack") then 
            table.remove(data.raw.technology[index].unit.ingredients, i) 
          end

          if startswith(name,"utility-science-pack") then 
            table.remove(data.raw.technology[index].unit.ingredients, i) 
          end

          if startswith(name,"space-science-pack") then 
            table.remove(data.raw.technology[index].unit.ingredients, i) 
          end

          if startswith(name,"advanced-tech-card") then 
            table.remove(data.raw.technology[index].unit.ingredients, i) 
          end

          if startswith(name,"space-science-pack") then 
            table.remove(data.raw.technology[index].unit.ingredients, i) 
          end
        end
      end
    end
  end
end