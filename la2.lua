-- ================================================
-- SKRIP AUTO-HARVEST FINAL (METODE HIT LANGSUNG)
-- ================================================

--[[

  BAGIAN 1: "DATABASE" ANDA (WAJIB DIISI!)
  
  Ini adalah "otak" skrip Anda. Kita harus mengajari skrip
  tanaman apa yang termasuk tipe "Leafy", "Fruit", dll.
  (Nama tanaman diambil dari log Anda sebelumnya)
]]
local MasterPlantDatabase = {
    ["Tomato"] = "Fruit",
    ["Blueberry"] = "Berry",
    ["Strawberry"] = "Berry"
    
    -- Tambahkan semua tanaman lain yang Anda tahu di sini
    -- ["NamaTanamanLeafy1"] = "Leafy",
    -- ["NamaTanamanLeafy2"] = "Leafy"
}
print("Database tanaman kustom dimuat.")

-- ================================================
-- BAGIAN 2: PENGATURAN UI DAN "STATE" (KUNCI KONTAK)
-- ================================================

-- Ini adalah "Kunci Kontak" kita. 'false' berarti 'OFF'.
local isAutoHarvestOn = false

-- Buat Kanvas
local MyCanvas = Instance.new("ScreenGui")
MyCanvas.Name = "HarvestUI"
MyCanvas.Parent = game.Players.LocalPlayer.PlayerGui

-- Buat Tombol Toggle
local TombolToggle = Instance.new("TextButton")
TombolToggle.Name = "ToggleHarvest"
TombolToggle.Text = "Auto Harvest: OFF"
TombolToggle.Size = UDim2.new(0, 200, 0, 50)
TombolToggle.Position = UDim2.new(0, 20, 0, 80) -- Posisikan di kiri layar
TombolToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Warna Merah (OFF)
TombolToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
TombolToggle.Font = Enum.Font.SourceSansBold
TombolToggle.TextSize = 18
TombolToggle.Parent = MyCanvas

print("UI Toggle berhasil dibuat.")

-- ================================================
-- BAGIAN 3: LOKASI "HIT" (DARI TEMUAN ANDA)
-- ================================================

-- Ini adalah "hit" yang Anda temukan. Kita tidak perlu menebak lagi.
local HarvestEvent_Benar = game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("Crops"):WaitForChild("Collect")

if HarvestEvent_Benar then
    print("SUKSES! RemoteEvent panen ditemukan di ...Crops:WaitForChild('Collect')")
else
    -- Ini seharusnya tidak terjadi jika temuan Anda benar, tapi ini adalah pengaman
    print("PERINGATAN: Gagal menemukan RemoteEvent di ...Crops:WaitForChild('Collect')")
end


-- ================================================
-- BAGIAN 4: FUNGSI-FUNGSI PENDUKUNG (MESIN-NYA)
-- ================================================

-- Fungsi untuk membersihkan tag HTML (dari Investigasi V6)
function HapusTagHTML(teks)
    local teksBersih = string.gsub(teks, "<[^>]*>", "")
    return teksBersih
end

-- Fungsi untuk menemukan target quest dari gelembung (dari Investigasi V6)
function DapatkanTargetEvent()
    local targetDitemukan = nil
    for i, objek in pairs(workspace:GetDescendants()) do
        if objek:IsA("TextLabel") then
            if string.find(objek.Text, "looking for") then
                local teksBersih = HapusTagHTML(objek.Text)
                local targetTipe = teksBersih:match("looking for (.*) Plants")
                if targetTipe then
                    targetDitemukan = targetTipe -- (Contoh: "Leafy", "Fruit", dll.)
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

-- Fungsi untuk mendapatkan kebun pemain (dari skrip autofarm)
local function DapatkanKebunPemain(namaPemain)
    local farmFolder = workspace:FindFirstChild("Farm")
    if farmFolder then
        for i, farm in pairs(farmFolder:GetChildren()) do
            -- Perbaikan typo dari error log terakhir Anda
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

local function LakukanSiklusPanen_HitLangsung()
    
    -- Cek #1: Pastikan "hit" kita ada
    if not HarvestEvent_Benar then
        print("Siklus dibatalkan: RemoteEvent untuk panen tidak ditemukan.")
        return 
    end
    
    -- Cek #2: Dapatkan quest
    local tipeTargetEvent = DapatkanTargetEvent()
    if not tipeTargetEvent then 
        print("Siklus panen dilewati: Tidak ada target event ditemukan.")
        return 
    end 
    
    -- Cek #3: Dapatkan kebun
    local pemainLokal = game.Players.LocalPlayer
    local kebunPemain = DapatkanKebunPemain(pemainLokal.Name)
    if not kebunPemain then 
        print("Siklus panen dilewati: Kebun tidak ditemukan.")
        return 
    end 
    
    local folderTanaman = kebunPemain.Important.Plants_Physical
    print("Memulai siklus 'Hit Langsung' untuk Tipe: " .. tipeTargetEvent)

    -- Loop ke setiap tanaman di kebun Anda
    for i, tanaman in pairs(folderTanaman:GetChildren()) do
        
        -- Berhenti jika toggle dimatikan
        if not isAutoHarvestOn then break end 
        
        local namaTanaman = tanaman.Name
        
        -- Cari tipenya di "Database" kita (Bagian 1)
        local tipeTanamanIni = MasterPlantDatabase[namaTanaman]
        
        -- FILTER UTAMA: Apakah tipe tanaman ini = tipe quest?
        if tipeTanamanIni and tipeTanamanIni == tipeTargetEvent then
            
            -- LOLOS FILTER!
            print("Lolos Filter: " .. namaTanaman .. ". Mengirim 'Hit' ke server...")
            
            -- !!! INI DIA AKSINYA !!!
            -- Kita mengirim "hit" langsung ke server dengan
            -- objek tanaman yang SEBENARNYA, bukan 'Instance.new()'
            -- Inilah yang akan memanennya dari jauh.
            HarvestEvent_Benar:FireServer(tanaman)
            
            -- Beri jeda singkat antar "hit" agar tidak spam
            wait(0.5) 
        end
    end
    print("Siklus 'Hit Langsung' selesai.")
end

-- ================================================
-- BAGIAN 6: LOGIKA PENGENDALI (KONEKSI & LOOP)
-- ================================================

-- 1. KONEKSI TOMBOL
TombolToggle.MouseButton1Click:Connect(function()
    isAutoHarvestOn = not isAutoHarvestOn
    
    if isAutoHarvestOn then
        print("Auto Harvest (Metode Hit): ON")
        TombolToggle.Text = "Auto Harvest: ON"
        TombolToggle.BackgroundColor3 = Color3.fromRGB(50, 200, 50) -- Hijau
        
        -- Langsung jalankan 1x saat dinyalakan
        print("Menjalankan siklus panen pertama...")
        LakukanSiklusPanen_HitLangsung() 
        
    else
        print("Auto Harvest (Metode Hit): OFF")
        TombolToggle.Text = "Auto Harvest: OFF"
        TombolToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Merah
    end
end)

-- 2. LOOP UTAMA
-- Ini akan otomatis memeriksa ulang setiap 3 detik
coroutine.wrap(function()
    while true do
        wait(3) 
        if isAutoHarvestOn == true then
            -- Jalankan mesin panen jika toggle "ON"
            LakukanSiklusPanen_HitLangsung()
        end
    end
end)()

print("Skrip Auto-Harvest (Metode Hit Langsung V_FINAL) berhasil dimuat!")
