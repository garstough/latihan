-- ================================================
-- FILE LENGKAP AUTO-HARVEST DINAMIS (VERSI FINAL)
-- (Semua dalam Satu File)
-- ================================================

--[[

  BAGIAN 1: "DATABASE" ANDA (WAJIB DIISI!)
  
  Ini adalah "otak" skrip Anda. Kita harus mengajari skrip
  tanaman apa yang termasuk tipe "Leafy" (atau "Fruit", dll.)
  
  Gunakan skrip "Mata-Mata" V2 (Pencari Properti) dari sebelumnya
  untuk menemukan NAMA PERSIS tanaman Anda.

]]
local MasterPlantDatabase = {
    -- Ganti ini dengan tanaman Anda yang sebenarnya
    ["Tomato"] = "Leafy",
    ["NamaTanamanLeafy2"] = "Leafy",
    
    -- Contoh dari log Anda sebelumnya
    ["Tomato"] = "Fruit",
    ["Blueberry"] = "Berry",
    ["Strawberry"] = "Berry"
    
    -- Tambahkan semua tanaman lain yang Anda tahu di sini
}

print("Database tanaman kustom dimuat.")

-- ================================================
-- BAGIAN 2: FUNGSI-FUNGSI PENDUKUNG (DARI INVESTIGASI KITA)
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
            -- Cari gelembung quest
            if string.find(objek.Text, "looking for") then
                
                local teksBersih = HapusTagHTML(objek.Text)
                
                -- Ekstrak tipe dari teks bersih
                local targetTipe = teksBersih:match("looking for (.*) Plants")
                
                if targetTipe then
                    targetDitemukan = targetTipe -- (Contoh: "Leafy")
                    break -- Hentikan loop setelah ditemukan
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

-- Fungsi untuk mendapatkan kebun pemain (dari skrip autofarm)
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
-- BAGIAN 3: LOGIKA UTAMA DAN AKSI
-- ================================================

local function HarvestOtomatisBerdasarkanEvent()
    
    -- 1. Dapatkan tipe target dari gelembung NPC
    local tipeTargetEvent = DapatkanTargetEvent() -- Ini akan berisi "Leafy"
    
    if not tipeTargetEvent then
        print("Tidak bisa panen, target event tidak ditemukan.")
        return -- Hentikan fungsi
    end
    
    -- 2. Dapatkan kebun
    local pemainLokal = game.Players.LocalPlayer
    local kebunPemain = DapatkanKebunPemain(pemainLokal.Name)
    if not kebunPemain then return end -- Hentikan jika kebun tidak ada
    
    local folderTanaman = kebunPemain.Important.Plants_Physical

    print("Memulai filter panen untuk Tipe: " .. tipeTargetEvent)

    -- 3. Loop ke setiap tanaman
    for i, tanaman in pairs(folderTanaman:GetChildren()) do
        
        local namaTanaman = tanaman.Name
        
        -- 4. Cari tipe tanaman ini di "Database" kita (Bagian 1)
        local tipeTanamanIni = MasterPlantDatabase[namaTanaman]
        
        -- 5. FILTER UTAMA: Bandingkan tipe tanaman dengan target event
        if tipeTanamanIni and tipeTanamanIni == tipeTargetEvent then
            
            -- LOLOS FILTER! (Contoh: "Leafy" == "Leafy")
            print("Lolos Filter: " .. namaTanaman .. ". Mencoba memanen...")
            
            -- 6. AKSI PANEN (dari skrip autofarm.lua)
            local prompt = tanaman:FindFirstChild("ProximityPrompt", true)
            if prompt and prompt.Enabled then
                fireproximityprompt(prompt)
                print("Berhasil memanen " .. namaTanaman)
                wait(0.5) -- Beri jeda singkat agar tidak spam
            else
                print("Gagal panen: " .. namaTanaman .. " (Prompt tidak ditemukan/siap)")
            end
            
        else
            -- Gagal filter (Tipenya salah atau tidak ada di database)
        end
    end
    
    print("Siklus filter panen selesai.")
end

-- ================================================
-- BAGIAN 4: MEMULAI SKRIP
-- ================================================

-- Panggil fungsi utama untuk menjalankannya
HarvestOtomatisBerdasarkanEvent()
