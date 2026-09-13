--//========================================================
--// GALATIC V5 - FULL FIXED V3
--// CUSTOM LIBRARY
--// HORIZONTAL TABS + SCROLL
--// MOBILE FRIENDLY
--// DRAG WINDOW
--// MINIMIZE BUTTON
--// PURPLE THEME
--// FAST REBIRTH
--// FAST FARM
--// SETTINGS
--// FIX LAG V2
--// LOW GRAPHICS
--// AUTO EGG / AUTO SHAKE / FORTUNE WHEEL
--// PET UPDATE:
--// FAST REBIRTH = EQUIP ALL SWIFT SAMURAI
--// FAST REBIRTH = UNEQUIP ALL RARE BOSS PET
--//========================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

--========================================================
-- GUI PARENT / CLEAN OLD GUI
--========================================================

local GUIParent
pcall(function()
    if gethui then
        GUIParent = gethui()
    end
end)

GUIParent = GUIParent or player:WaitForChild("PlayerGui")

pcall(function()
    local old = GUIParent:FindFirstChild("GalaticV5")
    if old then
        old:Destroy()
    end
end)

--========================================================
-- COLORS
--========================================================

local purple = Color3.fromRGB(155, 80, 255)
local purpleDark = Color3.fromRGB(95, 35, 160)
local purpleLight = Color3.fromRGB(190, 120, 255)
local background = Color3.fromRGB(18, 18, 22)
local itemBackground = Color3.fromRGB(27, 27, 33)
local tabBackground = Color3.fromRGB(35, 25, 45)
local white = Color3.fromRGB(245, 245, 250)
local gray = Color3.fromRGB(170, 170, 180)
local green = Color3.fromRGB(90, 220, 120)
local red = Color3.fromRGB(240, 80, 80)

--========================================================
-- UTILITIES
--========================================================

local function getValue(obj, default)
    if not obj then
        return default
    end

    local ok, value = pcall(function()
        return obj.Value
    end)

    if ok and value ~= nil then
        return value
    end

    return default
end

local function formatNumber(n)
    n = tonumber(n) or 0

    if math.abs(n) >= 1e12 then
        return string.format("%.2fT", n / 1e12)
    elseif math.abs(n) >= 1e9 then
        return string.format("%.2fB", n / 1e9)
    elseif math.abs(n) >= 1e6 then
        return string.format("%.2fM", n / 1e6)
    elseif math.abs(n) >= 1e3 then
        return string.format("%.2fK", n / 1e3)
    end

    return tostring(math.floor(n))
end

local function formatTime(sec)
    sec = math.max(0, math.floor(tonumber(sec) or 0))

    local h = math.floor(sec / 3600)
    local m = math.floor((sec % 3600) / 60)
    local s = sec % 60

    return string.format("%02d:%02d:%02d", h, m, s)
end

local function formatShortTime(sec)
    sec = math.max(0, math.floor(tonumber(sec) or 0))

    if sec >= 3600 then
        return string.format("%dh %02dm", math.floor(sec / 3600), math.floor((sec % 3600) / 60))
    elseif sec >= 60 then
        return string.format("%dm %02ds", math.floor(sec / 60), sec % 60)
    end

    return string.format("%ds", sec)
end

local function formatMinuteTime(sec)
    sec = math.max(0, math.floor(tonumber(sec) or 0))
    return string.format("%02d:%02d", math.floor(sec / 60), sec % 60)
end

local function notify(text, duration)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "GALATIC V5",
            Text = tostring(text),
            Duration = duration or 3
        })
    end)
end

--========================================================
-- CHARACTER / DATA
--========================================================

local function getCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

local function getRoot()
    local char = getCharacter()
    return char and (char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart)
end

local function getLeaderstats()
    return player:FindFirstChild("leaderstats")
end

local function getStat(name)
    local ls = getLeaderstats()
    return ls and ls:FindFirstChild(name)
end

local strengthStat
local rebirthsStat
local durabilityStat
local muscleEvent

local function refreshRefs()
    strengthStat = getStat("Strength")
    rebirthsStat = getStat("Rebirths")
    durabilityStat = getStat("Durability")

    local events = ReplicatedStorage:FindFirstChild("rEvents")
    muscleEvent = events and events:FindFirstChild("muscleEvent")
end

refreshRefs()

task.spawn(function()
    while task.wait(2) do
        refreshRefs()
    end
end)

--========================================================
-- SCREEN GUI
--========================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GalaticV5"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999999
ScreenGui.Parent = GUIParent

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(440, 330)
Main.Position = UDim2.new(0.5, -220, 0.5, -165)
Main.BackgroundColor3 = background
Main.BackgroundTransparency = 0.04
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = purple
MainStroke.Thickness = 2
MainStroke.Parent = Main

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 48)
Header.BackgroundColor3 = purpleDark
Header.BorderSizePixel = 0
Header.Parent = Main

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 14)
HeaderCorner.Parent = Header

local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 15)
HeaderFix.Position = UDim2.new(0, 0, 1, -15)
HeaderFix.BackgroundColor3 = purpleDark
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = Header

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, -55, 1, 0)
Title.Position = UDim2.fromOffset(14, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "GALATIC V5"
Title.TextColor3 = white
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.fromOffset(38, 32)
Minimize.Position = UDim2.new(1, -43, 0, 8)
Minimize.BackgroundColor3 = purple
Minimize.Text = "−"
Minimize.TextColor3 = white
Minimize.TextSize = 20
Minimize.Font = Enum.Font.GothamBold
Minimize.AutoButtonColor = false
Minimize.Parent = Header

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 9)
MinCorner.Parent = Minimize

--========================================================
-- TABS
--========================================================

local TabHolder = Instance.new("ScrollingFrame")
TabHolder.Name = "TabHolder"
TabHolder.Size = UDim2.new(1, -16, 0, 40)
TabHolder.Position = UDim2.fromOffset(8, 54)
TabHolder.BackgroundTransparency = 1
TabHolder.BorderSizePixel = 0
TabHolder.ScrollBarThickness = 2
TabHolder.ScrollBarImageColor3 = purple
TabHolder.ScrollingDirection = Enum.ScrollingDirection.X
TabHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
TabHolder.AutomaticCanvasSize = Enum.AutomaticSize.X
TabHolder.Parent = Main

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 6)
TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TabLayout.Parent = TabHolder

local ContentHolder = Instance.new("Frame")
ContentHolder.Size = UDim2.new(1, -16, 1, -102)
ContentHolder.Position = UDim2.fromOffset(8, 96)
ContentHolder.BackgroundTransparency = 1
ContentHolder.BorderSizePixel = 0
ContentHolder.Parent = Main

local Tabs = {}
local CurrentTab

local function createTab(name)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.fromOffset(120, 34)
    button.BackgroundColor3 = tabBackground
    button.Text = name
    button.TextColor3 = white
    button.TextSize = 13
    button.Font = Enum.Font.GothamBold
    button.AutoButtonColor = false
    button.Parent = TabHolder

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 9)
    corner.Parent = button

    local stroke = Instance.new("UIStroke")
    stroke.Color = purpleDark
    stroke.Thickness = 1
    stroke.Parent = button

    local page = Instance.new("ScrollingFrame")
    page.Name = name .. "Page"
    page.Size = UDim2.fromScale(1, 1)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = purple
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Visible = false
    page.Parent = ContentHolder

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 7)
    layout.Parent = page

    local padding = Instance.new("UIPadding")
    padding.PaddingBottom = UDim.new(0, 10)
    padding.Parent = page

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 15)
    end)

    local tab = {
        Button = button,
        Page = page
    }

    Tabs[name] = tab

    button.MouseButton1Click:Connect(function()
        for _, other in pairs(Tabs) do
            other.Page.Visible = false
            other.Button.BackgroundColor3 = tabBackground
        end

        page.Visible = true
        button.BackgroundColor3 = purpleDark
        CurrentTab = tab
    end)

    return page
end

--========================================================
-- UI HELPERS
--========================================================

local function addLabel(parent, text, height)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, height or 28)
    label.BackgroundColor3 = itemBackground
    label.BackgroundTransparency = 0.1
    label.BorderSizePixel = 0
    label.Text = text
    label.TextColor3 = white
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent

    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.Parent = label

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 9)
    corner.Parent = label

    return label
end

local function addSection(parent, text)
    local label = addLabel(parent, "⚡ " .. text, 31)
    label.BackgroundColor3 = purpleDark
    label.Font = Enum.Font.GothamBold
    return label
end

local function addButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 34)
    button.BackgroundColor3 = itemBackground
    button.Text = text
    button.TextColor3 = white
    button.TextSize = 13
    button.Font = Enum.Font.GothamBold
    button.AutoButtonColor = false
    button.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 9)
    corner.Parent = button

    local stroke = Instance.new("UIStroke")
    stroke.Color = purpleDark
    stroke.Thickness = 1
    stroke.Parent = button

    button.MouseButton1Click:Connect(function()
        if callback then
            task.spawn(callback)
        end
    end)

    return button
end

local function addSwitch(parent, text, default, callback)
    local state = default == true

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 36)
    button.BackgroundColor3 = itemBackground
    button.TextColor3 = white
    button.TextSize = 13
    button.Font = Enum.Font.GothamBold
    button.AutoButtonColor = false
    button.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 9)
    corner.Parent = button

    local function update()
        button.Text = text .. "  [" .. (state and "ON" or "OFF") .. "]"
        button.BackgroundColor3 = state and purpleDark or itemBackground
    end

    button.MouseButton1Click:Connect(function()
        state = not state
        update()

        if callback then
            task.spawn(function()
                callback(state)
            end)
        end
    end)

    update()

    return button, function()
        return state
    end
end

local function addSlider(parent, text, minValue, maxValue, defaultValue, callback)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 0, 58)
    holder.BackgroundColor3 = itemBackground
    holder.BorderSizePixel = 0
    holder.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 9)
    corner.Parent = holder

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 25)
    label.Position = UDim2.fromOffset(10, 2)
    label.BackgroundTransparency = 1
    label.TextColor3 = white
    label.TextSize = 12
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = holder

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -20, 0, 8)
    bar.Position = UDim2.fromOffset(10, 38)
    bar.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
    bar.BorderSizePixel = 0
    bar.Parent = holder

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = bar

    local fill = Instance.new("Frame")
    fill.BackgroundColor3 = purple
    fill.BorderSizePixel = 0
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.Parent = bar

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill

    local value = tonumber(defaultValue) or minValue
    local dragging = false

    local function setValue(v)
        value = math.clamp(math.floor(v + 0.5), minValue, maxValue)
        local alpha = (value - minValue) / (maxValue - minValue)
        fill.Size = UDim2.new(alpha, 0, 1, 0)
        label.Text = text .. ": " .. tostring(value)

        if callback then
            callback(value)
        end
    end

    local function fromInput(input)
        local x = input.Position.X
        local alpha = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        setValue(minValue + (maxValue - minValue) * alpha)
    end

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            fromInput(input)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            fromInput(input)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    setValue(value)

    return holder, function()
        return value
    end
end

--========================================================
-- DRAG
--========================================================

do
    local dragging = false
    local dragStart
    local startPos

    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            dragStart = input.Position
            startPos = Main.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if not dragging then
            return
        end

        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then

            local delta = input.Position - dragStart

            Main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

--========================================================
-- PET SYSTEM
--========================================================

local function getPetObjects()
    local petsFolder = player:FindFirstChild("petsFolder")
    local events = ReplicatedStorage:FindFirstChild("rEvents")
    local equipEvent = events and events:FindFirstChild("equipPetEvent")
    local unique = petsFolder and petsFolder:FindFirstChild("Unique")

    return petsFolder, unique, equipEvent
end

local function getPetName(pet)
    if not pet then
        return ""
    end

    local ok, name = pcall(function()
        return pet.Name
    end)

    return ok and tostring(name) or ""
end

local function firePetAction(action, pet)
    local _, _, equipEvent = getPetObjects()

    if not equipEvent or not pet then
        return false
    end

    return pcall(function()
        equipEvent:FireServer(action, pet)
    end)
end

--========================================================
-- NEW PET LOGIC
--
-- FAST REBIRTH:
-- 1. Tháo toàn bộ pet đang trang bị.
-- 2. Trang bị TOÀN BỘ pet có tên "Swift Samurai".
--
-- SAU KHI ĐẠT MỤC TIÊU:
-- 1. Tháo toàn bộ pet đang trang bị.
-- 2. Trang bị TOÀN BỘ pet có tên "Rare Boss Pet".
--
-- Không giới hạn 9 pet trong 2 hàm này; server/game sẽ tự
-- quyết định slot hợp lệ.
--========================================================

local function unequipAllPets()
    local petsFolder, unique, equipEvent = getPetObjects()

    if not equipEvent then
        notify("Không tìm thấy equipPetEvent", 3)
        return 0
    end

    local count = 0

    -- Một số server lưu pet trực tiếp trong petsFolder.
    -- Ưu tiên Unique nếu có để tránh bỏ sót inventory pet.
    local source = unique or petsFolder

    if not source then
        notify("Không tìm thấy petsFolder", 3)
        return 0
    end

    for _, pet in ipairs(source:GetChildren()) do
        if pet:IsA("Folder") or pet:IsA("Model") or pet:IsA("Configuration") then
            if firePetAction("unequipPet", pet) then
                count += 1
                task.wait(0.03)
            end
        end
    end

    return count
end

local function equipAllNamedPets(petName)
    local petsFolder, unique, equipEvent = getPetObjects()

    if not equipEvent then
        notify("Không tìm thấy equipPetEvent", 3)
        return 0
    end

    local source = unique or petsFolder

    if not source then
        notify("Không tìm thấy petsFolder", 3)
        return 0
    end

    local matched = {}

    for _, pet in ipairs(source:GetChildren()) do
        if pet:IsA("Folder") or pet:IsA("Model") or pet:IsA("Configuration") then
            if getPetName(pet):lower() == tostring(petName):lower() then
                table.insert(matched, pet)
            end
        end
    end

    if #matched == 0 then
        notify("Không tìm thấy pet: " .. tostring(petName), 3)
        return 0
    end

    local equipped = 0

    for _, pet in ipairs(matched) do
        if firePetAction("equipPet", pet) then
            equipped += 1
            task.wait(0.04)
        end
    end

    return equipped
end

-- Fast Farm giữ nguyên pet cũ.
local function equipFarmingPets()
    unequipAllPets()

    local _, unique = getPetObjects()
    if not unique then
        return
    end

    local names = {
        "Omega Overlord",
        "Swift Samurai",
        "Powercore Hound"
    }

    for _, name in ipairs(names) do
        local petFound = false

        for _, pet in ipairs(unique:GetChildren()) do
            if getPetName(pet):lower() == name:lower() then
                firePetAction("equipPet", pet)
                petFound = true
                task.wait(0.04)
            end
        end

        if petFound then
            -- tiếp tục tìm các bản duplicate cùng tên
        end
    end
end

-- NEW:
-- Fast Rebirth trước khi farm/rebirth:
-- tháo toàn bộ -> trang bị TOÀN BỘ Swift Samurai.
local function equipFastRebirthPets()
    unequipAllPets()
    task.wait(0.08)

    local count = equipAllNamedPets("Swift Samurai")

    if count > 0 then
        notify("Fast Rebirth: đã trang bị toàn bộ Swift Samurai (" .. count .. ")", 2)
    end
end

-- NEW:
-- Khi chuẩn bị rebirth:
-- tháo toàn bộ -> trang bị TOÀN BỘ Rare Boss Pet.
local function equipRareBossPets()
    unequipAllPets()
    task.wait(0.08)

    local count = equipAllNamedPets("Rare Boss Pet")

    if count > 0 then
        notify("Fast Rebirth: đã trang bị toàn bộ Rare Boss Pet (" .. count .. ")", 2)
    end
end

local function equipBestFastRepPets()
    equipAllNamedPets("Swift Samurai")
    notify("Đã trang bị toàn bộ Swift Samurai", 2)
end

--========================================================
-- FAST REBIRTH
--========================================================

local FastRebirthPage = createTab("Fast Rebirth")

addSection(FastRebirthPage, "FAST REBIRTH")

local rebirthStatus = addLabel(FastRebirthPage, "Status: OFF", 32)
local rebirthInfo = addLabel(FastRebirthPage, "Strength: 0 | Rebirths: 0", 32)
local rebirthPace = addLabel(FastRebirthPage, "Pace: --", 32)

local rebirthRunning = false
local rebirthStartCount = 0
local rebirthStartTime = 0
local rebirthLastCount = 0
local rebirthLastTime = 0

local function performRebirth()
    refreshRefs()

    if not muscleEvent then
        return false
    end

    local rebirths = getValue(rebirthsStat, 0)
    local target = 5000 + (rebirths * 2550)

    -- Farm bằng Swift Samurai.
    equipFastRebirthPets()

    local safety = 0
    while rebirthRunning and getValue(strengthStat, 0) < target do
        safety += 1

        local amount = 12

        pcall(function()
            for i = 1, amount do
                muscleEvent:FireServer("rep")
            end
        end)

        task.wait(0.02)

        if safety % 100 == 0 then
            refreshRefs()
        end

        if safety > 20000 then
            break
        end
    end

    if not rebirthRunning then
        return false
    end

    -- Đạt mục tiêu -> tháo toàn bộ -> trang bị toàn bộ Rare Boss Pet.
    equipRareBossPets()
    task.wait(0.25)

    local events = ReplicatedStorage:FindFirstChild("rEvents")
    local rebirthRemote = events and events:FindFirstChild("rebirthRemote")

    if not rebirthRemote then
        return false
    end

    local before = getValue(rebirthsStat, 0)

    for _ = 1, 10 do
        if not rebirthRunning then
            break
        end

        pcall(function()
            rebirthRemote:InvokeServer("rebirthRequest")
        end)

        task.wait(0.12)
        refreshRefs()

        if getValue(rebirthsStat, 0) > before then
            return true
        end
    end

    return getValue(rebirthsStat, 0) > before
end

local function startRebirthLoop()
    if rebirthRunning then
        return
    end

    rebirthRunning = true
    rebirthStartCount = getValue(rebirthsStat, 0)
    rebirthStartTime = os.clock()
    rebirthLastCount = rebirthStartCount
    rebirthLastTime = os.clock()

    notify("Fast Rebirth ON", 2)

    task.spawn(function()
        while rebirthRunning do
            refreshRefs()

            local ok = performRebirth()

            local now = os.clock()
            local current = getValue(rebirthsStat, 0)

            if current ~= rebirthLastCount then
                local elapsed = math.max(0.01, now - rebirthLastTime)
                local gained = current - rebirthLastCount
                local perMinute = gained * 60 / elapsed

                rebirthPace.Text = "Pace: " .. string.format("%.2f", perMinute) .. " rebirth/min"

                rebirthLastCount = current
                rebirthLastTime = now
            end

            rebirthInfo.Text =
                "Strength: " .. formatNumber(getValue(strengthStat, 0))
                .. " | Rebirths: " .. formatNumber(current)

            if not ok then
                task.wait(0.5)
            end
        end

        rebirthStatus.Text = "Status: OFF"
    end)
end

local function stopRebirthLoop()
    rebirthRunning = false
    rebirthStatus.Text = "Status: OFF"
    notify("Fast Rebirth OFF", 2)
end

local rebirthSwitch = addSwitch(
    FastRebirthPage,
    "Fast Rebirth",
    false,
    function(state)
        if state then
            rebirthStatus.Text = "Status: ON"
            startRebirthLoop()
        else
            stopRebirthLoop()
        end
    end
)

addButton(FastRebirthPage, "Equip ALL Swift Samurai", function()
    equipFastRebirthPets()
end)

addButton(FastRebirthPage, "Equip ALL Rare Boss Pet", function()
    equipRareBossPets()
end)

addButton(FastRebirthPage, "Unequip ALL Pets", function()
    local count = unequipAllPets()
    notify("Đã tháo " .. tostring(count) .. " pet", 2)
end)

--========================================================
-- FAST FARM
--========================================================

local FastFarmPage = createTab("Fast Farm")

addSection(FastFarmPage, "FAST FARM")

local farmStatus = addLabel(FastFarmPage, "Status: OFF", 32)
local farmStats = addLabel(FastFarmPage, "Rep: 0 | Ping: --", 32)

local repSpeed = 350
local farmRunning = false
local controlledSpeed = true

addSlider(
    FastFarmPage,
    "Rep Speed",
    1,
    1000,
    repSpeed,
    function(v)
        repSpeed = v
    end
)

local function getPing()
    local ok, value = pcall(function()
        return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    end)

    if ok then
        return tonumber(value) or 0
    end

    return 0
end

local function getAdaptiveSpeed()
    local ping = getPing()

    if not controlledSpeed then
        return repSpeed
    end

    if ping < 80 then
        return math.max(repSpeed, 500)
    elseif ping < 150 then
        return math.min(repSpeed, 300)
    elseif ping < 250 then
        return math.min(repSpeed, 100)
    end

    return math.min(repSpeed, 50)
end

local function startFarm()
    if farmRunning then
        return
    end

    farmRunning = true
    farmStatus.Text = "Status: ON"

    task.spawn(function()
        while farmRunning do
            refreshRefs()

            if muscleEvent then
                local amount = getAdaptiveSpeed()

                for i = 1, amount do
                    if not farmRunning then
                        break
                    end

                    pcall(function()
                        muscleEvent:FireServer("rep")
                    end)

                    if i % 500 == 0 then
                        task.wait()
                    end
                end
            end

            local ping = getPing()
            farmStats.Text =
                "Rep: " .. tostring(getAdaptiveSpeed())
                .. " | Ping: " .. tostring(math.floor(ping)) .. "ms"

            task.wait(math.clamp(ping / 2500, 0.001, 0.1))
        end
    end)
end

local function stopFarm()
    farmRunning = false
    farmStatus.Text = "Status: OFF"
end

addSwitch(FastFarmPage, "Fast Farm", false, function(state)
    if state then
        startFarm()
    else
        stopFarm()
    end
end)

addSwitch(FastFarmPage, "Controlled Speed", true, function(state)
    controlledSpeed = state
end)

--========================================================
-- SETTINGS
--========================================================

local SettingsPage = createTab("Settings")

addSection(SettingsPage, "PLAYER")

local setSizeRunning = false
local lockPositionRunning = false
local hideStatsRunning = false
local antiAFKRunning = true

local function setSizeLoop(state)
    setSizeRunning = state

    if not state then
        return
    end

    task.spawn(function()
        while setSizeRunning do
            local events = ReplicatedStorage:FindFirstChild("rEvents")
            local remote = events and events:FindFirstChild("changeSpeedSizeRemote")

            if remote then
                pcall(function()
                    remote:InvokeServer("changeSize", 1)
                end)
            end

            task.wait(0.05)
        end
    end)
end

addSwitch(SettingsPage, "Set Size 1", false, setSizeLoop)

local positionLocker

local function removePositionLock()
    lockPositionRunning = false

    if positionLocker then
        pcall(function()
            positionLocker:Destroy()
        end)
        positionLocker = nil
    end
end

local function startPositionLock()
    removePositionLock()

    local root = getRoot()
    if not root then
        return
    end

    lockPositionRunning = true

    positionLocker = Instance.new("BodyPosition")
    positionLocker.Name = "GalaticPositionLocker"
    positionLocker.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    positionLocker.P = 100000
    positionLocker.D = 1000
    positionLocker.Position = root.Position
    positionLocker.Parent = root

    task.spawn(function()
        while lockPositionRunning and positionLocker and positionLocker.Parent do
            pcall(function()
                positionLocker.Position = root.Position
            end)
            task.wait(0.1)
        end
    end)
end

addSwitch(SettingsPage, "Lock Position", false, function(state)
    if state then
        startPositionLock()
    else
        removePositionLock()
    end
end)

--========================================================
-- FIX LAG V2
--========================================================

addSection(SettingsPage, "PERFORMANCE")

local fixLagRunning = false
local savedLighting = {}
local savedTerrain = {}
local disabledEffects = {}

local function isHeavyEffect(obj)
    return obj:IsA("ParticleEmitter")
        or obj:IsA("Trail")
        or obj:IsA("Beam")
        or obj:IsA("Smoke")
        or obj:IsA("Fire")
        or obj:IsA("Sparkles")
end

local function disableEffect(obj)
    if not isHeavyEffect(obj) then
        return
    end

    if disabledEffects[obj] == nil then
        local ok, enabled = pcall(function()
            return obj.Enabled
        end)

        if ok then
            disabledEffects[obj] = enabled
        end
    end

    pcall(function()
        obj.Enabled = false
    end)
end

local effectConnection

local function enableFixLag()
    if fixLagRunning then
        return
    end

    fixLagRunning = true

    savedLighting.GlobalShadows = Lighting.GlobalShadows
    savedLighting.FogEnd = Lighting.FogEnd
    savedLighting.FogStart = Lighting.FogStart
    savedLighting.Brightness = Lighting.Brightness

    local terrain = Workspace:FindFirstChildOfClass("Terrain")

    if terrain then
        savedTerrain.WaterWaveSize = terrain.WaterWaveSize
        savedTerrain.WaterWaveSpeed = terrain.WaterWaveSpeed
        savedTerrain.WaterReflectance = terrain.WaterReflectance
        savedTerrain.WaterTransparency = terrain.WaterTransparency
    end

    for _, obj in ipairs(game:GetDescendants()) do
        disableEffect(obj)
    end

    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end)

    Lighting.GlobalShadows = false
    Lighting.Brightness = 1
    Lighting.FogStart = 0
    Lighting.FogEnd = 100000

    if terrain then
        terrain.WaterWaveSize = 0
        terrain.WaterWaveSpeed = 0
        terrain.WaterReflectance = 0
        terrain.WaterTransparency = 1
    end

    effectConnection = game.DescendantAdded:Connect(function(obj)
        if fixLagRunning then
            task.defer(function()
                disableEffect(obj)
            end)
        end
    end)
end

local function disableFixLag()
    fixLagRunning = false

    if effectConnection then
        effectConnection:Disconnect()
        effectConnection = nil
    end

    for obj, enabled in pairs(disabledEffects) do
        if obj and obj.Parent then
            pcall(function()
                obj.Enabled = enabled
            end)
        end
    end

    disabledEffects = {}

    for property, value in pairs(savedLighting) do
        pcall(function()
            Lighting[property] = value
        end)
    end

    savedLighting = {}

    local terrain = Workspace:FindFirstChildOfClass("Terrain")

    if terrain then
        for property, value in pairs(savedTerrain) do
            pcall(function()
                terrain[property] = value
            end)
        end
    end

    savedTerrain = {}
end

addSwitch(SettingsPage, "Fix Lag V2", false, function(state)
    if state then
        enableFixLag()
    else
        disableFixLag()
    end
end)

addSwitch(SettingsPage, "Low Graphics", false, function(state)
    if state then
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        end)
    end
end)

--========================================================
-- HIDE GAME STATS
--========================================================

local savedGuiStates = {}
local hideConnection

local function isGalaticGui(gui)
    local name = tostring(gui.Name):lower()
    return name:find("galatic") ~= nil
end

local function hideGameStats()
    if hideStatsRunning then
        return
    end

    hideStatsRunning = true

    local pg = player:FindFirstChildOfClass("PlayerGui")

    if pg then
        for _, gui in ipairs(pg:GetChildren()) do
            if gui:IsA("ScreenGui") and not isGalaticGui(gui) then
                savedGuiStates[gui] = gui.Enabled

                pcall(function()
                    gui.Enabled = false
                end)
            end
        end

        hideConnection = pg.ChildAdded:Connect(function(gui)
            if hideStatsRunning and gui:IsA("ScreenGui") and not isGalaticGui(gui) then
                task.wait()

                savedGuiStates[gui] = gui.Enabled

                pcall(function()
                    gui.Enabled = false
                end)
            end
        end)
    end
end

local function showGameStats()
    hideStatsRunning = false

    if hideConnection then
        hideConnection:Disconnect()
        hideConnection = nil
    end

    for gui, enabled in pairs(savedGuiStates) do
        if gui and gui.Parent then
            pcall(function()
                gui.Enabled = enabled
            end)
        end
    end

    savedGuiStates = {}
end

addSwitch(SettingsPage, "Hide Game Stats", false, function(state)
    if state then
        hideGameStats()
    else
        showGameStats()
    end
end)

--========================================================
-- ANTI AFK
--========================================================

addSection(SettingsPage, "ANTI AFK / TIMER")

local antiAFKLabel = addLabel(SettingsPage, "Anti AFK: ON | Session: 00:00:00", 32)

local sessionStart = os.clock()

local function setupAntiAFK()
    pcall(function()
        player.Idled:Connect(function()
            if antiAFKRunning then
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end
        end)
    end)
end

setupAntiAFK()

addSwitch(SettingsPage, "Anti AFK", true, function(state)
    antiAFKRunning = state
end)

addButton(SettingsPage, "Reset Session Timer", function()
    sessionStart = os.clock()
end)

task.spawn(function()
    while ScreenGui.Parent do
        local elapsed = os.clock() - sessionStart
        antiAFKLabel.Text =
            "Anti AFK: " .. (antiAFKRunning and "ON" or "OFF")
            .. " | Session: " .. formatTime(elapsed)

        task.wait(1)
    end
end)

--========================================================
-- QOL
--========================================================

addSection(SettingsPage, "QOL")

local eggInfo = addLabel(SettingsPage, "Protein Egg: --", 32)

local function getTool(name)
    local char = player.Character
    local backpack = player:FindFirstChildOfClass("Backpack")

    if char then
        local tool = char:FindFirstChild(name)
        if tool and tool:IsA("Tool") then
            return tool
        end
    end

    if backpack then
        local tool = backpack:FindFirstChild(name)
        if tool and tool:IsA("Tool") then
            return tool
        end
    end

    return nil
end

local autoEgg = false
local autoShake = false
local fortuneWheel = false

addSwitch(SettingsPage, "Auto Egg", false, function(state)
    autoEgg = state
end)

addSwitch(SettingsPage, "Auto Shake", false, function(state)
    autoShake = state
end)

addSwitch(SettingsPage, "Fortune Wheel", false, function(state)
    fortuneWheel = state
end)

task.spawn(function()
    while ScreenGui.Parent do
        if autoEgg and muscleEvent then
            local tool = getTool("Protein Egg")

            if tool then
                pcall(function()
                    muscleEvent:FireServer("proteinEgg", tool)
                end)
            end
        end

        if autoShake and muscleEvent then
            local tool = getTool("Tropical Shake")

            if tool then
                pcall(function()
                    muscleEvent:FireServer("tropicalShake", tool)
                end)
            end
        end

        if fortuneWheel then
            local events = ReplicatedStorage:FindFirstChild("rEvents")
            local remote = events and events:FindFirstChild("openFortuneWheelRemote")
            local shared = ReplicatedStorage:FindFirstChild("shared")
            local catalogs = shared and shared:FindFirstChild("catalogs")
            local chances = catalogs and catalogs:FindFirstChild("fortuneWheelChances")

            if remote and chances then
                local fortune = chances:FindFirstChild("Fortune Wheel")

                if fortune then
                    pcall(function()
                        remote:InvokeServer("openFortuneWheel", fortune)
                    end)
                end
            end
        end

        local boostTimers = player:FindFirstChild("boostTimersFolder")
        local proteinTimer = boostTimers and boostTimers:FindFirstChild("Protein Egg")

        eggInfo.Text =
            "Protein Egg: " ..
            (proteinTimer and formatShortTime(getValue(proteinTimer, 0)) or "--")

        task.wait(1)
    end
end)

addButton(SettingsPage, "Equip ALL Swift Samurai", function()
    equipFastRebirthPets()
end)

addButton(SettingsPage, "Equip ALL Rare Boss Pet", function()
    equipRareBossPets()
end)

--========================================================
-- INDUSTRIAL
--========================================================

addSection(SettingsPage, "INDUSTRIAL")

local function pressE()
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait(0.05)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    end)
end

addButton(SettingsPage, "Industrial Lift", function()
    local root = getRoot()

    if root then
        root.CFrame = CFrame.new(
            -5491.68945,
            81.2379913,
            4643.85791
        )

        task.wait(0.1)
        pressE()
    end
end)

addButton(SettingsPage, "Industrial Squat", function()
    local root = getRoot()

    if root then
        root.CFrame = CFrame.new(
            -5217.25049,
            89.8445511,
            5416.01025
        )

        task.wait(0.1)
        pressE()
    end
end)

--========================================================
-- INFO
--========================================================

local InfoPage = createTab("Info")

addSection(InfoPage, "GALATIC V5 INFO")

addLabel(
    InfoPage,
    "GALATIC V5\n"
    .. "Fast Rebirth / Fast Farm / Settings\n"
    .. "Mobile + PC Friendly\n"
    .. "Creator: TheKingOfGenisis",
    85
)

addLabel(
    InfoPage,
    "FAST REBIRTH PET UPDATE:\n"
    .. "• Trước khi farm: tháo toàn bộ -> trang bị toàn bộ Swift Samurai.\n"
    .. "• Khi đạt mục tiêu rebirth: tháo toàn bộ -> trang bị toàn bộ Rare Boss Pet.\n"
    .. "• Có nút thao tác thủ công cho cả 2 nhóm pet.",
    105
)

addLabel(
    InfoPage,
    "Nếu pet không được equip, kiểm tra tên pet trong Explorer phải đúng:\n"
    .. "Swift Samurai\n"
    .. "Rare Boss Pet",
    65
)

--========================================================
-- MINIMIZE
--========================================================

local minimized = false
local oldSize = Main.Size
local oldPosition = Main.Position

local MiniButton = Instance.new("TextButton")
MiniButton.Name = "MiniButton"
MiniButton.Size = UDim2.fromOffset(55, 55)
MiniButton.Position = UDim2.new(0, 18, 0.5, -27)
MiniButton.BackgroundColor3 = purpleDark
MiniButton.Text = "G"
MiniButton.TextColor3 = white
MiniButton.TextSize = 22
MiniButton.Font = Enum.Font.GothamBold
MiniButton.Visible = false
MiniButton.AutoButtonColor = false
MiniButton.Parent = ScreenGui

local miniCorner = Instance.new("UICorner")
miniCorner.CornerRadius = UDim.new(0, 14)
miniCorner.Parent = MiniButton

local miniStroke = Instance.new("UIStroke")
miniStroke.Color = purple
miniStroke.Thickness = 2
miniStroke.Parent = MiniButton

Minimize.MouseButton1Click:Connect(function()
    minimized = true
    oldSize = Main.Size
    oldPosition = Main.Position

    Main.Visible = false
    MiniButton.Visible = true
end)

MiniButton.MouseButton1Click:Connect(function()
    minimized = false

    Main.Size = oldSize
    Main.Position = oldPosition

    Main.Visible = true
    MiniButton.Visible = false
end)

--========================================================
-- FIRST TAB
--========================================================

local firstTab = Tabs["Fast Rebirth"]

if firstTab then
    firstTab.Page.Visible = true
    firstTab.Button.BackgroundColor3 = purpleDark
    CurrentTab = firstTab
end

--========================================================
-- CHARACTER CLEANUP
--========================================================

player.CharacterAdded:Connect(function()
    task.wait(1)

    if lockPositionRunning then
        startPositionLock()
    end
end)

--========================================================
-- CLEANUP
--========================================================

ScreenGui.AncestryChanged:Connect(function(_, parent)
    if parent then
        return
    end

    rebirthRunning = false
    farmRunning = false
    setSizeRunning = false
    lockPositionRunning = false
    fixLagRunning = false
    hideStatsRunning = false

    pcall(removePositionLock)
    pcall(disableFixLag)
    pcall(showGameStats)
end)

--========================================================
-- LOADED
--========================================================

print("GALATIC V5 loaded successfully.")
print("Fast Rebirth pet setup:")
print("1. Farm = ALL Swift Samurai")
print("2. Rebirth = ALL Rare Boss Pet")

notify("GALATIC V5 loaded successfully", 3)
