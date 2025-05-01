local LocalPlayer = game:GetService("Players").LocalPlayer
local StarterGui = game:GetService("StarterGui")

local raycastParams = RaycastParams.new()
raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
raycastParams.FilterType = Enum.RaycastFilterType.Exclude

local params = OverlapParams.new()
params.FilterDescendantsInstances = {LocalPlayer.Character}

isDead = false
nowMelee = ""

StarterGui:SetCore("SendNotification", {
    Title = "Kill Aura Loaded!",
    Text = "If you can see this, the script is working"
})

function checkEquipTool()
	local childrens = LocalPlayer.Character:GetChildren()
	for i, children in pairs(childrens) do
		if children:IsA("Tool") and children:FindFirstChild("MeleeBase") then
			return children
		end
	end
end

function detectEnemy(hitbox, hrp)
	print("[DEBUG] Enemy Detect function get called!")
	while true do
        if isDead then
            print("Killed!")
            isDead = false
            return nil
        end
		local parts = workspace:GetPartsInPart(hitbox, params)
		for i, part in pairs(parts) do
			if part.Parent.Name == "m_Zombie" then
				local Origin = part.Parent:WaitForChild("Orig")
				if Origin.Value ~= nil then
					local zombie = Origin.Value:WaitForChild("Zombie")
					local toolEquip = checkEquipTool()
					if toolEquip then
						local hit = Origin.Value
						local zombieHead = workspace:Raycast(hrp.CFrame.Position, hit.Head.CFrame.Position - hrp.CFrame.Position)
						local calc = (zombieHead.Position - hrp.CFrame.Position)

						if calc:Dot(calc) > 1 then
							calc = calc.Unit
            			end

						if LocalPlayer:DistanceFromCharacter(Origin.Value:FindFirstChild("HumanoidRootPart").CFrame.Position) < 13 then
							print(toolEquip)
							if zombie.WalkSpeed > 16 then
								game:GetService("ReplicatedStorage").Remotes.Gib:FireServer(hit, "Head", hit.Head.CFrame.Position, zombieHead.Normal, true)
								game:GetService("Workspace").Players[LocalPlayer.Name][toolEquip.Name].RemoteEvent:FireServer("Swing", "Thrust")
            					game:GetService("Workspace").Players[LocalPlayer.Name][toolEquip.Name].RemoteEvent:FireServer("HitZombie", hit, hit.Head.CFrame.Position, true, calc * 25, "Head", zombieHead.Normal)
        					else
        						if part.Parent:FindFirstChild("Barrel") == nil then
        							game:GetService("ReplicatedStorage").Remotes.Gib:FireServer(hit, "Head", hit.Head.CFrame.Position, zombieHead.Normal, true)
									game:GetService("Workspace").Players[LocalPlayer.Name][toolEquip.Name].RemoteEvent:FireServer("Swing", "Thrust")
            						game:GetService("Workspace").Players[LocalPlayer.Name][toolEquip.Name].RemoteEvent:FireServer("HitZombie", hit, hit.Head.CFrame.Position, true, calc * 25, "Head", zombieHead.Normal)
								end
							end
						end
					end
				end	
			end
		end
	task.wait(0.1)
	end
end

LocalPlayer.CharacterRemoving:Connect(function()
    print("[DEBUG] Player dead, isDead variable set to True")
    isDead = true
end)

workspace.Players.ChildAdded:Connect(function(child)
	if child.Name == LocalPlayer.Name then 
		local torso = child:WaitForChild("HumanoidRootPart")
		local hitbox = Instance.new("Part", torso)
		local weld = Instance.new("WeldConstraint", torso)
		weld.Part0 = hitbox
		weld.Part1 = child.HumanoidRootPart
		hitbox.Name = "Hitbox"
		hitbox.Anchored = false
		hitbox.Massless = true
		hitbox.CanCollide = false
		hitbox.CanTouch = true
		hitbox.Transparency  = 1
		hitbox.Size = Vector3.new(13, 7, 12.5)
		hitbox.Position = Vector3.new(torso.Position.X, torso.Position.Y, torso.Position.Z-7.8)

        isDead = false
		detectEnemy(LocalPlayer.Character.HumanoidRootPart:WaitForChild("Hitbox"), LocalPlayer.Character.HumanoidRootPart)
	end
end)
