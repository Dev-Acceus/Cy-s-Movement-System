if tick() - dashProperties.lastW <= dashProperties.tapSpeed then
					-- insert body mover here
					Root.Velocity = Root.CFrame.lookVector * dashProperties.velocity
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

					-- wait for cooldown
					wait(dashProperties.cooldown)
					can_dash = true
				end
				dashProperties.lastW = tick()
