-- ==========================================
-- SKRIP INVESTIGASI V4 (PENCARI NAMA TEPAT)
-- ==========================================

print("Memulai Investigasi V4...")
print("Mencari TextLabel dengan teks 'Safari Joyce'...")

local ditemukan = false
local targetTeks = "Safari Joyce" -- NAMA YANG BENAR

-- Loop melalui SEMUA objek di dalam game
for i, objek in pairs(workspace:GetDescendants()) do
    
    -- Kita cari TextLabel
    if objek:IsA("TextLabel") then
        
        -- DI SINI PERUBAHANNYA: Kita cari nama yang tepat
        if objek.Text == targetTeks then
            print("=================================")
            print("DITEMUKAN! 'TextLabel' dengan teks '" .. targetTeks .. "'.")
            
            -- Sekarang, kita cari 'Model' induknya (NPC-nya)
            local modelInduk = objek
            while modelInduk.Parent ~= nil and not modelInduk:IsA("Model") do
                modelInduk = modelInduk.Parent
            end
            
            if modelInduk:IsA("Model") then
                print("  --> NAMA MODEL (NPC) ASLI: " .. modelInduk.Name)
                print("Mulai memindai properti quest di dalam '" .. modelInduk.Name .. "'...")
                
                -- PINDAI SEMUA PROPERTI DI DALAM MODEL ITU
                local propertiQuestDitemukan = false
                for _, properti in pairs(modelInduk:GetDescendants()) do
                    
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
    print("Pencarian selesai. 'TextLabel' bernama '" .. targetTeks .. "' tidak ditemukan.")
    print("PASTIKAN Anda berdiri sangat DEKAT dengan NPC.")
end
