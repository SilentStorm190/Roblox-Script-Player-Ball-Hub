-- Player Ball Roblox Exploit Script
-- roll like a ball, or experience 0 gravity!
-- other features included





-- Code Before UI CODE

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local mouse = player:GetMouse()
local WalkSpeed
local JumpPower
local Noclipping = nil
local Clip

local ballActive = false
local originalGravity = Workspace.Gravity
local velocityVector = Vector3.new(0,0,0)
local radius = 2
local damping
local partBelowTime = 15

-- UI Flag Variables
local ballSpeed = 50
local ballFriction = 4
local gravity = 50
local bounce = 0
local jumpPower = 50
local physicsEnabled = true
local yaw = 180
local pitch = 90
local directionLock = false
local pushStopper = true
local fling = false

-- Sounds
local uiClickSound = Instance.new("Sound")
uiClickSound.SoundId = "rbxassetid://179235828"
uiClickSound.Volume = 1
uiClickSound.Parent = workspace

local uiToggleSound = Instance.new("Sound")
uiToggleSound.SoundId = "rbxassetid://452267918"
uiToggleSound.Volume = 1
uiToggleSound.Parent = workspace

local uiSlideSound = Instance.new("Sound")
uiSlideSound.SoundId = "rbxassetid://421058925"
uiSlideSound.Volume = 1
uiSlideSound.Parent = workspace

local hitSound = Instance.new("Sound")
hitSound.SoundId = "rbxassetid://2812417769"
hitSound.Volume = 1
hitSound.Parent = workspace

local rollSound = Instance.new("Sound")
rollSound.SoundId = "rbxassetid://3308152153"
rollSound.Volume = 0
rollSound.Parent = workspace
rollSound.Looped = true
rollSound:Play()

-- Kills Ragdolls
local function kill(target)
    local character = target:FindFirstAncestorOfClass("Model")

    if character and character ~= player.Character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local head = character:FindFirstChild("Head")

        if humanoid and head and humanoid.Health > 0 then
            humanoid:ChangeState(Enum.HumanoidStateType.Ragdoll)

            local root = character:FindFirstChild("HumanoidRootPart")
            if root then
                local force = Instance.new("BodyVelocity")
                force.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                force.P = 1e4
                force.Parent = root
            end

            humanoid.Health = 0
        end
    end
end

local function noclip()
    Clip = false
	wait(0.1)
	local function NoclipLoop()
		if Clip == false and player.Character ~= nil then
			for _, child in pairs(player.Character:GetDescendants()) do
				if child:IsA("BasePart") and child.CanCollide == true and child.Name ~= floatName then
					child.CanCollide = false
				end
			end
		end
	end
	Noclipping = RunService.Stepped:Connect(NoclipLoop)
end

local function clip()
    if Noclipping then
        Noclipping:Disconnect()
        Noclipping = nil
    end
    Clip = true

    if player.Character then
        for _, child in pairs(player.Character:GetDescendants()) do
            if child:IsA("BasePart") then
                child.CanCollide = true
            end
        end
    end
end

local function preset(type)
    ballSpeed = 50
    ballFriction = 4
    gravity = 50
    bounce = 0
    jumpPower = 50
    physicsEnabled = true
    yaw = 180
    pitch = 90
    directionLock = false
    pushStopper = true
    fling = false
    rootPart.AssemblyAngularVelocity = Vector3.new(0,0,0)
    clip()
    if type == 2 then
        bounce = 75
        jumpPower = 75
    elseif type == 3 then
        ballSpeed = 12
        ballFriction = 2
        gravity = 15
        jumpPower = 25
    elseif type == 4 then
        ballSpeed = 40
        ballFriction = 3
        physicsEnabled = false
        pushStopper = false
    elseif type == 5 then
        ballSpeed = 80
        ballFriction = 6
        pitch = 180
        physicsEnabled = false
        directionLock = true
    elseif type == 6 then
        ballSpeed = 80
        ballFriction = 6
        physicsEnabled = false
        directionLock = true
    elseif type == 7 then
        ballSpeed = 80
        ballFriction = 6
        physicsEnabled = false
        fling = true
    elseif type == 8 then
        ballSpeed = 80
        ballFriction = 6
        physicsEnabled = false
        noclip()
    end
    uiClickSound:Play()
end





-- UI CODE
-- From: https://github.com/Eazvy/UILibs/blob/main/Librarys/Dirt/Example

local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/dirt",true))()
local Table = {}
local window = Lib:CreateWindow("Player Ball Hub")

window:Section("                 Main")
window:Slider("Ball Speed",{location = Table, min = 0, max = 200, default = 50, precise = true, flag = "Ball Speed"},function()
    ballSpeed = Table["Ball Speed"]
    uiSlideSound:Play()
end)
window:Slider("Ball Friction",{location = Table, min = 0, max = 200, default = 4, precise = true, flag = "Ball Friction"},function()
    ballFriction = Table["Ball Friction"]
    uiSlideSound:Play()
end)
local onToggle
window:Bind("Ball KeyBind",{location = Table, flag = "KeyBind", default = Enum.KeyCode.Z}, function()
    onToggle()
end)

window:Section("               Physics")
window:Slider("Gravity",{location = Table, min = 0, max = 200, default = 50, precise = true, flag = "Gravity"},function()
    gravity = Table["Gravity"]
    uiSlideSound:Play()
end)
window:Slider("Bounce",{location = Table, min = 0, max = 100, default = 0, precise = true, flag = "Bounce"},function()
    bounce = Table["Bounce"]
    uiSlideSound:Play()
end)
window:Slider("Jump Power",{location = Table, min = 0, max = 200, default = 50, precise = true, flag = "Jump Power"},function()
    jumpPower = Table["Jump Power"]
    uiSlideSound:Play()
end)
window:Toggle("Physics Enabled?",{location = Table, flag = "Physics Enabled", default = true},function()
    physicsEnabled = Table["Physics Enabled"]
    uiToggleSound:Play()
end)

window:Section("        Direction Lock")
window:Slider("Yaw",{location = Table, min = 0, max = 360, default = 180, precise = true, flag = "Yaw"},function()
    yaw = Table["Yaw"]
    uiSlideSound:Play()
end)
window:Slider("Pitch",{location = Table, min = 0, max = 360, default = 90, precise = true, flag = "Pitch"},function()
    pitch = Table["Pitch"]
    uiSlideSound:Play()
end)
window:Toggle("Direction Lock?",{location = Table, flag = "Direction Lock"},function()
    directionLock = Table["Direction Lock"]
    uiToggleSound:Play()
end)

window:Section("                 Other")
window:Toggle("Fling?",{location = Table, flag = "Fling"},function()
    fling = Table["Fling"]
    if fling == false then
        rootPart.AssemblyAngularVelocity = Vector3.new(0,0,0)
    end
    uiToggleSound:Play()
end)
window:Toggle("Noclip?",{location = Table, flag = "Noclip"},function()
    -- Noclip Fron Infinite Yield
    if Table["Noclip"] then
        noclip()
    else
        clip()
    end
    uiToggleSound:Play()
end)
window:Toggle("Push Stopper?",{location = Table, flag = "Push Stopper", default = true},function()
    pushStopper = Table["Push Stopper"]
    uiToggleSound:Play()
end)
window:Bind("Hover Kill NPC Key",{location = Table, flag = "Kill Key", default = Enum.KeyCode.X}, function()
    -- Modified FE Punch Script From: https://www.mastersmzscripts.com/forum/mastersmz-scripts/fe-punch-script-1
    local mousePos = UserInputService:GetMouseLocation()
    local ray = Camera:ScreenPointToRay(mousePos.X, mousePos.Y)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {player.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

    local raycastResult = Workspace:Raycast(ray.Origin, ray.Direction * 1000, raycastParams)
    if raycastResult and raycastResult.Instance and raycastResult.Instance.Parent then
        kill(raycastResult.Instance)
    end
end)
window:Button(">Activate NDS Hub<",function()
    -- Natural Disaster Survival Hub From: https://scriptblox.com/script/Natural-Disaster-Survival-Katers-NDS-Hub-19533
    loadstring(game:HttpGet("https://raw.githubusercontent.com/KaterHub-Inc/NaturalDisasterSurvival/refs/heads/main/main.lua"))()
    uiClickSound:Play()
end)
window:Button(">Activate Player Ragdoll<",function()
    -- Modified Ragdoll Script From: https://www.mastersmzscripts.com/forum/mastersmz-scripts/fe-ragdoll
    local player = game.Players.LocalPlayer

    local tool = Instance.new("Tool")
    tool.Name = "Ragdoll"
    tool.CanBeDropped = false
    tool.RequiresHandle = true

    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(1, 1, 1)
    handle.Transparency = 1
    handle.CanCollide = false
    handle.Parent = tool

    local function ragdoll(character, mouse)
	    local motors = {}

	    for _, motor in ipairs(character:GetDescendants()) do
	    	if motor:IsA("Motor6D") then
	    		local part0, part1 = motor.Part0, motor.Part1
	    		if part0 and part1 then
	    			table.insert(motors, {
	    				Name = motor.Name,
	    				Parent = motor.Parent,
	    				Part0 = part0,
	    				Part1 = part1,
	    				C0 = motor.C0,
	    				C1 = motor.C1,
	    			})

	    			local a0 = Instance.new("Attachment")
	    			a0.CFrame = motor.C0
	    			a0.Name = "RagdollAttachment0"
	    			a0.Parent = part0

	    			local a1 = Instance.new("Attachment")
	    			a1.CFrame = motor.C1
	    			a1.Name = "RagdollAttachment1"
	    			a1.Parent = part1

		    		local constraint = Instance.new("BallSocketConstraint")
		    		constraint.Attachment0 = a0
		    		constraint.Attachment1 = a1
		    		constraint.Name = "RagdollConstraint"
		    		constraint.Parent = part0
		    	end
		    	motor:Destroy()
		    end
	    end

	    local root = character:FindFirstChild("HumanoidRootPart")
	    if root then
	    	local force = Instance.new("BodyVelocity")
	    	local mouseHit = mouse.Hit.Position
	    	local distance = (mouseHit - root.Position).Magnitude
	    	local direction = (mouseHit - root.Position).Unit

            -- Calculates Velocity To Ragdoll You Roughly Where Your Mouse Is
	    	force.Velocity = direction * (1474.987 + (-2.907266 - 1474.987)/(1 + (distance/6613.147)^0.6600983))
	    	force.MaxForce = Vector3.new(1e5, 1e5, 1e5)
	    	force.P = 1e4
	    	force.Parent = root
	    	game:GetService("Debris"):AddItem(force, 0.5)
	    end

	    local humanoid = character:FindFirstChildOfClass("Humanoid")
	    if humanoid then
	    	humanoid.PlatformStand = true
	    	humanoid:ChangeState(Enum.HumanoidStateType.Ragdoll)
	    end

	    task.wait(3)

	    for _, desc in ipairs(character:GetDescendants()) do
	    	if desc:IsA("BallSocketConstraint") and desc.Name == "RagdollConstraint" then
	    		desc:Destroy()
	    	elseif desc:IsA("Attachment") and (desc.Name == "RagdollAttachment0" or desc.Name == "RagdollAttachment1") then
	    		desc:Destroy()
	    	end
	    end

	    for _, data in ipairs(motors) do
	    	local m = Instance.new("Motor6D")
	    	m.Name = data.Name
	    	m.Part0 = data.Part0
	    	m.Part1 = data.Part1
	    	m.C0 = data.C0
	    	m.C1 = data.C1
	    	m.Parent = data.Parent
	    end

	    if humanoid then
	    	humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	    end
    end

    local equipped = false
    local mouseDownConnection

    local mouse = player:GetMouse()

    tool.Equipped:Connect(function()
    	equipped = true
    	mouseDownConnection = mouse.Button1Down:Connect(function()
    		if equipped and mouse.Target then
    			ragdoll(player.Character, mouse)
    		end
	    end)
    end)

    tool.Unequipped:Connect(function()
    	equipped = false
    	if mouseDownConnection then
    		mouseDownConnection:Disconnect()
    		mouseDownConnection = nil
    	end
    end)

    tool.Parent = player.Backpack
    uiClickSound:Play()
end)
window:Button(">Activate Infinite Yield<",function()
    -- Infinite Yield From: https://github.com/EdgeIY/infiniteyield
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    uiClickSound:Play()
end)
window:Section("               Presets")
window:Button("Physics (default)",function()
    preset(1)
end)
window:Button("Bouncy Physics",function()
    preset(2)
end)
window:Button("Slow Motion Physics",function()
    preset(3)
end)
window:Button("Zero Gravity",function()
    preset(4)
end)
window:Button("Fly Upright",function()
    preset(5)
end)
window:Button("Fly Sideways",function()
    preset(6)
end)
window:Button("Fly Fling",function()
    preset(7)
end)
window:Button("Fly Noclip",function()
    preset(8)
end)





-- MAIN CODE

local keysDown = {
    W = false,
    A = false,
    S = false,
    D = false,
    Q = false,
    E = false,
    Space = false
}

-- Disable Roblox Physics
local function disablePhysics()
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.Anchored = false
            part.AssemblyLinearVelocity = Vector3.new(0,0,0)
            part.AssemblyAngularVelocity = Vector3.new(0,0,0)
        end
    end
    -- Save Then Disable
    WalkSpeed = humanoid.WalkSpeed
    JumpPower = humanoid.JumpPower
    humanoid.PlatformStand = true
    humanoid.AutoRotate = false
    humanoid.WalkSpeed = 0
    humanoid.JumpPower = 0
end

-- Enable Roblox Physics
local function enablePhysics()
    humanoid.PlatformStand = false
    humanoid.AutoRotate = true
    humanoid.WalkSpeed = WalkSpeed
    humanoid.JumpPower = JumpPower
    rootPart.AssemblyLinearVelocity = Vector3.new(0,0,0)
    rootPart.AssemblyAngularVelocity = Vector3.new(0,0,0)
end

-- WASD Movement
local function getInputDirection()
    local x, z = 0, 0
    if keysDown.W then z = z + 1 end
    if keysDown.S then z = z - 1 end
    if keysDown.A then x = x + 1 end
    if keysDown.D then x = x - 1 end
    local dir = Vector3.new(x, 0, z)
    if dir.Magnitude > 0 then
        return dir.Unit
    else
        return Vector3.new(0,0,0)
    end
end

local function getCameraRelativeDirection(inputDir)
    local cameraCF = Camera.CFrame
    local lookVector = cameraCF.LookVector
    local lookVectorYZero = Vector3.new(lookVector.X, 0, lookVector.Z).Unit
    if not lookVectorYZero then
        return inputDir
    end

    local cameraYaw = math.atan2(lookVectorYZero.X, lookVectorYZero.Z)
    local rotationCFrame = CFrame.Angles(0, cameraYaw, 0)
    local worldDirection = rotationCFrame:VectorToWorldSpace(inputDir)
    return worldDirection
end

local function yawPitchToCFrame(yawDeg, pitchDeg)
    local yaw = math.rad(yawDeg or 180)
    local pitch = math.rad((pitchDeg or 180) - 180)

    -- Apply Yaw Then Pitch
    return CFrame.Angles(0, yaw, 0) * CFrame.Angles(pitch, 0, 0)
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if not ballActive then return end

    if input.UserInputType == Enum.UserInputType.Keyboard then
        local key = input.KeyCode.Name
        if keysDown[key] ~= nil then
            keysDown[key] = true
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if not ballActive then return end

    if input.UserInputType == Enum.UserInputType.Keyboard then
        local key = input.KeyCode.Name
        if keysDown[key] ~= nil then
            keysDown[key] = false
        end
    end
end)

local function isPartBelow(position, maxDistance)
    maxDistance = maxDistance
    local rayOrigin = position
    local rayDirection = Vector3.new(0, -maxDistance, 0)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.IgnoreWater = true

    local rayResult = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    if rayResult and rayResult.Instance and rayResult.Instance.CanCollide then
        return true, rayResult.Position
    else
        return false, nil
    end
end

local connectionRunService
onToggle = function()
    ballActive = not ballActive

    if ballActive then
        character = player.Character or player.CharacterAdded:Wait()
        humanoid = character:WaitForChild("Humanoid")
        rootPart = character:WaitForChild("HumanoidRootPart")

        -- Stop Gravity Velocity That Occurs After 1 Frame
        local singleFrameConnection
            singleFrameConnection = game:GetService("RunService").Heartbeat:Connect(function()
            rootPart.Velocity = Vector3.new(0,0,0)
            rootPart.AssemblyLinearVelocity = Vector3.new(0,0,0)
            singleFrameConnection:Disconnect()
        end)

        originalGravity = Workspace.Gravity
        Workspace.Gravity = 0

        disablePhysics()
        velocityVector = Vector3.new(0,0,0)

        -- Loop
        connectionRunService = RunService.Heartbeat:Connect(function(dt)
            damping = ballFriction / -200 + 1
            rootPart.AssemblyAngularVelocity = Vector3.new(rootPart.AssemblyAngularVelocity.X * damping, rootPart.AssemblyAngularVelocity.Y * damping, rootPart.AssemblyAngularVelocity.Z * damping)
            rootPart.AssemblyLinearVelocity = Vector3.new(rootPart.AssemblyLinearVelocity.X * damping, rootPart.AssemblyLinearVelocity.Y * damping, rootPart.AssemblyLinearVelocity.Z * damping)

            local inputDir = getInputDirection()
            if inputDir.Magnitude > 0 then
                inputDir = getCameraRelativeDirection(inputDir)
                inputDir = Vector3.new(inputDir.X, 0, inputDir.Z).Unit
            end

            -- Up/Down Movement
            local verticalVelocity = 0
            if keysDown.Q then
                verticalVelocity = verticalVelocity + ballSpeed * dt
            end
            if keysDown.E then
                verticalVelocity = verticalVelocity - ballSpeed * dt
            end

            -- Direction Movement
            if inputDir.Magnitude > 0 then
                velocityVector = velocityVector + inputDir * ballSpeed * dt
            end

            -- Physics
            if physicsEnabled then
                -- Friction & Gravity
                velocityVector = Vector3.new(velocityVector.X, velocityVector.Y + verticalVelocity, velocityVector.Z)
                velocityVector = Vector3.new(velocityVector.X * damping, velocityVector.Y, velocityVector.Z * damping)
                velocityVector = velocityVector - Vector3.new(0, gravity * dt * 1.8)

                local partBelow, hitPosition = isPartBelow(rootPart.Position, 3)

                if partBelow then
                    if velocityVector.Y < 0 then
                        if partBelowTime == 0 then
                            -- Hit Sound
                            hitSound.PlaybackSpeed = math.random(90, 110) / 100
                            hitSound.Volume = velocityVector.Magnitude / 30
                            hitSound:Play()

                            -- Bounce
                            velocityVector = Vector3.new(
                                velocityVector.X,
                                -velocityVector.Y * bounce / 100 - 2,
                                velocityVector.Z
                            )
                        else
                            velocityVector = Vector3.new(velocityVector.X, -1, velocityVector.Z)
                        end
                        -- Clips Out Of Ground
                        if hitPosition then
                            local rx, ry, rz = rootPart.CFrame:ToEulerAnglesXYZ()
                            local newPosition = Vector3.new(rootPart.Position.X, hitPosition.Y + 3, rootPart.Position.Z)
                            rootPart.CFrame = CFrame.new(newPosition) * CFrame.Angles(rx, ry, rz)
                        end

                        -- Jump
                        if keysDown.Space then
                            local jumpVelocity = jumpPower * 0.9
                            if jumpVelocity > velocityVector.Y then
                                velocityVector = Vector3.new(velocityVector.X, jumpVelocity, velocityVector.Z)
                            end
                        end
                    end
                    partBelowTime = 15
                end

                if partBelowTime ~= 0 then
                    partBelowTime = partBelowTime - 1
                end
            else
                -- Friction & Verticle Damping
                velocityVector = Vector3.new(velocityVector.X, velocityVector.Y + verticalVelocity, velocityVector.Z)
                velocityVector = Vector3.new(velocityVector.X * damping, velocityVector.Y * damping, velocityVector.Z * damping)
            end

            local deltaMove = velocityVector * dt
            local newPosition = rootPart.Position + deltaMove

            if directionLock then
                -- Direction Lock
                rootPart.CFrame = CFrame.new(newPosition) * yawPitchToCFrame(yaw, pitch)
            else
                -- Normal Rolling
                local horizontalMove = Vector3.new(deltaMove.X, 0, deltaMove.Z)
                if horizontalMove.Magnitude > 0 then
                    local horizontalMoveDir = horizontalMove.Unit
                    local upVector = Vector3.new(0,1,0)

                    local rotationAxis = horizontalMoveDir:Cross(upVector)
                    rotationAxis = -rotationAxis

                    if rotationAxis.Magnitude > 0 then
                        rotationAxis = rotationAxis.Unit
                        local horizontalDistance = horizontalMove.Magnitude
                        local rotationAngle = horizontalDistance / radius

                        local rotationCFrame = CFrame.fromAxisAngle(rotationAxis, rotationAngle)
                        rootPart.CFrame = CFrame.new(newPosition) * rotationCFrame * (rootPart.CFrame - rootPart.CFrame.p)
                    else
                        rootPart.CFrame = CFrame.new(newPosition)
                    end
                else
                    rootPart.CFrame = rootPart.CFrame + Vector3.new(0, deltaMove.Y, 0)
                end
            end

            if pushStopper or fling then
                -- Stop Player's Velocities
                rootPart.Velocity = Vector3.new(0,0,0)
                rootPart.AssemblyLinearVelocity = Vector3.new(0,0,0)
            end

            if fling then
                -- Set random high rotation velocity in random directions
                -- You can adjust the magnitude as desired
                local maxAngularVelocity = 1000 -- high value
                local randomAngularVelocity = Vector3.new(
                    (math.random() - 0.5) * 2 * maxAngularVelocity,
                    (math.random() - 0.5) * 2 * maxAngularVelocity,
                    (math.random() - 0.5) * 2 * maxAngularVelocity
                )
                rootPart.AssemblyAngularVelocity = randomAngularVelocity
            end
            rollSound.Volume = velocityVector.Magnitude / 40
        end)
    else
        if connectionRunService then
            connectionRunService:Disconnect()
            connectionRunService = nil
        end

        local yaw = math.rad(rootPart.Orientation.Y)
        rootPart.CFrame = CFrame.new(rootPart.Position) * CFrame.Angles(0, yaw, 0)

        enablePhysics()

        Workspace.Gravity = originalGravity

        for k in pairs(keysDown) do
            keysDown[k] = false
        end
        velocityVector = Vector3.new(0,0,0)
        rollSound.Volume = 0
    end
end

-- Prevents Glitching
humanoid.HealthChanged:Connect(function(health)
    if ballActive and health <= 0 then
        onToggle()
    end
end)