-- Detecta o Sea e carrega a parte certa
local placeId = game.PlaceId

if placeId == 2753915549 then
    -- Sea 1
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/blox_fruits_part1.lua"))()
elseif placeId == 4442272183 then
    -- Sea 2
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/blox_fruits_part2.lua"))()
elseif placeId == 7449423635 then
    -- Sea 3
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/blox_fruits_part3.lua"))()
end
