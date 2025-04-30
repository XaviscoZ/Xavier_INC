local LocalPlayer = game:GetService("Players").LocalPlayer

local raycastParams = RaycastParams.new()
raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
raycastParams.FilterType = Enum.RaycastFilterType.Exclude

local params = OverlapParams.new()
params.FilterDescendantsInstances = {LocalPlayer.Character}

function detectEnemy(hitbox, hrp)
	while true do
		local parts = workspace:GetPartsInPart(hitbox, params)
		for i, part in pairs(parts) do
			if part.Parent.Name == "m_Zombie" then
				local Origin = part.Parent:WaitForChild("Orig")
				if Origin.Value ~= nil then
					local zombie = Origin.Value:WaitForChild("Zombie")
					if LocalPlayer.Character:FindFirstChild("Heavy Sabre") and LocalPlayer.Character["Heavy Sabre"]:IsA("Tool") then
						local hit = Origin.Value
						local zombieHead = workspace:Raycast(hrp.CFrame.Position, hit.Head.CFrame.Position - hrp.CFrame.Position)
						local calc = (zombieHead.Position - hrp.CFrame.Position)

						if calc:Dot(calc) > 1 then
							calc = calc.Unit
            			end

						if LocalPlayer:DistanceFromCharacter(Origin.Value:FindFirstChild("HumanoidRootPart").CFrame.Position) < 13 then
							if zombie.WalkSpeed > 16 then
								game:GetService("ReplicatedStorage").Remotes.Gib:FireServer(hit, "Head", hit.Head.CFrame.Position, zombieHead.Normal, true)
								game:GetService("Workspace").Players[LocalPlayer.Name]["Heavy Sabre"].RemoteEvent:FireServer("Swing", "Thrust")
            					game:GetService("Workspace").Players[LocalPlayer.Name]["Heavy Sabre"].RemoteEvent:FireServer("HitZombie", hit, hit.Head.CFrame.Position, true, calc * 25, "Head", zombieHead.Normal)
        					else
        						if part.Parent:FindFirstChild("Barrel") == nil then
        							game:GetService("ReplicatedStorage").Remotes.Gib:FireServer(hit, "Head", hit.Head.CFrame.Position, zombieHead.Normal, true)
									game:GetService("Workspace").Players[LocalPlayer.Name]["Heavy Sabre"].RemoteEvent:FireServer("Swing", "Thrust")
            						game:GetService("Workspace").Players[LocalPlayer.Name]["Heavy Sabre"].RemoteEvent:FireServer("HitZombie", hit, hit.Head.CFrame.Position, true, calc * 25, "Head", zombieHead.Normal)
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
		hitbox.Transparency  = 0.9
		hitbox.Size = Vector3.new(13, 7, 12.5)
		hitbox.Position = Vector3.new(torso.Position.X, torso.Position.Y, torso.Position.Z-7.8)

		detectEnemy(LocalPlayer.Character.HumanoidRootPart:WaitForChild("Hitbox"), LocalPlayer.Character.HumanoidRootPart)
	end
end)
