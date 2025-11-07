-- ==========================================
-- SKRIP INVESTIGASI V3 (PENCARI PROPERTI QUEST LENGKAP)
-- ==========================================

print("Memulai Investigasi V3 (Pencari Properti Quest Mendalam)...")
print("Mencari TextLabel dengan teks 'Joyce'...")

local ditemukan = false

-- Loop melalui SEMUA objek di dalam game (lebih mendalam)
for i, objek in pairs(workspace:GetDescendants()) do
    
    -- Kita cari TextLabel
    if objek:IsA("TextLabel") then
        
        -- Cek apakah teksnya persis "Joyce"
        if objek.Text == "Joyce" then
            print("=================================")
            print("DITEMUKAN! 'TextLabel' dengan teks 'Joyce'.")
            
            -- Sekarang, kita cari 'Model' induknya (NPC-nya)
            local modelInduk = objek
            -- Terus naik ke atas sampai kita menemukan 'Model'
            while modelInduk.Parent ~= nil and not modelInduk:IsA("Model") do
                modelInduk = modelInduk.Parent
            end
            
            if modelInduk:IsA("Model") then
                print("  --> NAMA MODEL (NPC) ASLI: " .. modelInduk.Name)
                print("Mulai memindai properti quest di dalam '" .. modelInduk.Name .. "'...")
                
                -- SEKARANG KITA PINDAI SEMUA PROPERTI DI DALAM MODEL ITU
                local propertiQuestDitemukan = false
                for _, properti in pairs(modelInduk:GetDescendants()) do
                    
                    -- Kita hanya tertarik pada 'Value' (StringValue, BoolValue, dll.)
                    if properti:IsA("ValueBase") then
                        print("    > Properti Ditemukan: " .. properti.Name)
                        print("      --> NILAINYA: " .. tostring(properti.Value))
                        print("    ---------------------------------")
                        propertiQuestDitemukan = true
                    end
                end
                
                if not propertiQuestDitemukan then
                    print("  --> Tidak ada properti 'Value' yang ditemukan di dalam model ini.")
                end
                
                ditemukan = true
            else
                print("  -- Gagal menemukan Model induk dari TextLabel.")
            end
            
            print("=================================")
            break -- Hentikan loop setelah ditemukan
        end
    end
end

if not ditemukan then
    print("Pencarian selesai. 'TextLabel' bernama 'Joyce' tidak ditemukan.")
    print("PASTIKAN Anda berdiri sangat DEKAT dengan 'Joyce' agar dia termuat di game.")
end
