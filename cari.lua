-- ==========================================
-- SKRIP INVESTIGASI V6 (PEMBERSIH RICH TEXT)
-- ==========================================

print("Memulai Investigasi V6...")
print("Mencari gelembung quest (mencari 'looking for')...")

-- FUNGSI BARU: Untuk menghapus tag HTML (Rich Text)
-- Pola ini menemukan semua tag seperti <...> dan menggantinya dengan "" (kosong)
function HapusTagHTML(teks)
    local teksBersih = string.gsub(teks, "<[^>]*>", "")
    return teksBersih
end

local ditemukan = false

-- Loop melalui SEMUA objek di dalam game
for i, objek in pairs(workspace:GetDescendants()) do
    
    if objek:IsA("TextLabel") then
        
        -- Kita masih mencari 'looking for' di teks asli (yang mungkin ada tag)
        if string.find(objek.Text, "looking for") then
            
            print("=================================")
            print("DITEMUKAN! Teks quest (dengan tag): '" .. objek.Text .. "'")
            
            -- LANGKAH BARU: Bersihkan teksnya menggunakan fungsi baru kita
            local teksBersih = HapusTagHTML(objek.Text)
            print("  --> TEKS SETELAH DIBERSIHKAN: '" .. teksBersih .. "'")
            
            -- SEKARANG, kita ekstrak dari teks bersih
            local targetTipe = teksBersih:match("looking for (.*) Plants")
            
            if targetTipe then
                print("  --> TARGET QUEST YANG DIEKSTRAK: '" .. targetTipe .. "'")
            else
                print("  -- Gagal mengekstrak tipe dari teks bersih.")
            end
            
            print("=================================")
            
            ditemukan = true
            break -- Hentikan loop setelah ditemukan
        end
    end
end

if not ditemukan then
    print("Pencarian selesai. Tidak ada gelembung quest yang ditemukan.")
end
