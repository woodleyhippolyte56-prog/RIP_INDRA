--[[
	WOOD HUB - Main Farm
	AutoFarm de mobs
	Script original creado para tu simulador (BETA)
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

-- CONFIG
local AUTO_FARM = false
local MOBS_FOLDER = workspace:WaitForChild("Mobs")
local ATTACK_DISTANCE = 5
local DAMAGE = 15
local ATTACK_COOLDOWN = 0.4

-- FUNCIÓN: buscar mob vivo
local function getNearestMob()
	local closestMob = nil
	local shortestDistance = math.huge

	for _, mob in pairs(MOBS_FOLDER:GetChildren()) do
		local mobHumanoid = mob:FindFirstChild("Humanoid")
		local mobRoot = mob:FindFirstChild("HumanoidRootPart")

		if mobHumanoid and mobRoot and mobHumanoid.Health > 0 then
			local distance = (root.Position - mobRoot.Position).Magnitude
			if distance < shortestDistance then
				shortestDistance = distance
				closestMob = mob
			end
		end
	end

	return closestMob
end

-- LOOP PRINCIPAL AUTOFARM
task.spawn(function()
	while true do
		if AUTO_FARM then
			local mob = getNearestMob()

			if mob then
				local mobHumanoid = mob:FindFirstChild("Humanoid")
				local mobRoot = mob:FindFirstChild("HumanoidRootPart")

				if mobHumanoid and mobRoot then
					-- Moverse al mob
					root.CFrame = mobRoot.CFrame * CFrame.new(0, 0, -ATTACK_DISTANCE)

					-- Atacar
					mobHumanoid:TakeDamage(DAMAGE)
				end
			end
		end

		task.wait(ATTACK_COOLDOWN)
	end
end)

-- FUNCIÓN PÚBLICA PARA EL MENÚ
local function setAutoFarm(state)
	AUTO_FARM = state
	if AUTO_FARM then
		print("[WOOD HUB] AutoFarm ACTIVADO")
	else
		print("[WOOD HUB] AutoFarm DESACTIVADO")
	end
end

-- ATRIBUTO PARA GUI
player:SetAttribute("AutoFarm", false)

player:GetAttributeChangedSignal("AutoFarm"):Connect(function()
	setAutoFarm(player:GetAttribute("AutoFarm"))
end)
