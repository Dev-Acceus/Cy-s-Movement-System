local Players = game:GetService("Players")
local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local camera = workspace.CurrentCamera
local player = Players.LocalPlayer

local cameraOffset = Vector3.new(2,2,8)

player.CharacterAdded:Connect(function(character)
	
	local humanoid = character:WaitForChild("Humanoid")
	local rootPart = character:WaitForChild("HumanoidRootPart")
	
	-- For camera angles, will be edited when we move our mouse
	-- Will be applied when we position our camera
	local cameraAngleX = 0
	local cameraAngleY = 0
	
	humanoid.AutoRotate = false
	
	-- Used to capture our mouse input
	local function playerInput(actionName, inputState, inputObject)
		if inputState == Enum.UserInputState.Change then
			-- Reduce camera angle from DeltaX
			-- Delta = how much the mouse has moved from a given frame
			cameraAngleX -= inputObject.Delta.X
			-- Clamp acts as a constraint for the rotation on the Y axis
			-- This avoids inverting the camera from the Y axis, which would make it up-side down
			cameraAngleY = math.clamp(cameraAngleY - inputObject.Delta.Y * 0.4, -75, 75)
		end
	end
	
	ContextActionService:BindAction("PlayerInput", playerInput, false, Enum.UserInputType.MouseMovement, Enum.UserInputType.Touch)

	RunService:BindToRenderStep("CameraUpdate", Enum.RenderPriority.Camera.Value, function()
		local startCFrame = CFrame.new(rootPart.CFrame.Position) * CFrame.Angles(0, math.rad(cameraAngleX), 0) * CFrame.Angles(math.rad(cameraAngleY), 0, 0)
		local cameraCFrame = startCFrame:PointToWorldSpace(cameraOffset)
		-- What camera is focusing on
		local cameraFocus = startCFrame:PointToWorldSpace(Vector3.new(cameraOffset.X, cameraOffset.Y, -100000))

		camera.CFrame = CFrame.lookAt(cameraCFrame, cameraFocus)
		
		-- Makes player focus on camera focus, body will ALWAYS track the camera
		-- Body will not be relatively edited by current camera angle
		local lookingCFrame = CFrame.lookAt(rootPart.Position, camera.CFrame:PointToWorldSpace(Vector3.new(0,0,-100000)))
		
		rootPart.CFrame = CFrame.fromMatrix(rootPart.Position, lookingCFrame.XVector, rootPart.CFrame.YVector)
	end)
	
end)

-- responsible for locking mouse in center and disable mouse icon
local function focusControl(actionName, inputState, inputObject)
	if inputState == Enum.UserInputState.Begin then
		camera.CameraType = Enum.CameraType.Scriptable
		
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
		UserInputService.MouseIconEnabled = false
		
		-- Unbind action so it cannot be run again
		ContextActionService:UnbindAction("FocusControl")
	end
end

--[[
Second parameter : Function
Third : global button = false
Succeeding parameters : Input (when player "focuses" on screen (e.g. clicks, taps etc))
]]
ContextActionService:BindAction("FocusControl", focusControl, false, Enum.UserInputType.MouseButton1, Enum.UserInputType.Touch, Enum.UserInputType.Focus)
