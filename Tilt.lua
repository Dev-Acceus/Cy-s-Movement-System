-- Adjust based on how much you want character to tilt
local tiltDegree = 7

local plr = game.Players.LocalPlayer
repeat wait() until plr.Character and plr.Character:FindFirstChild("LowerTorso")
local lowerTorso = plr.Character:FindFirstChild("LowerTorso")
local uis = game:GetService("UserInputService")
local ts = game:GetService("TweenService")
local info = TweenInfo.new(
	.5,
	Enum.EasingStyle.Quad,
	Enum.EasingDirection.InOut
)

local a = false
local d = false

local goal1 = {C1 = lowerTorso.Root.C1*CFrame.Angles(0,0,math.rad(0))}
local goal2 = {C1 = lowerTorso.Root.C1*CFrame.Angles(0,0,math.rad(-tiltDegree))}
local goal3 = {C1 = lowerTorso.Root.C1*CFrame.Angles(0,0,math.rad(tiltDegree))}

uis.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.A then
		a = true
		if a == true and d == true then
			local tween = ts:Create(lowerTorso.Root, info, goal1)
			tween:Play()
		else
			local tween = ts:Create(lowerTorso.Root, info, goal2)
			tween:Play()
		end
	elseif input.KeyCode == Enum.KeyCode.D then
		d = true
		if a == true and d == true then
			local tween = ts:Create(lowerTorso.Root, info, goal1)
			tween:Play()
		else
			local tween = ts:Create(lowerTorso.Root, info, goal3)
			tween:Play()
		end
	end
end)

uis.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.A then
		a = false
		if d == false then
			local tween = ts:Create(lowerTorso.Root, info, goal1)
			tween:Play()
		else
			local tween = ts:Create(lowerTorso.Root, info, goal3)
			tween:Play()
		end
	elseif input.KeyCode == Enum.KeyCode.D then
		d = false
		if a == false then
			local tween = ts:Create(lowerTorso.Root, info, goal1)
			tween:Play()
		else
			local tween = ts:Create(lowerTorso.Root, info, goal2)
			tween:Play()
		end
	end
end)
