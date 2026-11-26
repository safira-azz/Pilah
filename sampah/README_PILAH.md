# Pilah – Kamus Klasifikasi Sampah (Flutter)

Versi Flutter dari `Pilah___Kamus_Klasifikasi_Sampah.html`, disusun mengikuti
struktur project `template_ori` (folder `lib/` dan `test/`).

## Cara pasang

1. Salin folder `lib/` dan `test/` dari zip ini ke project `template_ori`
   (timpa `lib/main.dart` dan `test/widget_test.dart` bawaan).
2. Tambahkan dua dependency di folder project:
   ```
   flutter pub add shared_preferences google_fonts
   ```
3. Jalankan:
   ```
   flutter run            # pilih device / chrome / windows
   flutter test           # opsional
   ```

Nama package harus `template_ori` (sesuai `pubspec.yaml` kamu), karena import
memakai `package:template_ori/...`.

## Struktur

```
lib/
├── main.dart                     titik masuk, muat data lalu runApp
├── app.dart                      MaterialApp + tema terang/gelap
├── controllers/
│   └── waste_controller.dart     semua state & logika (cari, filter, CRUD, konfirmasi hapus)
├── data/
│   ├── models/                   WasteCategory, WasteItem
│   └── repositories/             penyimpanan lokal + data awal
├── core/
│   ├── theme/                    warna, font, tema
│   └── widgets/                  komponen umum (panel, tombol pil, toast, dsb.)
└── features/                     SATU FOLDER = SATU FITUR
    ├── header/
    ├── category_counter/
    ├── search/
    ├── waste_form/
    ├── waste_list/
    └── home/                     hanya menyusun tata letak
```

## Penjelasan tiap fitur

| Fitur | File | Penjelasan |
|---|---|---|
| Header | `features/header/header_section.dart` | Judul "Pilah", garis emas, dan kalimat pengantar. Ukuran judul menyesuaikan lebar layar. |
| Penghitung & filter kategori | `features/category_counter/category_counter.dart` | Empat tong (Organik, Anorganik, B3, Residu) menampilkan jumlah data. Menekan tong memfilter daftar, menekan lagi mematikan filter. 4 sebaris di layar lebar, 2x2 di layar sempit. |
| Pencarian | `features/search/search_section.dart` | Menyaring daftar langsung saat mengetik (nama, tempat buang, catatan). Tombol "Semua" muncul saat filter aktif dan mereset filter + kolom cari. |
| Form tambah / ubah | `features/waste_form/waste_form.dart` | Satu form untuk Create dan Update. Mode ubah aktif dari tombol "Ubah" di kartu: form terisi data lama, judul dan tombol berubah, ada tombol "Batal". Nama dan tempat wajib diisi. |
| Daftar sampah | `features/waste_list/waste_list.dart` | Menampilkan data hasil filter + pencarian, keterangan "X dari Y sampah ditampilkan", dan tampilan kosong (dua pesan berbeda). |
| Kartu sampah & hapus | `features/waste_list/waste_card.dart` | Nama, lencana kategori berwarna, tempat buang, catatan. Hapus memakai konfirmasi dua langkah ("Yakin hapus?"), otomatis batal setelah 3 detik. |
| Penyimpanan lokal | `data/repositories/waste_repository.dart` | Menyimpan data ke `shared_preferences` (pengganti `localStorage`). Pertama kali dibuka memakai 4 data awal. Format JSON sama dengan versi HTML. |
| Toast | `core/widgets/toast.dart` | Notifikasi kecil 2 detik: "Sampah ditambahkan", "Perubahan disimpan", "Sampah dihapus". |
| Tema terang/gelap | `core/theme/` | Warna dan font (Newsreader + Hanken Grotesk) sama dengan HTML; otomatis mengikuti pengaturan sistem. |
| Tata letak responsif | `features/home/home_page.dart` | Di atas 820px: form kiri, daftar kanan. Di bawahnya: satu kolom. |

## Catatan

- Perbedaan kecil dari HTML: form di layar lebar tidak "menempel" (sticky) saat
  daftar di-scroll.
- Font diambil dari Google Fonts lewat internet; jika offline, Flutter memakai
  font bawaan. Agar font tertanam permanen, unduh file font lalu daftarkan di
  `pubspec.yaml`.
