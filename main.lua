-- Dumont ESP Script for Rost
-- Silently loads ESP without console prints

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Dumont", "Ocean")

-- Create main tabs
local MainTab = Window:NewTab("Main")
local VisualsTab = Window:NewTab("Visuals")
local GameTab = Window:NewTab("Game")
local SettingsTab = Window:NewTab("Settings")

-- Set up sections
local MainSection = MainTab:NewSection("ESP Controls")
local VisualsSection = VisualsTab:NewSection("ESP Appearance")
local ColorSection = VisualsTab:NewSection("Colors")
local LightingSection = VisualsTab:NewSection("Lighting")
local GameSection = GameTab:NewSection("Game Features")
local SettingsSection = SettingsTab:NewSection("Configuration")

-- ESP Library Reference (will be loaded with loadstring)
local ESP = {}

-- Store original lighting settings
local LightingService = game:GetService("Lighting")
local originalBrightness = LightingService.Brightness
local originalAmbient = LightingService.Ambient
local originalOutdoorAmbient = LightingService.OutdoorAmbient
local originalClockTime = LightingService.ClockTime
local originalFogEnd = LightingService.FogEnd
local originalFogStart = LightingService.FogStart

-- Main ESP Controls
MainSection:NewToggle("ESP Enabled", "Toggle ESP functionality", function(state)
    ESP.Enabled = state
end)

MainSection:NewToggle("Team Check", "Don't show ESP for teammates", function(state)
    ESP.TeamCheck = state
end)

MainSection:NewSlider("Max Distance", "Maximum distance to render ESP", 500, 50, function(value)
    ESP.MaxDistance = value
end)

MainSection:NewDropdown("Font Size", "Change the font size", {"11", "12", "14", "16", "18"}, function(val)
    ESP.FontSize = tonumber(val)
end)

-- Visuals Settings
VisualsSection:NewToggle("Box ESP", "Show boxes around players", function(state)
    ESP.Drawing.Boxes.Full.Enabled = state
end)

VisualsSection:NewToggle("Corner Box", "Show corner boxes around players", function(state)
    ESP.Drawing.Boxes.Corner.Enabled = state
end)

VisualsSection:NewToggle("Name ESP", "Show player names", function(state)
    ESP.Drawing.Names.Enabled = state
end)

VisualsSection:NewToggle("Health Bar", "Show player health", function(state)
    ESP.Drawing.Healthbar.Enabled = state
end)

VisualsSection:NewToggle("Chams", "Show player chams", function(state)
    ESP.Drawing.Chams.Enabled = state
end)

VisualsSection:NewToggle("Weapon ESP", "Show player weapons", function(state)
    ESP.Drawing.Weapons.Enabled = state
end)

VisualsSection:NewToggle("Distance ESP", "Show distance to players", function(state)
    ESP.Drawing.Distances.Enabled = state
end)

-- Colors section
ColorSection:NewColorPicker("Box Color", "Color for boxes", Color3.fromRGB(255,255,255), function(color)
    ESP.Drawing.Boxes.Full.RGB = color
end)

ColorSection:NewColorPicker("Chams Fill", "Fill color for chams", Color3.fromRGB(119,120,255), function(color)
    ESP.Drawing.Chams.FillRGB = color
end)

ColorSection:NewColorPicker("Chams Outline", "Outline color for chams", Color3.fromRGB(119,120,255), function(color)
    ESP.Drawing.Chams.OutlineRGB = color
end)

ColorSection:NewColorPicker("Name Color", "Color for names", Color3.fromRGB(255,255,255), function(color)
    ESP.Drawing.Names.RGB = color
end)

-- Lighting & Night Vision Section
LightingSection:NewToggle("Night Vision", "Enable night vision mode", function(state)
    if state then
        -- Store current lighting settings to restore later if needed
        originalBrightness = LightingService.Brightness
        originalAmbient = LightingService.Ambient
        originalOutdoorAmbient = LightingService.OutdoorAmbient
        originalClockTime = LightingService.ClockTime
        originalFogEnd = LightingService.FogEnd
        originalFogStart = LightingService.FogStart
        
        -- Apply night vision settings
        LightingService.Brightness = 1
        LightingService.Ambient = Color3.fromRGB(50, 90, 50)
        LightingService.OutdoorAmbient = Color3.fromRGB(50, 90, 50)
        LightingService.ClockTime = 0
        LightingService.FogEnd = 100000
        LightingService.FogStart = 0
        
        -- Remove sun rays and blur if they exist
        if LightingService:FindFirstChild("SunRays") then
            LightingService.SunRays.Enabled = false
        end
        
        if LightingService:FindFirstChild("Blur") then
            LightingService.Blur.Enabled = false
        end
        
        -- Add slight green tint effect for NV look
        local colorCorrection = LightingService:FindFirstChild("NVColorCorrection")
        if not colorCorrection then
            colorCorrection = Instance.new("ColorCorrectionEffect")
            colorCorrection.Name = "NVColorCorrection"
            colorCorrection.Parent = LightingService
        end
        colorCorrection.TintColor = Color3.fromRGB(200, 255, 200)
        colorCorrection.Contrast = 0.1
        colorCorrection.Brightness = 0.1
        colorCorrection.Saturation = -0.3
        colorCorrection.Enabled = true
    else
        -- Restore original lighting settings
        LightingService.Brightness = originalBrightness
        LightingService.Ambient = originalAmbient
        LightingService.OutdoorAmbient = originalOutdoorAmbient
        LightingService.ClockTime = originalClockTime
        LightingService.FogEnd = originalFogEnd
        LightingService.FogStart = originalFogStart
        
        -- Re-enable sun rays and blur if they exist
        if LightingService:FindFirstChild("SunRays") then
            LightingService.SunRays.Enabled = true
        end
        
        if LightingService:FindFirstChild("Blur") then
            LightingService.Blur.Enabled = true
        end
        
        -- Remove NV color correction
        if LightingService:FindFirstChild("NVColorCorrection") then
            LightingService.NVColorCorrection.Enabled = false
        end
    end
end)

LightingSection:NewSlider("Brightness", "Adjust game brightness", 10, 0, function(value)
    LightingService.Brightness = value
    originalBrightness = value
end)

LightingSection:NewToggle("Full Bright", "Maximum brightness", function(state)
    if state then
        originalBrightness = LightingService.Brightness
        LightingService.Brightness = 5
        LightingService.ClockTime = 12
        LightingService.FogEnd = 100000
        LightingService.GlobalShadows = false
    else
        LightingService.Brightness = originalBrightness
        LightingService.ClockTime = originalClockTime
        LightingService.FogEnd = originalFogEnd
        LightingService.GlobalShadows = true
    end
end)

LightingSection:NewDropdown("Time of Day", "Change in-game time", {"Morning", "Noon", "Evening", "Night"}, function(val)
    if val == "Morning" then
        LightingService.ClockTime = 8
    elseif val == "Noon" then
        LightingService.ClockTime = 12
    elseif val == "Evening" then
        LightingService.ClockTime = 18
    elseif val == "Night" then
        LightingService.ClockTime = 0
    end
end)

-- Game Section (Placeholders for future additions)
GameSection:NewLabel("Game features will be added soon")

-- Settings Section
SettingsSection:NewKeybind("Toggle UI", "Hide/Show the UI", Enum.KeyCode.RightControl, function()
    Library:ToggleUI()
end)

-- Load ESP Library using loadstring without console prints
local function loadESP()
    -- Replace this URL with your actual ESP library URL
    local espUrl = "https://raw.githubusercontent.com/whft/rost/refs/heads/main/esplib.lua"
    
    -- Silently load the ESP with our settings
    local success, result = pcall(function()
        return loadstring(game:HttpGet(espUrl))()
    end)
    
    -- Don't print anything to console
end

-- Add a button to initialize the ESP
MainSection:NewButton("Initialize ESP", "Load the ESP library", function()
    loadESP()
end)

-- Extra feature: Save configuration
SettingsSection:NewButton("Save Config", "Save current settings", function()
    -- Will be implemented later
end)

-- Extra feature: Load configuration
SettingsSection:NewButton("Load Config", "Load saved settings", function()
    -- Will be implemented later
end)
