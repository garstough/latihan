
print("Mulai")

-- Fungsi ini diambil dari skrip autofarm (baris 83-93)
local function GetFarm(PlayerName)
    local Farms = workspace.Farm:GetChildren()
    for _, Farm in next, Farms do
        local Owner = Farm.Important.Data.Owner.Value
        if Owner == PlayerName then
            return Farm
        end
    end
end

-- Dapatkan kebun milik Anda
local MyFarm = GetFarm(game.Players.LocalPlayer.Name)

if not MyFarm then
    print("ERROR: Tidak bisa menemukan kebun Anda!")
    return
end

-- Dapatkan folder tempat tanaman fisik disimpan (baris 230)
local PlantsPhysical = MyFarm.Important.Plants_Physical
print("Berhasil menemukan folder tanaman Anda. Membaca nama tanaman...")

-- Loop untuk mencetak nama setiap tanaman
local NamaTanamanYangDitemukan = {}
for i, plant in pairs(PlantsPhysical:GetChildren()) do
    
    -- Cek agar tidak print nama yang sama berulang kali
    if not NamaTanamanYangDitemukan[plant.Name] then
        print("DITEMUKAN: " .. plant.Name)
        NamaTanamanYangDitemukan[plant.Name] = true
    end
end

print("===== SELESAI =====")
print("Silakan cek daftar di atas untuk nama tanaman event Anda.")
