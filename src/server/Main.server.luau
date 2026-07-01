-- Runs on the SERVER. Gives every player a "Coins" leaderboard stat.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GameConfig = require(ReplicatedStorage.Shared.GameConfig)

local function onPlayerAdded(player: Player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local coins = Instance.new("IntValue")
	coins.Name = "Coins"
	coins.Value = GameConfig.STARTING_COINS
	coins.Parent = leaderstats

	print(player.Name .. " joined " .. GameConfig.GAME_NAME)
end

Players.PlayerAdded:Connect(onPlayerAdded)
