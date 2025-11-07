-- ==========================================
-- SKRIP INVESTIGASI V5 (PENCARI GELEMBUNG QUEST)
-- ==========================================

print("Memulai Investigasi V5...")
print("Mencari gelembung quest (mencari teks 'looking for')...")

local ditemukan = false

-- Loop melalui SEMUA objek di dalam game
for i, objek in pairs(workspace:GetDescendants()) do
    
    -- Kita cari TextLabel
    if objek:IsA("TextLabel") then
        
        -- DI SINI PERUBAHANNYA:
        -- Kita tidak lagi menggunakan '=='. Kita gunakan 'string.find'
        -- untuk mencari apakah teksnya 'mengandung' kata "looking for"
        if string.find(objek.Text, "looking for") then
            
            print("=================================")
            print("DITEMUKAN! Teks quest yang relevan:")
            print("  --> TEKS LENGKAP: '" .. objek.Text .. "'")
            
            -- SEKARANG, KITA EKSTRAK TIPENYA!
            -- Kita ambil teks di antara "looking for " dan " Plants"
            local targetTipe = objek.Text:match("looking for (.*) Plants")
            
            if targetTipe then
                print("  --> TARGET QUEST YANG DIEKSTRAK: '" .. targetTipe .. "'")
            else
                print("  -- Gagal mengekstrak tipe dari teks.")
            end
            
            print("=================================")
            
            ditemukan = true
            break -- Hentikan loop setelah ditemukan
        end
    end
end

if not ditemukan then
    print("Pencarian selesai. Tidak ada gelembung quest yang ditemukan.")
    print("PASTIKAN Anda berdiri DEKAT dengan NPC dan gelembung pikirannya terlihat.")
end
