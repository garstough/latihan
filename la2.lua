-- ================================================
-- SKRIP AUTO-HARVEST (METODE HIT LANGSUNG & MULTI-TIPE)
-- ================================================

--[[

  BAGIAN 1: "DATABASE" ANDA (DIPERBARUI!)
  
  Kita sekarang menggunakan tabel di dalam tabel.
  Ini memungkinkan satu tanaman memiliki BANYAK tipe.
]]
local MasterPlantDatabase = {
    -- DIPERBARUI: "Tomato" sekarang memiliki 3 tipe
    ["Tomato"] = { "Fruit", "Vegetable", "Leafy", "Summer" },
    ["Corn"] = { "Fruit", "Vegetable", "Stalky" },
    ["Blueberry"] = { "Berry", "Leafy", "Fruit", "Summer" },
    ["Strawberry"] = { "Berry", "Fruit" },
    ["Coconut"] = { "Fruit","Woody","Tropical" },
    ["Giant Pinecone"] = { "Fruit","Woody","Tropical" },
    ["Mango"] = { "Fruit","Leafy","Tropical","Woody" },
    ["Orange Delight"] = { "Tropical" },
    ["Candy Corn Flower"] = { "Flower", "Stalky" }
    
}

print("Database tanaman multi-tipe dimuat.")

-- ================================================
-- BAGIAN 2: PENGATURAN UI DAN "STATE" (Tidak berubah)
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
-- BAGIAN 3: LOKASI "HIT" (Tidak berubah)
-- ================================================

local HarvestEvent_Benar = game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("Crops"):WaitForChild("Collect")
if HarvestEvent_Benar then
    print("SUKSES! RemoteEvent panen ditemukan di ...Crops:WaitForChild('Collect')")
else
    print("PERINGATAN: Gagal menemukan RemoteEvent di ...Crops:WaitForChild('Collect')")
end


-- ================================================
-- BAGIAN 4: FUNGSI-FUNGSI PENDUKUNG (DENGAN TAMBAHAN)
-- ================================================

-- FUNGSI BARU: Pengecek tipe di dalam daftar
-- Ini akan memeriksa apakah 'targetTipe' (misal "Vegetable")
-- ada di dalam 'daftarTipe' (misal {"Fruit", "Vegetable", "Leafy"})
function ApakahTipeAdaDiDaftar(daftarTipe, targetTipe)
    for i, tipe in pairs(daftarTipe) do
        if tipe == targetTipe then
            return true -- Ditemukan!
        end
    end
    return false -- Tidak ditemukan
end


-- Fungsi untuk membersihkan tag HTML (Tidak berubah)
function HapusTagHTML(teks)
    local teksBersih = string.gsub(teks, "<[^>]*>", "")
    return teksBersih
end

-- Fungsi untuk menemukan target quest dari gelembung (Tidak berubah)
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
        print("Target Event tidak ditemukan (Gelembung quest NPC tidak aktif).")
        return nil
    end
end

-- Fungsi untuk mendapatkan kebun pemain (Tidak berubah)
local function DapatkanKebunPemain(namaPemain)
    local farmFolder = workspace:FindFirstChild("Farm")
    if farmFolder then
        for i, farm in pairs(farmFolder:GetChildren()) do
            local dataOwner = farm:FindFirstChild("Important"):FindFirstChild("Data"):FindFirstChild("Owner")
            if dataOwner and dataOwner.Value == namaPemain then
                return farm
            end
        end
    end
    print("Error: Folder kebun pemain tidak ditemukan.")
    return nil
end

-- ================================================
-- BAGIAN 5: LOGIKA AKSI (DIPERBARUI)
-- ================================================

local function LakukanSiklusPanen_HitLangsung()
    
    if not HarvestEvent_Benar then
        print("Siklus dibatalkan: RemoteEvent tidak ditemukan.")
        return 
    end
    
    local tipeTargetEvent = DapatkanTargetEvent() -- (Contoh: "Vegetable")
    if not tipeTargetEvent then 
        print("Siklus panen dilewati: Tidak ada target event ditemukan.")
        return 
    end 
    
    local pemainLokal = game.Players.LocalPlayer
    local kebunPemain = DapatkanKebunPemain(pemainLokal.Name)
    if not kebunPemain then 
        print("Siklus panen dilewati: Kebun tidak ditemukan.")
        return 
    end 
    
    local folderTanaman = kebunPemain.Important.Plants_Physical
    print("Memulai siklus 'Hit Langsung' untuk Tipe: " .. tipeTargetEvent)

    for i, tanaman in pairs(folderTanaman:GetChildren()) do
        
        if not isAutoHarvestOn then break end 
        
        local namaTanaman = tanaman.Name
        
        -- DAPATKAN DAFTAR TIPE (Contoh: {"Fruit", "Vegetable", "Leafy"})
        local daftarTipeTanamanIni = MasterPlantDatabase[namaTanaman]
        
        -- FILTER UTAMA (DIPERBARUI)
        -- Cek apakah quest ("Vegetable") ada di dalam daftar tipe tanaman
        if daftarTipeTanamanIni and ApakahTipeAdaDiDaftar(daftarTipeTanamanIni, tipeTargetEvent) then
            
            -- LOLOS FILTER!
            print("Lolos Filter: " .. namaTanaman .. ". Mengirim 'Hit' ke server...")
            
            -- AKSI "HIT"
            HarvestEvent_Benar:FireServer(tanaman)
            
            wait(0.5) 
        end
    end
    print("Siklus 'Hit Langsung' selesai.")
end

-- ================================================
-- BAGIAN 6: LOGIKA PENGENDALI (Tidak berubah)
-- ================================================

TombolToggle.MouseButton1Click:Connect(function()
    isAutoHarvestOn = not isAutoHarvestOn
    
    if isAutoHarvestOn then
        print("Auto Harvest (Metode Hit): ON")
        TombolToggle.Text = "Auto Harvest: ON"
        TombolToggle.BackgroundColor3 = Color3.fromRGB(50, 200, 50) 
        print("Menjalankan siklus panen pertama...")
        LakukanSiklusPanen_HitLangsung() 
    else
        print("Auto Harvest (Metode Hit): OFF")
        TombolToggle.Text = "Auto Harvest: OFF"
        TombolToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end)

coroutine.wrap(function()
    while true do
        wait(3) 
        if isAutoHarvestOn == true then
            LakukanSiklusPanen_HitLangsung()
        end
    end
end)()

print("Skrip Auto-Harvest (Multi-Tipe) berhasil dimuat!")
