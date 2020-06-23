if mods["omnimatter_crystal"] then
  add_crystal("lithium-chloride", "Lithium Chloride")
  add_crystal("solid-calcium-sulfate", "Calcium Sulfate")
  add_crystal("thorium-ore", "Thorium")
  add_crystal("phosphorus-ore", "Phosphorus")
  add_crystal("solid-limestone", "Limestone")
  add_crystal("solid-sodium-carbonate", "Sodium Carbonate")
  add_crystal("osmium-ore", "Osmium")
  add_crystal("magnesium-ore","Magnesium")

  local oresList = {
    { ore = "clowns-ore1", name = "Adamantite",	 },
    { ore = "clowns-ore2", name = "Antitate",	   },
    { ore = "clowns-ore3", name = "Pro-Galena",	 },
    { ore = "clowns-ore4", name = "Orichalcite", },
    { ore = "clowns-ore5", name = "Phosphorite", },
    { ore = "clowns-ore6", name = "Sanguinate",	 },
    { ore = "clowns-ore7", name = "Elionagate",	 },
    { ore = "clowns-ore8", name = "Meta-Garnierite",	 },
    { ore = "clowns-ore9", name = "Nova-Leucoxene",	 },
  }
  local oresGrade = { "crushed", "chunk", "crystal", "pure" }

  local toAdd = {}
  for _,oreSet in pairs(oresList) do
    for _,gradeSet in pairs(oresGrade) do
      local baseName = oreSet.ore.."-"..gradeSet.."-processing"
      local base = data.raw.recipe[baseName]

      if not data.raw["item-subgroup"][base.subgroup.."-omnide"] then
        local cat = {
          type = "item-subgroup",
          name = base.subgroup.."-omnide",
          group = "omnicrystal",
          order = "aa",
        }
        toAdd[#toAdd+1]=cat
      end
      local ing = table.deepcopy(ingrediences_solvation(base))
      local res = table.deepcopy(results_solvation(base))
      local ic = salt_omnide_icon(oreSet.ore.."-"..gradeSet)

      toAdd[#toAdd+1] = {
        type = "recipe",
        name = oreSet.ore.."-"..gradeSet.."-salting",
        localised_name = {"recipe-name.clowns-omnide-salting", {"lookup."..gradeSet} , oreSet.name},
        localised_description = {"recipe-description.clowns-omnide-salting",  {"lookup."..gradeSet }, oreSet.name},
        category = "omniplant",
        subgroup = base.subgroup.."-omnide",
        enabled = false,
        ingredients = ing,
        order = "b[clownsore1-crushed]",
        icons = ic,
        icon_size=32,
        results = res,
        energy_required = 5,
      }
      if gradeSet=="crushed" then
        omni.lib.add_unlock_recipe("crystallology-1", oreSet.ore.."-"..gradeSet.."-salting")
      elseif gradeSet=="chunk" then
        omni.lib.add_unlock_recipe("crystallology-2", oreSet.ore.."-"..gradeSet.."-salting")
      elseif gradeSet=="crystal" then
        omni.lib.add_unlock_recipe("crystallology-3", oreSet.ore.."-"..gradeSet.."-salting")
      elseif gradeSet=="pure" then
        omni.lib.add_unlock_recipe("crystallology-4", oreSet.ore.."-"..gradeSet.."-salting")
      end
    end
  end
  --old additions list, where rec name is [ore.."-pure-processing"]
  local pureOresList = {"chrome", "osmium", "phosphorus", "platinum", "thorium","manganese","magnesium"}

  for _,ore in pairs(pureOresList) do
    local rec = data.raw.recipe[ore.."-pure-processing"]
    if rec then
      local gradeSet = get_grade_set(rec)
      if not data.raw["item-subgroup"][rec.subgroup.."-omnide"] then
        local cat = {
          type = "item-subgroup",
          name = rec.subgroup.."-omnide",
          group = "omnicrystal",
          order = "aa",
        }
        toAdd[#toAdd+1]=cat
      end
      local ing = table.deepcopy(ingrediences_solvation(rec))
      local res = table.deepcopy(results_solvation(rec))
      local ic = salt_omnide_icon(ore.."-ore")

      toAdd[#toAdd+1] = {
        type = "recipe",
        name = ore.."-pure-salting",
        localised_name = {"recipe-name.pure-omnide-salting", {"lookup."..ore}},
        localised_description = {"recipe-description.pure-omnide-salting", {"lookup."..ore}},
        category = "omniplant",
        subgroup = rec.subgroup.."-omnide",
        enabled = false,
        ingredients = ing,
        order = "b[clownsore1-crushed]",
        icons = ic,
        icon_size=32,
        results = res,
        energy_required = 5,
      }
      if gradeSet=="crushed" then
        omni.lib.add_unlock_recipe("crystallology-1", ore.."-pure-salting")
      elseif gradeSet=="chunk" then
        omni.lib.add_unlock_recipe("crystallology-2", ore.."-pure-salting")
      elseif gradeSet=="crystal" then
        omni.lib.add_unlock_recipe("crystallology-3", ore.."-pure-salting")
      elseif gradeSet=="pure" then
        omni.lib.add_unlock_recipe("crystallology-4", ore.."-pure-salting")
      elseif ore=="magnesium" then 
        omni.lib.add_unlock_recipe("crystallology-3", ore.."-pure-salting")
      end
    end
    data:extend(toAdd)
  end
  --new additions list where name is clowns-tier-mix#-processing
  toAdd={} --nil it out
  for i,tier in pairs(oresGrade) do --grade
    for j=1,10,1 do --number
      local rec = data.raw.recipe["clowns-"..tier.."-mix"..j.."-processing"]
      if rec then
        local gradeSet = tier
        if not data.raw["item-subgroup"][rec.subgroup.."-omnide"] then
          local cat = {
            type = "item-subgroup",
            name = rec.subgroup.."-omnide",
            group = "omnicrystal",
            order = "aa",
          }
          toAdd[#toAdd+1]=cat
        end
        --grab ore name from result
        local ing = table.deepcopy(ingrediences_solvation(rec))
        local res = table.deepcopy(results_solvation(rec))
        local ore = res[1].name or res[1][1]
        ore=string.sub(ore,1,-13)
        local ic = salt_omnide_icon(ore)

        toAdd[#toAdd+1] = {
          type = "recipe",
          name = "clowns-"..tier.."-mix"..j.."-pure-salting",
          localised_name = {"recipe-name.pure-omnide-salting", {"lookup."..ore}},
          localised_description = {"recipe-description.pure-omnide-salting", {"lookup."..ore}},
          category = "omniplant",
          subgroup = rec.subgroup.."-omnide",
          enabled = false,
          ingredients = ing,
          order = "b[clownsore1-crushed]",
          icons = ic,
          icon_size=32,
          results = res,
          energy_required = 5,
        }
        if tier=="crushed" then
          omni.lib.add_unlock_recipe("crystallology-1", "clowns-"..tier.."-mix"..j.."-pure-salting")
        elseif tier=="chunk" then
          omni.lib.add_unlock_recipe("crystallology-2", "clowns-"..tier.."-mix"..j.."-pure-salting")
        elseif tier=="crystal" then
          omni.lib.add_unlock_recipe("crystallology-3", "clowns-"..tier.."-mix"..j.."-pure-salting")
        elseif tier=="pure" then
          omni.lib.add_unlock_recipe("crystallology-4", "clowns-"..tier.."-mix"..j.."-pure-salting")
        end
        data:extend(toAdd)
      end
      if mods["angelsrefining"] and settings.startup["angels-salt-sorting"].value then
        for i, rec in pairs(data.raw.recipe) do
          if rec.category == "omniplant" and string.find(rec.name,"salting") then
            omni.lib.replace_recipe_ingredient(rec.name, "hydromnic-acid",{type = "item", name = "omni-catalyst", amount=1})
            rec.category = "ore-sorting"
          end
        end
      end
    end
  end
end