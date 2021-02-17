--|| SERVICES ||--
local UIS = game:GetService("UserInputService")
local Storage = game:GetService("ReplicatedStorage")
local camera = game.Workspace.CurrentCamera

--|| DEFAULT CONSTANTS ||--
local fovDefault = { FieldOfView = 70 }
local normalSpeed = 8

--|| PLAYER VARIABLES ||--
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Root = Character:WaitForChild("HumanoidRootPart")


--|| SPRINT VARIABLES ||--
local sprintProperties = {
	key = Enum.KeyCode.LeftShift,
	speed = 35
}

local sprintFov = { FieldOfView = 70 + (sprintProperties.speed/4) }
local tSprintStart = game.TweenService:Create(camera, TweenInfo.new(0.4, Enum.EasingStyle.Sine), sprintFov)
local tSprintEnd = game.TweenService:Create(camera, TweenInfo.new(0.4, Enum.EasingStyle.Sine), fovDefault)

local sprintTrack = Humanoid:LoadAnimation(Storage.Animations.Sprint)

--|| DASH VARIABLES ||--
local dashProperties = {
	frontKey = Enum.KeyCode.W,
	backKey = Enum.KeyCode.S,
	leftKey = Enum.KeyCode.A,
	rightKey = Enum.KeyCode.D,
	
	lastW = tick(),
	lastS = tick(),
	lastA = tick(),
	lastD = tick(),
	
	tapSpeed = 0.3,
	cooldown = 2,
	velocity = 175
}

--|| DASH ANIMATIONS ||--
local frontDashTrack = Humanoid:LoadAnimation(Storage.Animations.FrontDash)		-- dash animation object
local backDashTrack = Humanoid:LoadAnimation(Storage.Animations.BackDash)
local leftDashTrack = Humanoid:LoadAnimation(Storage.Animations.LeftDash)
local rightDashTrack = Humanoid:LoadAnimation(Storage.Animations.RightDash)

local dashFov = { FieldOfView = 70 + (dashProperties.velocity / 11)}	-- camera FOV changes when player dashes
local dashCamResetTime = .5									-- time before camera resets back to original
local tDashStart = game.TweenService:Create(camera, TweenInfo.new(0.4, Enum.EasingStyle.Sine), dashFov)
local tDashEnd = tSprintEnd

--|| DODGE VARIABLES ||--
local dodgeKey = Enum.KeyCode.E

--|| FUNCTIONS ||--
local function playDashAnimations(direction)
	if direction == "front" then
		frontDashTrack:Play()		-- animation
	elseif direction == "back" then
		backDashTrack:Play()
	elseif direction == "left" then
		leftDashTrack:Play()
	elseif direction == "right" then
		rightDashTrack:Play()
	end
	tDashStart:Play()		-- camera FOV tween
end

can_dash = true

--|| EVENTS ||--

-- On player respawn, rebind character variables
Player.CharacterAdded:Connect(function(char)
	Character = Player.Character or Player.CharacterAdded:Wait()
	Humanoid = Character:WaitForChild("Humanoid")
	Root = Character:WaitForChild("HumanoidRootPart")
	sprintTrack = Humanoid:LoadAnimation(Storage.Animations.Sprint)			-- sprint animation
	frontDashTrack = Humanoid:LoadAnimation(Storage.Animations.FrontDash)		-- dash animation object
	backDashTrack = Humanoid:LoadAnimation(Storage.Animations.BackDash)
	leftDashTrack = Humanoid:LoadAnimation(Storage.Animations.LeftDash)
	rightDashTrack = Humanoid:LoadAnimation(Storage.Animations.RightDash)
	Humanoid.WalkSpeed = normalSpeed
end)


UIS.InputBegan:Connect(function(input, processed)
	if processed then return end
	
	-- Input Events
	if input.UserInputType == Enum.UserInputType.Keyboard then
		-- Sprint
		if input.KeyCode == sprintProperties.key then
			Humanoid.WalkSpeed = sprintProperties.speed
			tSprintStart:Play()		-- Camera FOV
			
		-- Dash
		-- Check dash cooldown
		elseif can_dash then
			-- front dash
			if input.KeyCode == dashProperties.frontKey then
				-- double tap check
				if tick() - dashProperties.lastW <= dashProperties.tapSpeed then
					Root.Velocity = Root.CFrame.lookVector * dashProperties.velocity
					can_dash = false
					-- play dash animation and camera FOV
					playDashAnimations("front")
					wait(dashCamResetTime)
					-- if in sprint mode, return to sprint FOV
					if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
						tSprintStart:Play()
					else
						tDashEnd:Play()
					end

					-- wait for cooldown
					wait(dashProperties.cooldown)
					can_dash = true
				end
				dashProperties.lastW = tick()
				
			-- back dash
			elseif input.KeyCode == dashProperties.backKey then
				-- double tap check
				if tick() - dashProperties.lastS <= dashProperties.tapSpeed then
					-- back dash process	
					Root.Velocity = Root.CFrame.lookVector * -dashProperties.velocity
					can_dash = false
					-- play dash animation and camera FOV
					playDashAnimations("back")
					wait(dashCamResetTime)
					-- if in sprint mode, return to sprint FOV
					if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
						tSprintStart:Play()
					else
						tDashEnd:Play()
					end
					-- wait for cooldown
					wait(dashProperties.cooldown)
					can_dash = true
				end
				dashProperties.lastS = tick()
				
			-- left dash
			elseif input.KeyCode == dashProperties.leftKey then
				if tick() - dashProperties.lastA <= dashProperties.tapSpeed then
					Root.Velocity = Root.CFrame.RightVector * -dashProperties.velocity
					can_dash = false
					-- play dash animations and camera FOV
					playDashAnimations("left")
					wait(dashCamResetTime)
					-- if in sprint mode, return to sprint FOV
					if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
						tSprintStart:Play()
					else
						tDashEnd:Play()
					end
					-- wait for cooldown
					wait(dashProperties.cooldown)
					can_dash = true
				end
				dashProperties.lastA = tick()
				
			-- right dash
			elseif input.KeyCode == dashProperties.rightKey then
				if tick() - dashProperties.lastD <= dashProperties.tapSpeed then
					Root.Velocity = Root.CFrame.RightVector * dashProperties.velocity
					can_dash = false
					-- play dash animations and camera FOV
					playDashAnimations("right")
					wait(dashCamResetTime)
					-- if in sprint mode, return to sprint FOV
					if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
						tSprintStart:Play()
					else
						tDashEnd:Play()
					end
					-- wait for cooldown
					wait(dashProperties.cooldown)
					can_dash = true
				end
				dashProperties.lastD = tick()
			end
			
		-- Dodge
		elseif input.KeyCode == dodgeKey then
			-- Dodge Process Here
		end
		
	end
end)


UIS.InputEnded:Connect(function(input)
	if input.KeyCode == sprintProperties.key then
		Humanoid.WalkSpeed = normalSpeed
		-- If NOT dashing, reset camera FOV
		if can_dash then
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
