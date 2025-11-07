-- ==========================================
-- SKRIP INVESTIGASI NPC (PENCARI PROPERTI QUEST)
-- ==========================================

print("Memulai investigasi NPC 'Joyce'...")

-- Temukan NPC "Joyce" di dalam game
local npcTarget = workspace:FindFirstChild("Joyce")

if npcTarget then
    print("Berhasil menemukan 'Joyce'. Membaca properti...")
    
    -- Kita gunakan :GetDescendants() untuk melihat SEMUA di dalamnya
    for i, properti in pairs(npcTarget:GetDescendants()) do
        
        -- Kita hanya tertarik pada 'Value' (StringValue, IntValue, dll)
        -- karena di situlah data quest biasanya disimpan
        if properti:IsA("ValueBase") then
            print("  > Properti Ditemukan: " .. properti:GetFullName())
            print("    --> NILAINYA: " .. tostring(properti.Value))
            print("---------------------------------")
        end
    end
    
    print("===== Investigasi NPC Selesai =====")
    
else
    print("Error: Tidak dapat menemukan 'Joyce' di dalam workspace.")
end
