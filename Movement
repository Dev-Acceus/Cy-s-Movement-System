-- Services
local UIS = game:GetService("UserInputService")

-- Constants
local fovDefault = { FieldOfView = 70 }
local normalSpeed = 8

-- Player variables
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Root = Character:WaitForChild("HumanoidRootPart")


-- Sprint Variables
local sprintKey = Enum.KeyCode.LeftShift
local sprintSpeed = 35

local sprintFov = { FieldOfView = 70 + (sprintSpeed/4) }
local camera = game.Workspace.CurrentCamera
local tSprintStart = game.TweenService:Create(camera, TweenInfo.new(0.4, Enum.EasingStyle.Sine), sprintFov)
local tSprintEnd = game.TweenService:Create(camera, TweenInfo.new(0.4, Enum.EasingStyle.Sine), fovDefault)

local sprintAnimation = Instance.new("Animation")
sprintAnimation.AnimationId = "rbxassetid://6361709833"
local sprintTrack = Humanoid:LoadAnimation(sprintAnimation)

-- Dash Variables
local dashKey = Enum.KeyCode.Q
local can_dash = true
local dashCooldown = 2			-- time before player can dash again
local dashVelocity = 175
local dashAnimation = Instance.new("Animation")
dashAnimation.AnimationId = "rbxassetid://6385743643"
local dashTrack = Humanoid:LoadAnimation(dashAnimation)		-- dash animation object

local dashFov = { FieldOfView = 70 + (dashVelocity / 11)}	-- camera FOV changes when player dashes
local dashCamResetTime = .5									-- time before camera resets back to original
local tDashStart = game.TweenService:Create(camera, TweenInfo.new(0.4, Enum.EasingStyle.Sine), dashFov)
local tDashEnd = tSprintEnd

-- Dodge Variables
local dodgeKey = Enum.KeyCode.E

local function playDashAnimations()
	dashTrack:Play()		-- animation
	tDashStart:Play()		-- camera FOV tween
end


-- Events

-- On player respawns, rebind character variables
Player.CharacterAdded:Connect(function(char)
	Character = Player.Character or Player.CharacterAdded:Wait()
	Humanoid = Character:WaitForChild("Humanoid")
	Root = Character:WaitForChild("HumanoidRootPart")
	dashTrack = Humanoid:LoadAnimation(dashAnimation)		-- dash animation object
	Humanoid.WalkSpeed = normalSpeed
end)


UIS.InputBegan:Connect(function(input, processed)
	if processed then return end
	
	-- Input Events
	if input.UserInputType == Enum.UserInputType.Keyboard then
		-- Sprint
		if input.KeyCode == sprintKey then
			Humanoid.WalkSpeed = sprintSpeed
			tSprintStart:Play()		-- Camera FOV
			
		-- Dash
		elseif input.KeyCode == dashKey then
			-- Cooldown Check
			if can_dash then
				Root.Velocity = Root.CFrame.lookVector * dashVelocity
				can_dash = false
				-- play dash animation and camera FOV
				playDashAnimations()
				wait(dashCamResetTime)
				-- if in sprint mode, return to sprint FOV
				if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
					tSprintStart:Play()
				else
					tDashEnd:Play()
				end
				
				wait(dashCooldown)
				can_dash = true
			end
			
		-- Dodge
		elseif input.KeyCode == dodgeKey then
			-- Dodge Process Here
		end
	end
end)


UIS.InputEnded:Connect(function(input)
	if input.KeyCode == sprintKey then
		Humanoid.WalkSpeed = normalSpeed
		-- If NOT in middle of dash, reset camera FOV
		if not dashTrack.isPlaying then
			tSprintEnd:Play()
		end 
	end
end)


-- Sprint Animation
Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
	if Humanoid.WalkSpeed > normalSpeed then
		sprintTrack:Play()
	else
		sprintTrack:Stop()
	end
	
end)
