-- ==========================================
-- SKRIP INVESTIGASI GUI (PENCARI TEKS EVENT)
-- ==========================================

print("Memulai pencarian teks di semua GUI...")

-- Dapatkan folder GUI pemain
local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

-- :GetDescendants() akan mendapatkan SEMUA objek di dalam PlayerGui
for i, objek in pairs(PlayerGui:GetDescendants()) do

    -- Kita hanya peduli pada objek yang bisa menampilkan teks
    if objek:IsA("TextLabel") or objek:IsA("TextButton") then

        -- Periksa apakah teksnya relevan (tidak kosong)
        local teks = objek.Text
        if teks ~= "" and teks ~= "Label" and teks ~= "Button" then

            -- Kita cari teks yang MUNGKIN nama tipe (Fruit, Berry, Flower)
            -- atau bagian dari quest
            if teks == "Fruit" or teks == "Berry" or teks == "Flower" or string.find(teks, "Harvest") then

                print("=================================")
                print("TEKS RELEVAN DITEMUKAN: '" .. teks .. "'")
                print("  --> LOKASI: " .. objek:GetFullName())
                print("=================================")
            end
        end
    end
end

print("===== Pencarian Teks GUI Selesai =====")
