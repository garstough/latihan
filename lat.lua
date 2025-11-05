-- 1. Buat Kanvas
local MyCanvas = Instance.new("ScreenGui")
MyCanvas.Name = "ContohGuiSaya" -- <<< KITA BERI NAMA DI SINI
MyCanvas.Parent = game.Players.LocalPlayer.PlayerGui

-- 2. Buat Teks
local MyText = Instance.new("TextLabel")
MyText.Text = "Halo, ini skrip saya!"
MyText.Size = UDim2.new(0, 400, 0, 50)
MyText.Position = UDim2.new(0.5, -200, 0.5, -25)
MyText.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MyText.TextColor3 = Color3.fromRGB(255, 255, 255)
MyText.Parent = MyCanvas

-- 4. Menampilkan ke Layar
-- Agar terlihat, kita harus menempatkan elemen di tempat yang tepat.
MyText.Parent = MyCanvas -- Masukkan label teks ke dalam kanvas

MyCanvas.Parent = game.Players.LocalPlayer.PlayerGui -- Masukkan kanvas ke GUI pemain
