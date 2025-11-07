-- ================================================
-- FILE LENGKAP AUTO-HARVEST DINAMIS (VERSI TELEPORT)
-- ================================================

-- BAGIAN 1: "DATABASE" ANDA (Sama seperti sebelumnya)
local MasterPlantDatabase = {
    -- Ganti ini dengan tanaman Anda yang sebenarnya
    ["Tomato"] = "Fruit",
    ["Blueberry"] = "Berry",
    ["Strawberry"] = "Berry"
    
}

print("Database tanaman kustom dimuat.")

-- ================================================
-- BAGIAN 2: FUNGSI-FUNGSI PENDUKUNG (Sama seperti sebelumnya)
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
        print("Target Event Ditemukan: " .. targetDitemukan)
        return targetDitemukan
    else
        print("Error: Tidak dapat menemukan gelembung quest. Pastikan Anda dekat NPC.")
        return nil
    end
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
-- BAGIAN 3: LOGIKA UTAMA (DENGAN LOGIKA TELEPORT)
-- ================================================

local function HarvestOtomatisBerdasarkanEvent()
    
    -- 1. Dapatkan tipe target
    local tipeTargetEvent = DapatkanTargetEvent()
    if not tipeTargetEvent then return end
    
    -- 2. Dapatkan kebun DAN karakter pemain
    local pemainLokal = game.Players.LocalPlayer
    local kebunPemain = DapatkanKebunPemain(pemainLokal.Name)
    local Character = pemainLokal.Character
    -- Kita butuh 'HumanoidRootPart' untuk teleportasi
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    
    if not kebunPemain or not HumanoidRootPart then
        print("Error: Kebun atau HumanoidRootPart tidak ditemukan.")
        return
    end
    
    local folderTanaman = kebunPemain.Important.Plants_Physical
    print("Memulai filter panen untuk Tipe: " .. tipeTargetEvent)

    -- 3. Loop ke setiap tanaman
    for i, tanaman in pairs(folderTanaman:GetChildren()) do
        
        local namaTanaman = tanaman.Name
        local tipeTanamanIni = MasterPlantDatabase[namaTanaman]
        
        -- 4. FILTER UTAMA
        if tipeTanamanIni and tipeTanamanIni == tipeTargetEvent then
            
            print("Lolos Filter: " .. namaTanaman .. ". Memeriksa prompt...")
            
            -- 5. AKSI PANEN (VERSI TELEPORT)
            local prompt = tanaman:FindFirstChild("ProximityPrompt", true)
            if prompt and prompt.Enabled then
                
                -- --- PERBAIKAN TELEPORT DIMULAI ---
                
                -- A. Simpan lokasi asli Anda
                local lokasiAsli = HumanoidRootPart.CFrame
                
                -- B. Dapatkan lokasi tanaman (naik sedikit agar tidak di dalam tanah)
                local lokasiTanaman = tanaman:GetPivot().Position + Vector3.new(0, 3, 0)
                
                print("Teleport ke: " .. namaTanaman)
                
                -- C. TELEPORT karakter ke tanaman
                Character:SetPrimaryPartCFrame(CFrame.new(lokasiTanaman))
                
                -- D. Panen (beri jeda sedikit agar game mendeteksi lokasi baru)
                wait(0.1) -- Jeda singkat
                fireproximityprompt(prompt)
                print("Berhasil mengirim perintah panen untuk " .. namaTanaman)
                
                -- E. TUNGGU sebentar
                wait(0.2) 
                
                -- F. TELEPORT KEMBALI ke lokasi asli
                Character:SetPrimaryPartCFrame(lokasiAsli)
                
                -- G. Beri jeda 1 detik agar game bisa memproses
                wait(1) 
                
                -- --- PERBAIKAN TELEPORT SELESAI ---
                
            end
        end
    end
    
    print("Siklus filter panen selesai.")
end

-- ================================================
-- BAGIAN 4: MEMULAI SKRIP
-- ================================================

HarvestOtomatisBerdasarkanEvent()
