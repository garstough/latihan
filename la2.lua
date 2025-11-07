-- ================================================
-- SKRIP AUTO-HARVEST DENGAN UI TOGGLE (VERSI PERBAIKAN V3)
-- ================================================

-- BAGIAN 1: "DATABASE" ANDA
local MasterPlantDatabase = {
    ["Tomato"] = "Fruit",
    ["Blueberry"] = "Berry",
    ["Strawberry"] = "Berry"
    -- Tambahkan tanaman lain yang Anda tahu
}
print("Database tanaman kustom dimuat.")

-- ================================================
-- BAGIAN 2: PENGATURAN UI DAN "STATE"
-- ================================================

local isAutoHarvestOn = false

local MyCanvas = Instance.new("ScreenGui")
MyCanvas.Name = "HarvestUI"
MyCanvas.Parent = game.Players.LocalPlayer.PlayerGui

local TombolToggle = Instance.new("TextButton")
TombolToggle.Name = "ToggleHarvest"
TombolToggle.Text = "Auto Harvest: OFF"
TombolToggle.Size = UDim2.new(0, 200, 0, 50)
TombolToggle.Position = UDim2.new(0, 20, 0, 80)
TombolToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Merah (OFF)
TombolToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
TombolToggle.Font = Enum.Font.SourceSansBold
TombolToggle.TextSize = 18
TombolToggle.Parent = MyCanvas

print("UI Toggle berhasil dibuat.")

-- ================================================
-- BAGIAN 3: FUNGSI-FUNGSI PENDUKUNG (MESIN-NYA)
-- ================================================

function HapusTagHTML(teks)
    local teksBersih = string.gsub(teks, "<[^>]*>", "")
    return teksBersih
end

function DapatkanTargetEvent()
    local targetDitemukan = nil
    for i, objek in pairs(workspace:GetDescendants()) do
        if objek:IsA("TextLabel") then
            if string.find(objek.Text, "looking for") then
                local teksBersih = HapusTagHTML(objek.Text)
                local targetTipe = teksBersih:match("looking for (.*) Plants")
                if targetTipe then
                    targetDitemukan = targetTipe
                    break
                end
            end
        end
    end
    
    if targetDitemukan then
        return targetDitemukan
    else
        print("Target Event tidak ditemukan (Gelembung quest tidak aktif).")
        return nil
    end
end

local function DapatkanKebunPemain(namaPemain)
    local farmFolder = workspace:FindFirstChild("Farm")
    if farmFolder then
        for i, farm in pairs(farmFolder:GetChildren()) do
            
            -- !!! INI ADALAH PERBAIKAN DARI TYPO V2 !!!
            -- Seharusnya 'FindFirstChild', bukan 'FindFirstFirsChild'
            local dataOwner = farm:FindFirstChild("Important"):FindFirstChild("Data"):FindFirstChild("Owner")
            
            if dataOwner and dataOwner.Value == namaPemain then
                return farm
            end
        end
    end
    print("Error: Folder kebun pemain tidak ditemukan.")
    return nil
end

-- Ini adalah FUNGSI MESIN UTAMA kita
local function LakukanSiklusPanen()
    
    local tipeTargetEvent = DapatkanTargetEvent()
    if not tipeTargetEvent then 
        print("Siklus panen dilewati: Tidak ada target event ditemukan.")
        return -- Berhenti jika tidak ada quest
    end
    
    local pemainLokal = game.Players.LocalPlayer
    local kebunPemain = DapatkanKebunPemain(pemainLokal.Name)
    local Character = pemainLokal.Character
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    
    if not kebunPemain or not Humanoid then
        print("Siklus panen dilewati: Kebun atau Humanoid tidak ditemukan.")
        return 
    end
    
    local folderTanaman = kebunPemain.Important.Plants_Physical
    print("Memulai siklus panen untuk Tipe: " .. tipeTargetEvent)

    for i, tanaman in pairs(folderTanaman:GetChildren()) do
        
        if not isAutoHarvestOn then
            print("Toggle dimatikan. Menghentikan siklus panen.")
            break 
        end
        
        local namaTanaman = tanaman.Name
        local tipeTanamanIni = MasterPlantDatabase[namaTanaman]
        
        if tipeTanamanIni and tipeTanamanIni == tipeTargetEvent then
            local prompt = tanaman:FindFirstChild("ProximityPrompt", true)
            if prompt and prompt.Enabled then
                
                print("Bergerak ke: " .. namaTanaman)
                Humanoid:MoveTo(tanaman:GetPivot().Position)
                Humanoid.MoveToFinished:Wait()
                
                if not isAutoHarvestOn then break end 
                
                fireproximityprompt(prompt)
                print("Berhasil memanen " .. namaTanaman)
                wait(1) 
            end
        end
    end
    print("Siklus panen selesai.")
end

-- ================================================
-- BAGIAN 4: LOGIKA PENGENDALI (KONEKSI & LOOP)
-- ================================================

-- 1. KONEKSI TOMBOL
TombolToggle.MouseButton1Click:Connect(function()
    isAutoHarvestOn = not isAutoHarvestOn
    
    if isAutoHarvestOn then
        print("Auto Harvest: ON")
        TombolToggle.Text = "Auto Harvest: ON"
        TombolToggle.BackgroundColor3 = Color3.fromRGB(50, 200, 50) -- Hijau (ON)
        
        print("Menjalankan siklus panen pertama...")
        LakukanSiklusPanen() 
        
    else
        print("Auto Harvest: OFF")
        TombolToggle.Text = "Auto Harvest: OFF"
        TombolToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Merah (OFF)
    end
end)

-- 2. LOOP UTAMA
coroutine.wrap(function()
    while true do
        wait(3) 
        if isAutoHarvestOn == true then
            LakukanSiklusPanen()
        end
    end
end)()

print("Skrip Auto-Harvest dengan UI Toggle (v3) berhasil dimuat!")
