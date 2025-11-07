-- ================================================
-- SKRIP AUTO-HARVEST DENGAN UI TOGGLE (VERSI FINAL)
-- ================================================

--[[

  BAGIAN 1: "DATABASE" ANDA (WAJIB DIISI!)
  
  Ini adalah "otak" skrip Anda. Kita harus mengajari skrip
  tanaman apa yang termasuk tipe "Leafy", "Fruit", dll.

]]
local MasterPlantDatabase = {
    -- Ganti ini dengan tanaman Anda yang sebenarnya
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

-- 1. Buat Kanvas (seperti skrip "Halo" Anda)
local MyCanvas = Instance.new("ScreenGui")
MyCanvas.Name = "HarvestUI"
MyCanvas.Parent = game.Players.LocalPlayer.PlayerGui

-- 2. Buat Tombol Toggle
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
-- BAGIAN 3: FUNGSI-FUNGSI PENDUKUNG (MESIN-NYA)
-- (Fungsi-fungsi ini sama seperti yang kita buat sebelumnya)
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
            local dataOwner = farm:FindFirstFirsChild("Important"):FindFirstChild("Data"):FindFirstChild("Owner")
            if dataOwner and dataOwner.Value == namaPemain then
                return farm
            end
        end
    end
    return nil
end

-- Ini adalah FUNGSI MESIN UTAMA kita
-- (Kita gunakan metode Auto-Walk yang aman)
local function LakukanSiklusPanen()
    
    local tipeTargetEvent = DapatkanTargetEvent()
    if not tipeTargetEvent then return end -- Berhenti jika tidak ada quest
    
    local pemainLokal = game.Players.LocalPlayer
    local kebunPemain = DapatkanKebunPemain(pemainLokal.Name)
    local Character = pemainLokal.Character
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    
    if not kebunPemain or not Humanoid then return end
    
    local folderTanaman = kebunPemain.Important.Plants_Physical
    print("Memulai siklus panen untuk Tipe: " .. tipeTargetEvent)

    for i, tanaman in pairs(folderTanaman:GetChildren()) do
        
        -- Berhenti di tengah-tengah jika user mematikan toggle
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
                
                -- Cek lagi, jaga-jaga user mematikan saat kita sedang berjalan
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

-- 1. KONEKSI TOMBOL (Dasbor)
-- Ini adalah kode yang berjalan SAAT ANDA MENGKLIK tombol
TombolToggle.MouseButton1Click:Connect(function()
    
    -- Balikkan nilainya (true jadi false, false jadi true)
    isAutoHarvestOn = not isAutoHarvestOn
    
    -- Perbarui tampilan tombol
    if isAutoHarvestOn then
        print("Auto Harvest: ON")
        TombolToggle.Text = "Auto Harvest: ON"
        TombolToggle.BackgroundColor3 = Color3.fromRGB(50, 200, 50) -- Warna Hijau (ON)
    else
        print("Auto Harvest: OFF")
        TombolToggle.Text = "Auto Harvest: OFF"
        TombolToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Warna Merah (OFF)
    end
end)

-- 2. LOOP UTAMA (Pengemudi)
-- coroutine.wrap() adalah cara aman untuk membuat loop
-- agar tidak membekukan game Anda.
coroutine.wrap(function()
    while true do
        
        -- Ini adalah "tick" utama bot Anda.
        -- Kita akan jalankan cek setiap 10 detik.
        wait(10) 
        
        -- Pengecekan si "Pengemudi"
        if isAutoHarvestOn == true then
            -- Kunci ON! Jalankan mesinnya.
            LakukanSiklusPanen()
        else
            -- Kunci OFF. Diam dan tunggu.
        end
        
    end
end)()

print("Skrip Auto-Harvest dengan UI Toggle berhasil dimuat!")
