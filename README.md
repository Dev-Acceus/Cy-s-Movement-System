# Cyrus-Movement-System
## Bug-Fix
- [X] Dash executes despite random WASD movement -> Reduce tapSpeed and add debounce (lastKeyPressed)
- [X] Debris moves Humanoid Angle -> Set Humanoid Angle Constant
- [X] Camera Glitches After Respawn -> Disconnect connection before reconnecting
- [X] Debounce for Dash to Sprint Animation -> Edit Default Animations based on WalkSpeed instead of local remote event
- [X] Sprint Animation executes without moving -> Removed local remote event Humanoid:GetPropertyChangedSignal("WalkSpeed")
- [ ] Animations randomly stop -> Check animation priorities
- [ ] Camera Field Of View due to Dashing while Sprinting (doesn't reset to origin)

## Recommendations
- [X] BodyVelocity instead of Velocity for Dash? -> nah
- [X] Longer Cooldown? -> nah

## Features
### Walk
- [X] Walk Animation

### Sprint
- [X] Sprint Animation
- [X] Camera FOV

### Directional Dashes
- [X] Forward Dash
- [X] Backward Dash
- [X] Left Dash
- [X] Right Dash
- [X] Camera FOV

### Dodges
- ???

### Default Camera Perspective
- [X] Centered
