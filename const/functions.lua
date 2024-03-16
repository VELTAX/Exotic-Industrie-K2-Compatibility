-- commonly used functions for the mod

function endswith(str,suf) return str:sub(-string.len(suf)) == suf end
function startswith(text, prefix) return text:find(prefix, 1, true) == 1 end
function contains(s, word) return s:find(word, 1, true) ~= nil end
function sb(obj) error(serpent.block(obj)) end

--====================================================================================================
--FUNCTIONS
--====================================================================================================

function keys(tab)
  local keyset={}
  local n=0

  for k,v in pairs(tab) do
    n=n+1
    keyset[n]=k
  end
  return keyset
end

function clean_nils(t)
  local ans = {}
  for _,v in pairs(t) do
    ans[ #ans+1 ] = v
  end
  return ans
end

function table_contains_value(table_in, value)
    for i,v in pairs(table_in) do
        if v == value then
            return true
        end
    end
    return false
end

-- emulate switch-case in Lua for checking given string with a list of strings
-- retruns the matched element of the switch_table or nil if no match was found
-- switch_table = { ["string_condition"] = return vale, ... }

function switch_string(switch_table, string)
    
    -- retrun if no switch_table is given or no string is given
    if not switch_table or not string then
        return nil
    end

    -- loop over switch_table and check if string is in it
    for i,v in pairs(switch_table) do
        if string == i then
            return v
        end
    end

    -- return nil if no match was found
    return nil
end


-- count how many keys are in a table
function getn(table_in)
    local count = 0
    for _,_ in pairs(table_in) do
        count = count + 1
    end
    return count
end

--RECIPE RELATED
------------------------------------------------------------------------------------------------------



function recipe_remove_product(recipe, product)
  if not data.raw.recipe[recipe].main_product then return end 
  if data.raw.recipe[recipe].main_product == product then return end

  if data.raw.recipe[recipe].normal and data.raw.recipe[recipe].normal.results then
    for i,v in pairs(data.raw.recipe[recipe].normal.results) do
      if v[1] == product then
        table.remove(data.raw.recipe[recipe].normal.results, i)
      elseif v.name and v.name == product then 
        table.remove(data.raw.recipe[recipe].normal.results, i)
      end
    end
  end

  if data.raw.recipe[recipe].expensive and data.raw.recipe[recipe].expensive.results then
    for i,v in pairs(data.raw.recipe[recipe].expensive.results) do
      if v[1] == product then
        table.remove(data.raw.recipe[recipe].expensive.results, i)
      elseif v.name and v.name == product then 
        table.remove(data.raw.recipe[recipe].expensive.results, i)
      end
    end
  end

  if data.raw.recipe[recipe].results then
    for i,v in pairs(data.raw.recipe[recipe].results) do
      if v[1] == product then
        table.remove(data.raw.recipe[recipe].results, i)
      elseif v.name and v.name == product then 
        table.remove(data.raw.recipe[recipe].results, i)
      end
    end
  end  
end


function recipe_swap_output(recipe, old_ingredient, new_ingredient)
  if data.raw.recipe[recipe].main_product == old_ingredient then
    data.raw.recipe[recipe].main_product = new_ingredient
  end

  if data.raw.recipe[recipe].normal and data.raw.recipe[recipe].normal.results then
    for i,v in pairs(data.raw.recipe[recipe].normal.results) do
      if v[1] == old_ingredient then
        data.raw.recipe[recipe].normal.results[i][1] = new_ingredient
      elseif v.name and v.name == old_ingredient then 
        data.raw.recipe[recipe].normal.results[i].name = new_ingredient
      end
    end
  end

  if data.raw.recipe[recipe].expensive and data.raw.recipe[recipe].expensive.results then
    for i,v in pairs(data.raw.recipe[recipe].expensive.results) do
      if v[1] == old_ingredient then
        data.raw.recipe[recipe].expensive.results[i][1] = new_ingredient
      elseif v.name and v.name == old_ingredient then 
        data.raw.recipe[recipe].expensive.results[i].name = new_ingredient
      end
    end
  end

  if data.raw.recipe[recipe].results then
    for i,v in pairs(data.raw.recipe[recipe].results) do
      if v[1] == old_ingredient then
        data.raw.recipe[recipe].results[i][1] = new_ingredient
      elseif v.name and v.name == old_ingredient then 
        data.raw.recipe[recipe].results[i].name = new_ingredient
      end
    end
  end  
  
end

-- change ingredient in a recipe for another
function recipe_swap(recipe, old_ingredient, new_ingredient, amount)
    -- return if recipe or old_ingredient or new_ingredient is not given
    if not recipe or not old_ingredient or not new_ingredient then
        return
    end

    -- test if recipe exists in data.raw.recipe
    if not data.raw.recipe[recipe] then
        error("recipe "..recipe.." does not exist in data.raw.recipe")
        return
    end

    recipe_swap_output(recipe, old_ingredient, new_ingredient)

    -- check if amount is given
    if not amount then
        
        -- if we got an amount of old_ingredient in the recipe
        -- set amount to that amount
        if data.raw.recipe[recipe].normal then
            for i,v in pairs(data.raw.recipe[recipe].normal.ingredients) do
                if v[1] == old_ingredient then amount = v[2] --end
                elseif v.name and v.name == old_ingredient then amount = v.amount end
            end
        else
            for i,v in pairs(data.raw.recipe[recipe].ingredients) do
                if v[1] == old_ingredient then amount = v[2] --end
                elseif v.name and v.name == old_ingredient then amount = v.amount end
            end
        end

        -- if amount is still nil, set it to 1
        if not amount then
            amount = 1
        end
    end

    -- check if there is a normal/expensive version of the recipe
    if data.raw.recipe[recipe].normal then

        -- loop over all ingredients of the recipe
        for i,v in pairs(data.raw.recipe[recipe].normal.ingredients) do

            -- if ingredient is found, replace it
            -- here first index is ingredient name, second index is amount
            if v[1] == old_ingredient then
                data.raw.recipe[recipe].normal.ingredients[i][1] = new_ingredient
                data.raw.recipe[recipe].normal.ingredients[i][2] = amount
            -- end

            elseif v.name and v.name == old_ingredient then 
                data.raw.recipe[recipe].normal.ingredients[i].name = new_ingredient
                data.raw.recipe[recipe].normal.ingredients[i].amount = amount
                fix_recipe(recipe, "normal")
            end

        end

        if not data.raw.recipe[recipe].expensive then
            return
        end

        -- loop over all ingredients of the recipe
        for i,v in pairs(data.raw.recipe[recipe].expensive.ingredients) do

            -- if ingredient is found, replace it
            -- here first index is ingredient name, second index is amount
            if v[1] == old_ingredient then
                data.raw.recipe[recipe].expensive.ingredients[i][1] = new_ingredient
                data.raw.recipe[recipe].expensive.ingredients[i][2] = amount
            -- end

            elseif v.name and v.name == old_ingredient then 
                data.raw.recipe[recipe].expensive.ingredients[i].name = new_ingredient
                data.raw.recipe[recipe].expensive.ingredients[i].amount = amount
                fix_recipe(recipe, "normal")
            end
            
            fix_recipe(recipe, "expensive")
        end
    else
        -- loop over all ingredients of the recipe
        for i,v in pairs(data.raw.recipe[recipe].ingredients) do

            -- if ingredient is found, replace it
            -- here first index is ingredient name, second index is amount
            if v[1] == old_ingredient then
                data.raw.recipe[recipe].ingredients[i][1] = new_ingredient
                data.raw.recipe[recipe].ingredients[i][2] = amount
            -- end

            elseif v.name and v.name == old_ingredient then 
              data.raw.recipe[recipe].ingredients[i].name = new_ingredient
              data.raw.recipe[recipe].ingredients[i].amount = amount
            end

            fix_recipe(recipe, nil)
        end
    end
end


-- fix recipes for multiple ingredients
function fix_recipe(recipe, mode)
    -- look if an ingredient is multiple times in the recipe, if so, add the amounts
    local ingredients = {}
    if not mode then
        if not data.raw.recipe[recipe].ingredients then
            return
        end

        if not data.raw.recipe[recipe].ingredients[1] then
            return
        end
        ingredients = data.raw.recipe[recipe].ingredients
    end

    if mode == "normal" then
        if not data.raw.recipe[recipe].normal then
            return
        end

        if not data.raw.recipe[recipe].normal.ingredients then
            return
        end

        if not data.raw.recipe[recipe].normal.ingredients[1] then
            return
        end
        ingredients = data.raw.recipe[recipe].normal.ingredients
    end

    if mode == "expensive" then
        if not data.raw.recipe[recipe].expensive then
            return
        end

        if not data.raw.recipe[recipe].expensive.ingredients then
            return
        end

        if not data.raw.recipe[recipe].expensive.ingredients[1] then
            return
        end
        ingredients = data.raw.recipe[recipe].expensive.ingredients
    end

    -- loop over all ingredients
    for i,v in ipairs(ingredients) do
        local total_amount = v[2] or v["amount"]
        for j,x in ipairs(ingredients) do
            -- exclude same index
            if i ~= j then

                -- if is entry for the same ingredient
                if (v["name"] == x["name"] and v["name"]) or (v[1] == x[1] and v[1]) then
                    if x["amount"] then
                        total_amount = total_amount + x["amount"]
                    else
                        total_amount = total_amount + x[2]
                    end
                    
                    if not mode then
                        table.remove(data.raw.recipe[recipe].ingredients, j)
                    end

                    if mode == "normal" then
                        table.remove(data.raw.recipe[recipe].normal.ingredients, j)
                    end

                    if mode == "expensive" then
                        table.remove(data.raw.recipe[recipe].expensive.ingredients, j)
                    end
                end
            end
        end
        if v[2] then
            v[2] = total_amount
        else
            v["amount"] = total_amount
        end
    end

end

-- add new ingredient in recipe
function recipe_add_ingredient(recipe, ingredient, amount)
    -- amount is optional if not give default to 1
    if not amount then
        amount = 1
    end

    -- test if recipe exists in data.raw.recipe
    if not data.raw.recipe[recipe] then
        error("recipe "..recipe.." does not exist in data.raw.recipe")
        return
    end

    -- add ingredient to recipe
    table.insert(data.raw.recipe[recipe].ingredients, {ingredient, amount})
end


-- remove ingredient from recipe
function recipe_remove_ingredient(recipe, ingredient)
    -- test if recipe exists in data.raw.recipe
    if not data.raw.recipe[recipe] then
        error("recipe "..recipe.." does not exist in data.raw.recipe")
        return
    end

    -- check if there is a normal/expensive version of the recipe
    if data.raw.recipe[recipe].normal then
        -- loop over all ingredients of the recipe
        for i,v in pairs(data.raw.recipe[recipe].normal.ingredients) do
        
            -- if ingredient is found, remove it
            -- here first index is ingredient name, second index is amount
            if v[1] == ingredient then
                table.remove(data.raw.recipe[recipe].normal.ingredients, i)
            elseif v.name and v.name == ingredient then 
                table.remove(data.raw.recipe[recipe].normal.ingredients, i)
            end
            
        end

        -- loop over all ingredients of the recipe
        for i,v in pairs(data.raw.recipe[recipe].expensive.ingredients) do
        
            -- if ingredient is found, remove it
            -- here first index is ingredient name, second index is amount
            if v[1] == ingredient then
                table.remove(data.raw.recipe[recipe].expensive.ingredients, i)
            elseif v.name and v.name == ingredient then 
                table.remove(data.raw.recipe[recipe].expensive.ingredients, i)
            end
        end
    else
        -- loop over all ingredients of the recipe
        for i,v in pairs(data.raw.recipe[recipe].ingredients) do

            -- if ingredient is found, remove it
            -- here first index is ingredient name, second index is amount
            if v[1] == ingredient then
                table.remove(data.raw.recipe[recipe].ingredients, i)
            elseif v.name and v.name == ingredient then 
                table.remove(data.raw.recipe[recipe].ingredients, i)
            end
        end
    end
end


-- set a completly new set of ingredients for recipe
function recipe_new_ingredients(recipe, table_in)
    -- test if recipe exists in data.raw.recipe
    if not data.raw.recipe[recipe] then
        error("recipe "..recipe.." does not exist in data.raw.recipe")
        return
    end

    -- check if there are normal/expensive variants of the recipe
    if data.raw.recipe[recipe].normal and data.raw.recipe[recipe].expensive then

        -- set normal ingredients
        data.raw.recipe[recipe].normal.ingredients = table_in
        -- set expensive ingredients
        data.raw.recipe[recipe].expensive.ingredients = table_in
    else
        -- set ingredients
        data.raw.recipe[recipe].ingredients = table_in
    end
end


function recipe_new_products(recipe, table_out)
    -- test if recipe exists in data.raw.recipe
    if not data.raw.recipe[recipe] then
        error("recipe "..recipe.." does not exist in data.raw.recipe")
        return
    end

    if data.raw.recipe[recipe].normal and data.raw.recipe[recipe].expensive then
        data.raw.recipe[recipe].normal.results = table_out
        data.raw.recipe[recipe].expensive.results = table_out
    else
        data.raw.recipe[recipe].results = table_out
        data.raw.recipe[recipe].result = nil
        data.raw.recipe[recipe].result_count = nil
        data.raw.recipe[recipe] = clean_nils(data.raw.recipe[recipe])
    end
end


function disable_entity(entcat,entname)
  data.raw[entcat][entname] = nil
  data.raw['item'][entname] = nil
  data.raw['recipe'][entname] = nil
end


--TECH RELATED
------------------------------------------------------------------------------------------------------

-- add new prerequisites for tech
function add_prerequisite(tech, prerequisite)
    -- check if tech exists in data.raw.technology
    if not data.raw.technology[tech] then
        error("tech "..tech.." does not exist in data.raw.technology")
        return
    end

    -- if this tech has no prerequisites, create an empty table
    if not data.raw.technology[tech].prerequisites then
        data.raw.technology[tech].prerequisites = {}
    end

    -- check if prerequisite is already in tech
    for i,v in ipairs(data.raw.technology[tech].prerequisites) do
        if v == prerequisite then
            log("tech "..tech.." already has prerequisite "..prerequisite..", skipping...")
            return
        end
    end

    -- add prerequisite to tech
    table.insert(data.raw.technology[tech].prerequisites, prerequisite)
end

-- remove prerequisite from tech
function remove_prerequisite(tech, prerequisite)
    -- check if tech exists in data.raw.technology
    if not data.raw.technology[tech] then
        error("tech "..tech.." does not exist in data.raw.technology")
        return
    end

    -- loop over all prerequisites of the tech
    for i,v in ipairs(data.raw.technology[tech].prerequisites) do

        -- if prerequisite is found, remove it
        if v == prerequisite then
            table.remove(data.raw.technology[tech].prerequisites, i)
        end
    end
end

-- remove a unlock recipe effect from tech
function swap_prerequisites(tech, to_remove, to_add)
  remove_prerequisite(tech, to_remove)
  add_prerequisite(tech, to_add)
end


-- remove a unlock recipe effect from tech
function remove_unlock_recipe(tech, recipe)
    -- check if tech exists in data.raw.technology
    if not data.raw.technology[tech] then
        error("tech "..tech.." does not exist in data.raw.technology")
        return
    end

    -- loop over all effects of the tech
    for i,v in ipairs(data.raw.technology[tech].effects) do

        -- if effect is found, remove it
        if v.type == "unlock-recipe" and v.recipe == recipe then
            table.remove(data.raw.technology[tech].effects, i)
        end
    end
end


function add_unlock_recipe(tech, recipe)
    -- check if tech exists in data.raw.technology
    if not data.raw.technology[tech] then
        error("tech "..tech.." does not exist in data.raw.technology")
        return
    end

    table.insert(data.raw.technology[tech].effects,{type="unlock-recipe",recipe=recipe})

end

function disable_tech(tech)
  -- check if tech exists in data.raw.technology
  if not data.raw.technology[tech] then
      error("tech "..tech.." does not exist in data.raw.technology")
      return
  end

  data.raw.technology[tech].enabled = false
  
end

--====================================================================================================
--GRAPHICS FUNCTIONS
--====================================================================================================

-- get path of 64x64 empty sprite from graphics mod
function empty_sprite(size)
    size = size or 64

    if size == 64 then
        return ei_graphics_path.."graphics/64_empty.png"
    end

    if size == 128 then
        return ei_graphics_path.."graphics/128_empty.png"
    end
    
    if size == 256 then
        return ei_graphics_path.."graphics/256_empty.png"
    end

    return ei_graphics_path.."graphics/64_empty.png"
end

-- from base factorio
function make_4way_animation_from_spritesheet(animation)
    local function make_animation_layer(idx, anim)
      local start_frame = (anim.frame_count or 1) * idx
      local x = 0
      local y = 0
      if anim.line_length then
        y = anim.height * math.floor(start_frame / (anim.line_length or 1))
      else
        x = idx * anim.width
      end
      return
      {
        filename = anim.filename,
        priority = anim.priority or "high",
        flags = anim.flags,
        x = x,
        y = y,
        width = anim.width,
        height = anim.height,
        frame_count = anim.frame_count or 1,
        line_length = anim.line_length,
        repeat_count = anim.repeat_count,
        shift = anim.shift,
        draw_as_shadow = anim.draw_as_shadow,
        force_hr_shadow = anim.force_hr_shadow,
        apply_runtime_tint = anim.apply_runtime_tint,
        animation_speed = anim.animation_speed,
        scale = anim.scale or 1,
        tint = anim.tint,
        blend_mode = anim.blend_mode
      }
    end
  
    local function make_animation_layer_with_hr_version(idx, anim)
      local anim_parameters = make_animation_layer(idx, anim)
      if anim.hr_version and anim.hr_version.filename then
        anim_parameters.hr_version = make_animation_layer(idx, anim.hr_version)
      end
      return anim_parameters
    end
  
    local function make_animation(idx)
      if animation.layers then
        local tab = { layers = {} }
        for k,v in ipairs(animation.layers) do
          table.insert(tab.layers, make_animation_layer_with_hr_version(idx, v))
        end
        return tab
      else
        return make_animation_layer_with_hr_version(idx, animation)
      end
    end
  
    return
    {
      north = make_animation(0),
      east = make_animation(1),
      south = make_animation(2),
      west = make_animation(3)
    }
end

function make_circuit_connector(Dx, Dy)

    local circuit_wire_connection_point = {
        shadow = {
            green = {0.671875+Dx, 0.609375+Dy},
            red = {0.890625+Dx, 0.5625+Dy}
        },
        wire = {
            green = {0.453125+Dx, 0.453125+Dy},
            red = {0.390625+Dx, 0.21875+Dy}
        }
    }

    local circuit_connector_sprites = {
        blue_led_light_offset = {0.125+Dx, 0.46875+Dy},
        connector_main = {
          filename = "__base__/graphics/entity/circuit-connector/hr-ccm-universal-04a-base-sequence.png",
          height = 50,
          priority = "low",
          scale = 0.5,
          shift = {
            0.09375+Dx,
            0.203125+Dy
          },
          width = 52,
          x = 104,
          y = 150
        },
        connector_shadow = {
          draw_as_shadow = true,
          filename = "__base__/graphics/entity/circuit-connector/hr-ccm-universal-04b-base-shadow-sequence.png",
          height = 46,
          priority = "low",
          scale = 0.5,
          shift = {
            0.3125+Dx,
            0.3125+Dy
          },
          width = 62,
          x = 124,
          y = 138
        },
        led_blue = {
          draw_as_glow = true,
          filename = "__base__/graphics/entity/circuit-connector/hr-ccm-universal-04e-blue-LED-on-sequence.png",
          height = 60,
          priority = "low",
          scale = 0.5,
          shift = {
            0.09375+Dx,
            0.171875+Dy
          },
          width = 60,
          x = 120,
          y = 180
        },
        led_blue_off = {
          filename = "__base__/graphics/entity/circuit-connector/hr-ccm-universal-04f-blue-LED-off-sequence.png",
          height = 44,
          priority = "low",
          scale = 0.5,
          shift = {
            0.09375+Dx,
            0.171875+Dy
          },
          width = 46,
          x = 92,
          y = 132
        },
        led_green = {
          draw_as_glow = true,
          filename = "__base__/graphics/entity/circuit-connector/hr-ccm-universal-04h-green-LED-sequence.png",
          height = 46,
          priority = "low",
          scale = 0.5,
          shift = {
            0.09375+Dx,
            0.171875+Dy
          },
          width = 48,
          x = 96,
          y = 138
        },
        led_light = {
          intensity = 0,
          size = 0.9
        },
        led_red = {
          draw_as_glow = true,
          filename = "__base__/graphics/entity/circuit-connector/hr-ccm-universal-04i-red-LED-sequence.png",
          height = 46,
          priority = "low",
          scale = 0.5,
          shift = {
            0.09375+Dx,
            0.171875+Dy
          },
          width = 48,
          x = 96,
          y = 138
        },
        red_green_led_light_offset = {
          0.109375+Dx,
          0.359375+Dy
        },
        wire_pins = {
          filename = "__base__/graphics/entity/circuit-connector/hr-ccm-universal-04c-wire-sequence.png",
          height = 58,
          priority = "low",
          scale = 0.5,
          shift = {
            0.09375+Dx,
            0.171875+Dy
          },
          width = 62,
          x = 124,
          y = 174
        },
        wire_pins_shadow = {
          draw_as_shadow = true,
          filename = "__base__/graphics/entity/circuit-connector/hr-ccm-universal-04d-wire-shadow-sequence.png",
          height = 54,
          priority = "low",
          scale = 0.5,
          shift = {
            0.25+Dx,
            0.296875+Dy
          },
          width = 70,
          x = 140,
          y = 162
        }
    }


    return {
        circuit_wire_connection_point,
        circuit_connector_sprites
    }

end

return ei_lib