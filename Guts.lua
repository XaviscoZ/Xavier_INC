-- Main Functions

-- ESP
espRToggled = false
espBToggled = false
espIToggled = false
workspace.Camera.ChildAdded:Connect(
    function(child)
        if child.Name == "m_Zombie" then
            local Origin = child:WaitForChild("Orig")
            if Origin.Value ~= nil then
                local zombie = Origin.Value:WaitForChild("Zombie")
                if espRToggled then
                    if zombie.WalkSpeed > 16 then
                        local Highlight = Instance.new("Highlight")
                        Highlight.Parent = child
                        Highlight.Adornee = child
                    end
                end
                if espBToggled then
                    if child:FindFirstChild("Barrel") ~= nil then
                        local Highlight = Instance.new("Highlight")
                        Highlight.Parent = child
                        Highlight.Adornee = child
                        Highlight.FillColor = Color3.fromRGB(65,105,225)
                    end
                end
                if espIToggled then 
                    if child:FindFirstChild("Whale Oil Lantern") ~= nil then
                        local Highlight = Instance.new("Highlight")
                        Highlight.Parent = child
                        Highlight.Adornee = child
                        Highlight.FillColor = Color3.fromRGB(255,255,51)
                    end
                end
            end
        end
    end
)

-- WalkSpeed
local LocalPlayer = game:GetService("Players").LocalPlayer
local workPlayer = workspace.Players:FindFirstChild(LocalPlayer.Name)
local connection = nil

local function changeWalkSpeed(check)
    if check then
        connection = workPlayer.Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function() workPlayer.Humanoid.WalkSpeed = 17 end)
        print("WalkSpeed Changed!") 
    else
        if connection ~= nil then
            print("Disconnect!")
            connection:Disconnect()
        end
    end
end

-- GodMode
walkSpeedToggled = false
godModeToggled = false
workspace.Players.ChildAdded:Connect(
   function(child)
      if walkSpeedToggled then
        changeWalkSpeed(walkSpeedToggled)
      end
      if godModeToggled then
        if child.Name == game:GetService("Players").LocalPlayer.Name then
            if child.HumanoidRootPart:FindFirstChild("GrabP") ~= nil then
               game.Players.LocalPlayer.Character.HumanoidRootPart.GrabP:Destroy()
            end
         end
      else
         return nil
      end
   end
)

-- HeadLock
local MeleeBase = require(game:GetService("ReplicatedStorage").Modules.Weapons:waitForChild("MeleeBase"))
local originFunction = MeleeBase.MeleeHitCheck

local u1 = {}
u1.__index = u1
local u2 = game:GetService("UserInputService")
local u3 = workspace.CurrentCamera
game:GetService("RunService")
local u4 = game.ReplicatedStorage:WaitForChild("LocalUpdateCrosshair")
local v5 = game.ReplicatedStorage:WaitForChild("GameStates"):WaitForChild("Gameplay")
local u6 = v5:WaitForChild("FriendlyFire")
local u7 = v5:WaitForChild("PVP")
local u8 = game:GetService("CollectionService")
local u9 = require(game.ReplicatedStorage:WaitForChild("Modules"):WaitForChild("World"):WaitForChild("SoundSystem"))
local u10 = require(game.ReplicatedStorage:WaitForChild("Modules"):WaitForChild("RbxUtil"):WaitForChild("DebugVisualizer"))
local v11 = game.Players.LocalPlayer:WaitForChild("Options")
local u12 = v11:WaitForChild("FPArmTransparency")
local u13 = v11:WaitForChild("FlipHorizontalSwing")
local u14 = v11:WaitForChild("Gore")
local u15 = v11:WaitForChild("WeaponStains")
local u16 = v11:WaitForChild("UnlockDirAtUnEquip")
local u17 = {
    ["Swing"] = "rbxassetid://14228572354",
    ["Charge"] = "rbxassetid://14228574464",
    ["AxeFront"] = "rbxassetid://18550335136",
    ["AxeBack"] = "rbxassetid://18550335251"
}

function u1.MeleeHitCheck(p100, p101, p102, p103, p104, p105)
    local v106 = workspace:Raycast(p101, p102, p103)
    if v106 then
        if v106.Instance.Parent.Name == "m_Zombie" then
            local v107 = p103.FilterDescendantsInstances
            local v108 = v106.Instance
            table.insert(v107, v108)
            p103.FilterDescendantsInstances = v107
            local v109 = v106.Instance.Parent:FindFirstChild("Orig")
            if v109 then
                if p100.sharp and shared.Gib ~= nil then
                    if v109.Value then
                        local v110 = v109.Value:FindFirstChild("Zombie")
                        local v111 = not p100.Stats.HeadshotMulti and 2.3 or p100.Stats.HeadshotMulti
                        if v110 and v110.Health - p100.Stats.Damage * v111 <= 0 then
                            shared.Gib(v109.Value, v106.Instance.Name, v106.Position, v106.Normal, true)
                        end
                    else
                        shared.Gib(v109.Value, v106.Instance.Name, v106.Position, v106.Normal, true)
                    end
                end
                if not p104[v109] or p104[v109] < (p100.Stats.MaxHits or 3) then
                    if p105 then
                        p100.remoteEvent:FireServer("ThrustCharge", v109.Value, v106.Position, v106.Normal)
                    else
                        local u112 = v109.Value
                        local v113 = v106.Instance.Parent.Head.CFrame.Position - p101
                        if v113:Dot(v113) > 1 then
                            v113 = v113.Unit
                        end
                        local v114 = v113 * 25
                        p100.remoteEvent:FireServer("HitZombie", u112, v106.Instance.Parent.Head.CFrame.Position, true, v114, "Head", v106.Normal)
                        if not u112:GetAttribute("WepHitDirection") then
                            local u115 = tick()
                            u112:SetAttribute("WepHitID", tick())
                            u112:SetAttribute("WepHitDirection", v114)
                            u112:SetAttribute("WepHitPos", v106.Position)
                            task.delay(0.2, function() --[[Anonymous function at line 887]]
                                --[[
                                Upvalues:
                                    [1] = u112
                                    [2] = u115
                                --]]
                                if u112:GetAttribute("WepHitID") == u115 then
                                    u112:SetAttribute("WepHitDirection", nil)
                                    u112:SetAttribute("WepHitPos", nil)
                                    u112:SetAttribute("WepHitID", nil)
                                end
                            end)
                        end
                        u10:CastSphere("MeleeHitValid", CFrame.new(p101), Color3.fromRGB(0, 255, 0))
                        u10:CastSphere("PartPosition", CFrame.new(v106.Position), Color3.fromRGB(255, 85, 0))
                        u10:CastLine("MeleeHit", CFrame.new(p101, p101 + p102) * CFrame.new(0, 0, -p102.Magnitude / 2), Color3.fromRGB(0, 255, 0), p102.Magnitude / 1)
                    end
                    if p104[v109] then
                        p104[v109] = p104[v109] + 1
                    else
                        table.insert(p104, v109)
                        p104[v109] = 1
                        if u14.Value and (u15.Value and p100.player:GetAttribute("Platform") ~= "Console") then
                            local v116 = p100.bloodSaturation + 0.1
                            p100.bloodSaturation = math.min(v116, 1)
                        end
                    end
                end
            end
            return 1
        end
        if not p105 then
            local v117 = v106.Instance.Parent:FindFirstChild("DoorHit") or v106.Instance:FindFirstChild("BreakGlass")
            if v117 and not table.find(p104, v117) then
                table.insert(p104, v117)
                p100.remoteEvent:FireServer("HitCon", v106.Instance)
                u10:CastSphere("MeleeHitValid", CFrame.new(p101), Color3.fromRGB(0, 255, 0))
                u10:CastLine("MeleeHit", CFrame.new(p101, p101 + p102) * CFrame.new(0, 0, -p102.Magnitude / 2), Color3.fromRGB(255, 255, 0), p102.Magnitude / 1)
                return 2
            end
            local v118 = v106.Instance.Parent:FindFirstChild("Humanoid") or v106.Instance.Parent.Parent:FindFirstChild("Humanoid")
            if v118 and not table.find(p104, v118) then
                table.insert(p104, v118)
                p100.remoteEvent:FireServer("HitPlayer", v118, v106.Position)
                u10:CastSphere("MeleeHitValid", CFrame.new(p101), Color3.fromRGB(0, 255, 0))
                u10:CastLine("MeleeHit", CFrame.new(p101, p101 + p102) * CFrame.new(0, 0, -p102.Magnitude / 2), Color3.fromRGB(0, 255, 0), p102.Magnitude / 1)
                return 2
            end
            if u7:GetAttribute("Active") == true then
                local v119 = v106.Instance.Parent:FindFirstChild("BuildingHealth") or v106.Instance.Parent.Parent:FindFirstChild("BuildingHealth")
                if v119 ~= nil and not table.find(p104, v119) then
                    table.insert(p104, v119)
                    local v120 = v119.Parent:FindFirstChild("Creator")
                    if v120 then
                        v120 = v120.Value
                    end
                    if v120 ~= nil and (v120.Neutral == false and (p100.player.Team ~= nil and (v120.Team ~= nil and p100.player.Team.Name == v120.Team.Name))) then
                        return 2
                    end
                    p100.remoteEvent:FireServer("HitBuilding", v119.Parent)
                    u10:CastSphere("MeleeHitValid", CFrame.new(p101), Color3.fromRGB(0, 255, 0))
                    u10:CastLine("MeleeHit", CFrame.new(p101, p101 + p102) * CFrame.new(0, 0, -p102.Magnitude / 2), Color3.fromRGB(255, 255, 0), p102.Magnitude / 1)
                    return 2
                end
            end
            if p100.Stats.BreaksDown and u8:HasTag(v106.Instance, "Breakable") then
                local v121 = OverlapParams.new()
                v121.FilterDescendantsInstances = p103.FilterDescendantsInstances
                local v122 = workspace:GetPartBoundsInRadius(v106.Position, 0.1, v121)
                local v123 = {}
                for v124 = 1, #v122 do
                    if u8:HasTag(v122[v124], "Breakable") then
                        local v125 = v122[v124]
                        table.insert(v123, v125)
                    end
                end
                p100.remoteEvent:FireServer("HitBreakable", v123, (v106.Position - p101).Unit)
                u10:CastSphere("MeleeHitValid", CFrame.new(p101), Color3.fromRGB(0, 255, 0))
                u10:CastLine("MeleeHit", CFrame.new(p101, p101 + p102) * CFrame.new(0, 0, -p102.Magnitude / 2), Color3.fromRGB(255, 255, 0), p102.Magnitude / 1)
                return 2
            end
            u10:CastLine("MeleeHit", CFrame.new(p101, p101 + p102) * CFrame.new(0, 0, -p102.Magnitude / 2), Color3.fromRGB(255, 0, 0), p102.Magnitude / 1)
        end
    else
        u10:CastLine("MeleeHit", CFrame.new(p101, p101 + p102) * CFrame.new(0, 0, -p102.Magnitude / 2), Color3.fromRGB(255, 0, 0), p102.Magnitude / 1)
    end
    return 0
end

function changeMelee(value)
   if value then
      print("Function Changed!")
      MeleeBase.MeleeHitCheck = u1.MeleeHitCheck
   else
      MeleeBase.MeleeHitCheck = originFunction
   end
end

-- GodMode


local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Window =
    Rayfield:CreateWindow(
    {
        Name = "G&B Hub - Xavier I.N.C",
        Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
        LoadingTitle = "Xabisco on youtube.",
        LoadingSubtitle = "by Xabisco",
        Theme = "Default",
        DisableRayfieldPrompts = false,
        DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface
        ConfigurationSaving = {
            Enabled = true,
            FolderName = nil, -- Create a custom folder for your hub/game
            FileName = "G&B Hub"
        },
        Discord = {
            Enabled = true,
            Invite = "v8hYqpn2",
            RememberJoins = true
        },
        KeySystem = true,
        KeySettings = {
            Title = "G&B Hub - Xavier I.N.C",
            Subtitle = "Key System",
            Note = "Enter in your Discord! :D\n(discord.gg/v8hYqpn2)",
            FileName = "Key",
            SaveKey = true,
            GrabKeyFromSite = false,
            Key = {"xabisco_inc"}
        }
    }
)

local Tab = Window:CreateTab("Main", "album")
local Section = Tab:CreateSection("Main Functions")

local esp_Tab = Window:CreateTab("ESP", "target")
local esp_Section = esp_Tab:CreateSection("ESP Functions")

local walkSpeed =
    Tab:CreateToggle(
    {
        Name = "Walkspeed Fixed",
        CurrentValue = false,
        Flag = "walking",
        Callback = function(Value)
            changeWalkSpeed(Value)
            walkSpeedToggled = Value
        end
    }
)

local god_toggle =
    Tab:CreateToggle(
    {
        Name = "God Mode",
        CurrentValue = false,
        Flag = "GodMode",
        Callback = function(Value)
            godModeToggled = Value
        end
    }
)

local headToggle =
    Tab:CreateToggle(
    {
        Name = "Head Lock",
        CurrentValue = false,
        Flag = "HeadLock", 
        Callback = function(Value)
         changeMelee(Value)
        end
    }
)

local esp_Runner =
    esp_Tab:CreateToggle(
    {
        Name = "ESP Runner",
        CurrentValue = false,
        Flag = "ESP_1",
        Callback = function(Value)
            espRToggled = Value
        end
    }
)

local esp_Bomber =
    esp_Tab:CreateToggle(
    {
        Name = "ESP Bomber",
        CurrentValue = false,
        Flag = "ESP_2",
        Callback = function(Value)
            espBToggled = Value
        end
    }
)

local esp_Igniter =
    esp_Tab:CreateToggle(
    {
        Name = "ESP Igniter",
        CurrentValue = false,
        Flag = "ESP_3",
        Callback = function(Value)
            espIToggled = Value
        end
    }
)  
