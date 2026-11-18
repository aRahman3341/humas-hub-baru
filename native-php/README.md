# Humas Content Hub — PHP Native + MySQL

Versi aplikasi PHP native terpisah dari proyek Laravel yang lama, ditujukan untuk hosting cPanel/Hostinger. Twitter tidak disediakan. Alur memakai tiga peran: Super Admin, Admin, dan Editor.

## Pasang di Hostinger

1. Buat database MySQL dan user database melalui hPanel.
2. Import `schema.sql` dari phpMyAdmin. SQL ini membuat tabel kosong sekaligus pilihan awal jenis konten, rasio, dan platform.
3. Salin `config.example.php` menjadi `config.php`, lalu isi host/nama/user/password MySQL. Isi `encryption_key` dengan nilai dari perintah `php -r "echo base64_encode(random_bytes(32)), PHP_EOL;"`. Jangan bagikan atau mengganti kunci ini setelah akun dibuat.
4. Unggah isi folder `native-php` ke folder aplikasi pada hosting. Pastikan PHP 8.1+ dengan PDO MySQL, OpenSSL, dan Fileinfo aktif. Set folder `uploads` dapat ditulis PHP; file dilayani melalui endpoint terlindungi, bukan tautan publik.
5. Jalankan `install.php` sekali melalui browser untuk membuat tiga akun awal, lalu **hapus install.php**.
6. Login dan segera ganti password setiap akun. Pastikan file `config.php` tidak bisa diunduh dan pakai HTTPS.

## Akun awal

- Super Admin: `superadmin` / `Super123!`
- Admin: `admin` / `Admin123!`
- Editor: `editor` / `Editor123!`

Password **tidak disimpan sebagai teks biasa maupun hash**: password disimpan terenkripsi AES-256-GCM menggunakan kunci privat dari `config.php`, sehingga Super Admin dapat melihat password akun Admin/Editor di halaman Pengaturan. Ini tetap berisiko lebih tinggi dibanding hash satu arah: siapa pun yang memperoleh database **dan** kunci konfigurasi dapat membuka password. Jangan gunakan password yang dipakai di layanan lain, batasi akses ke config/backup, dan ganti akun contoh sesegera mungkin.

## Fitur alur

- Admin mengajukan judul, brief, editor, deadline, jadwal publish, platform (TikTok/Instagram), beberapa jenis konten/rasio sesuai izin, dan bahan referensi.
- Super Admin mengelola opsi konten/rasio/platform, serta izin multi-pilihan admin dan akses caption editor.
- Editor mengirim file draft/final, komentar, dan caption jika diizinkan. Admin dan editor membalas dalam satu thread revisi dengan lampiran.
- Semua Admin dapat melihat dan memberi pendapat. Hanya Admin pengaju atau Super Admin yang dapat ACC. ACC menutup thread; Super Admin dapat membuka kembali.
- Admin pengaju atau Super Admin dapat mempublikasikan sesudah ACC.
- Notifikasi baru diperiksa berkala lewat polling 5 detik (mendekati realtime, bukan WebSocket). Deadline ditandai ketika tersisa tiga hari atau kurang saat dashboard dibuka.
- Batas upload default 100 MiB per file; sesuaikan dengan batas PHP/Hostinger (`upload_max_filesize`, `post_max_size`) dan kapasitas disk 10 GB. Untuk video, mulai dari 100 MiB/file agar beberapa file tidak cepat memenuhi disk; pantau pemakaian dan arsipkan file lama.

## Catatan implementasi

Paket ini berada di `native-php/` agar file Laravel lama tetap utuh. Unduh ZIP branch dari GitHub (Code → Download ZIP), kemudian unggah folder aplikasi ke Hostinger. Uji instalasi dan hak akses di staging sebelum digunakan untuk pekerjaan nyata. Untuk upload yang besar, batas hosting PHP dapat lebih kecil daripada batas aplikasi; ubah keduanya secara konsisten.
