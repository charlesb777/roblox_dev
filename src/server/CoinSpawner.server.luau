-- Runs on the SERVER. Spawns a coin; touching it adds to your Coins stat.

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GameConfig = require(ReplicatedStorage.Shared.GameConfig)

local coin = Instance.new("Part")
coin.Name = "Coin"
coin.Shape = Enum.PartType.Ball
coin.Size = Vector3.new(3, 3, 3)
coin.Position = Vector3.new(0, 5, 0)
coin.Color = Color3.fromRGB(255, 215, 0)
coin.Material = Enum.Material.Neon
coin.Anchored = true
coin.CanCollide = false
coin.Parent = Workspace

local collected = false

coin.Touched:Connect(function(hit)
	if collected then return end

	local player = Players:GetPlayerFromCharacter(hit.Parent)
	if not player then return end

	local coins = player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Coins")
	if coins then
		collected = true
		coins.Value += GameConfig.COIN_VALUE
		print(player.Name .. " collected a coin! Total: " .. coins.Value)
		coin:Destroy()
	end
end)
