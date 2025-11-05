-- 1. Membuat "Kanvas" (ScreenGui)
-- Ini adalah wadah tak terlihat yang menampung semua elemen UI di layarmu.
local MyCanvas = Instance.new("ScreenGui")

-- 2. Membuat "Label Teks" (TextLabel)
-- Ini adalah elemen yang akan menampilkan teks.
local MyText = Instance.new("TextLabel")

-- 3. Mengatur Properti Teks
MyText.Text = "Halo, ini skrip saya!" -- Teks yang ingin ditampilkan
MyText.Size = UDim2.new(0, 400, 0, 50) -- Ukuran kotak (lebar 400px, tinggi 50px)
MyText.Position = UDim2.new(0.5, -200, 0.5, -25) -- Posisi (di tengah layar)
MyText.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Warna latar belakang
MyText.TextColor3 = Color3.fromRGB(255, 255, 255) -- Warna teks
MyText.Font = Enum.Font.SourceSansBold -- Font teks
MyText.TextSize = 24 -- Ukuran font

-- 4. Menampilkan ke Layar
-- Agar terlihat, kita harus menempatkan elemen di tempat yang tepat.
MyText.Parent = MyCanvas -- Masukkan label teks ke dalam kanvas
MyCanvas.Parent = game.Players.LocalPlayer.PlayerGui -- Masukkan kanvas ke GUI pemain