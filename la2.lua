-- ================================================
-- SKRIP AUTO-HARVEST (METODE HIT LANGSUNG)
-- ================================================

-- BAGIAN 1: "DATABASE" ANDA
local MasterPlantDatabase = {
    ["Tomato"] = "Fruit",
    ["Blueberry"] = "Berry",
    ["Strawberry"] = "Berry"
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
-- BAGIAN 3: MENEBAK LOKASI "HIT" (REMOTE EVENT)
-- ================================================

-- Berdasarkan 'autofarm.lua', event ada di ReplicatedStorage.GameEvents
local ReplicatedEvents = game:GetService("ReplicatedStorage"):FindFirstChild("GameEvents")

-- Di sinilah kita "menebak-nebak" seperti yang Anda minta.
-- Kita akan mencoba beberapa nama yang paling umum.
local HarvestEvent_Tebakan = nil

if ReplicatedEvents then
    print("Mencari RemoteEvent panen...")
    -- Coba tebakan pertama:
    HarvestEvent_Tebakan = ReplicatedEvents:FindFirstChild("HarvestPlant")
    
    -- Coba tebakan kedua jika yang pertama gagal:
    if not HarvestEvent_Tebakan then
        HarvestEvent_Tebakan = ReplicatedEvents:FindFirstChild("Harvest")
    end
    
    -- Coba tebakan ketiga:
    if not HarvestEvent_Tebakan then
        HarvestEvent_Tebakan = ReplicatedEvents:FindFirstChild("Harvest_RE")
    end
else
    print("Error: Folder 'GameEvents' tidak ditemukan di ReplicatedStorage.")
end

if HarvestEvent_Tebakan then
    print("SUKSES! Tebakan kita menemukan RemoteEvent bernama: " .. HarvestEvent_Tebakan.Name)
else
    print("PERINGATAN: Gagal menemukan RemoteEvent panen. Semua tebakan salah.")
end


-- ================================================
-- BAGIAN 4: FUNGSI-FUNGSI PENDUKUNG (SAMA SEPERTI SEBELUMNYA)
-- ================================================

function HapusTagHTML(teks)
    return string.gsub(teks, "<[^>]*>", "")
end

function DapatkanTargetEvent()
    for i, objek in pairs(workspace:GetDescendants()) do
        if objek:IsA("TextLabel") and string.find(objek.Text, "looking for") then
            local teksBersih = HapusTagHTML(objek.Text)
            local targetTipe = teksBersih:match("looking for (.*) Plants")
            if targetTipe then return targetTipe end
        end
    end
    print("Target Event tidak ditemukan (Gelembung quest tidak aktif).")
    return nil
end

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
-- BAGIAN 5: LOGIKA AKSI BARU (METODE "HIT LANGSUNG")
-- ================================================

local function LakukanSiklusPanen_RemoteEvent()
    
    -- Cek #1: Pastikan tebakan RemoteEvent kita berhasil ditemukan
    if not HarvestEvent_Tebakan then
        print("Siklus dibatalkan: RemoteEvent untuk panen tidak ditemukan.")
        return -- Hentikan fungsi
    end
    
    local tipeTargetEvent = DapatkanTargetEvent()
    if not tipeTargetEvent then return end 
    
    local pemainLokal = game.Players.LocalPlayer
    local kebunPemain = DapatkanKebunPemain(pemainLokal.Name)
    if not kebunPemain then return end 
    
    local folderTanaman = kebunPemain.Important.Plants_Physical
    print("Memulai siklus 'Hit Langsung' untuk Tipe: " .. tipeTargetEvent)

    for i, tanaman in pairs(folderTanaman:GetChildren()) do
        
        if not isAutoHarvestOn then break end 
        
        local namaTanaman = tanaman.Name
        local tipeTanamanIni = MasterPlantDatabase[namaTanaman]
        
        -- FILTER UTAMA
        if tipeTanamanIni and tipeTanamanIni == tipeTargetEvent then
            
            -- Kita tidak perlu memeriksa 'prompt.Enabled'
            -- Kita anggap saja jika sudah ada, kita panen
            
            print("Lolos Filter: " .. namaTanaman .. ". Mengirim 'Hit' ke server...")
            
            -- !!! INI DIA AKSINYA !!!
            -- Tidak perlu teleport. Tidak perlu jalan.
            -- Langsung "tembak" server.
            HarvestEvent_Tebakan:FireServer(tanaman)
            
            wait(0.5) -- Beri jeda antar "hit" agar tidak spam
        end
    end
    print("Siklus 'Hit Langsung' selesai.")
end

-- ================================================
-- BAGIAN 6: LOGIKA PENGENDALI (KONEKSI & LOOP)
-- ================================================

TombolToggle.MouseButton1Click:Connect(function()
    isAutoHarvestOn = not isAutoHarvestOn
    if isAutoHarvestOn then
        print("Auto Harvest (Metode Hit): ON")
        TombolToggle.Text = "Auto Harvest: ON"
        TombolToggle.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        LakukanSiklusPanen_RemoteEvent() -- Coba 1x saat dinyalakan
    else
        print("Auto Harvest (Metode Hit): OFF")
        TombolToggle.Text = "Auto Harvest: OFF"
        TombolToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end)

coroutine.wrap(function()
    while true do
        wait(3) -- Cek ulang setiap 3 detik
        if isAutoHarvestOn == true then
            LakukanSiklusPanen_RemoteEvent()
        end
    end
end)()

print("Skrip Auto-Harvest (Metode Hit Langsung) berhasil dimuat!")
