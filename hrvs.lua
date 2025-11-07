print("Memulai pencarian properti tanaman...")

-- Fungsi untuk mendapatkan folder kebun pemain
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
    return nil
end

local pemainLokal = game.Players.LocalPlayer
local kebunPemain = DapatkanKebunPemain(pemainLokal.Name)

if not kebunPemain then
    print("Error: Folder kebun pemain tidak ditemukan.")
    return -- Hentikan skrip jika kebun tidak ditemukan
end

local folderTanaman = kebunPemain.Important.Plants_Physical
print("Berhasil menemukan folder tanaman. Memeriksa properti...")

local propertiTercetak = {} -- Untuk melacak apa yang sudah kita cetak

-- Loop ke setiap tanaman di folder
for i, tanaman in pairs(folderTanaman:GetChildren()) do
    
    -- Cek agar tidak mencetak properti yang sama berulang kali
    if not propertiTercetak[tanaman.Name] then
        print("================================")
        print("Menganalisis Tanaman: " .. tanaman.Name)
        
        -- Loop ke SEMUA bagian di dalam tanaman itu
        for _, properti in pairs(tanaman:GetChildren()) do
            
            -- Cetak nama properti dan kelasnya (jenis objeknya)
            print("  > Properti Ditemukan: " .. properti.Name .. " (Tipe: " .. properti.ClassName .. ")")
            
            -- Jika itu adalah objek "Value" (StringValue, IntValue, dll.)
            -- kita juga cetak nilainya
            if properti:IsA("ValueBase") then
                print("    --> Nilainya: " .. tostring(properti.Value))
            end
        end
        
        propertiTercetak[tanaman.Name] = true -- Tandai sudah dicetak
    end
end

print("===== Pencarian Properti Selesai =====")
