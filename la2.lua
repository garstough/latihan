-- 1. Tentukan di mana harus mencari
local PlayerGui = game.Players.LocalPlayer.PlayerGui

-- 2. Cari GUI dengan nama default "ScreenGui"
local GuiTanpaNama = PlayerGui:FindFirstChild("ScreenGui")

-- 3. Hancurkan jika ditemukan
if GuiTanpaNama then
    GuiTanpaNama:Destroy()
    print("GUI dengan nama 'ScreenGui' berhasil dihapus.")
end
