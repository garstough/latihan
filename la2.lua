-- 1. Tentukan di mana harus mencari (di dalam PlayerGui)
local PlayerGui = game.Players.LocalPlayer.PlayerGui

-- 2. Cari GUI yang bernama "ContohGuiSaya"
local GuiYangInginDihapus = PlayerGui:FindFirstChild("ContohGuiSaya")

-- 3. Jika ditemukan, panggil :Destroy() untuk menghapusnya
if GuiYangInginDihapus then
    GuiYangInginDihapus:Destroy()
end
