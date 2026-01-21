# Trivanox
Dashboard Web : https://github.com/ahmadzipur/Trivanox-HR-Admin.git

Link Dashboard : https://ryzola.com/trivanox/

File APK : https://github.com/ahmadzipur/Trivanox/tree/main/build/app/outputs/flutter-apk

TRIVANOX – Online Attendance

TRIVANOX adalah aplikasi absensi online berbasis mobile yang dikembangkan menggunakan Flutter untuk mendukung pencatatan kehadiran karyawan secara digital, real-time, akurat, dan terintegrasi dengan backend.

Aplikasi ini dikembangkan sebagai bagian dari Tugas Ujian Akhir Semester Mata Kuliah Pemrograman Mobile 2
Program Studi Teknik Informatika – Universitas Teknologi Bandung (2025).

Informasi Pengembang
- Nama: Ahmad Zaelani
- NIM: 23552011179
- Program Studi: Teknik Informatika
- Universitas: Universitas Teknologi Bandung
- Dosen Pengampu: Andri Nugraha Ramdhon, S.Kom., M.Kom.

Latar Belakang

Proses absensi manual memiliki berbagai keterbatasan seperti rawan kesalahan pencatatan, keterlambatan rekap data, dan kurangnya transparansi.
TRIVANOX hadir sebagai solusi absensi digital berbasis mobile yang memungkinkan pencatatan kehadiran karyawan secara otomatis dan real-time melalui aplikasi Flutter yang terintegrasi dengan backend API dan database.

Tujuan Pengembangan

Aplikasi TRIVANOX bertujuan untuk:
- Menyediakan fitur absensi real-time (clock-in, break, clock-out)
- Menyimpan data absensi ke database terpusat
- Menampilkan riwayat absensi secara terstruktur
- Menyertakan bukti foto dan lokasi GPS
- Memudahkan monitoring dan validasi kehadiran karyawan
- Menambahkan halaman riwayat absensi dengan animasi agar tampilan lebih interaktif.
- Mengimplementasikan fitur pengajuan izin dan cuti secara digital.
- Menyediakan halaman detail izin dan cuti untuk menampilkan informasi pengajuan secara lengkap.
- Mengembangkan halaman profil pengguna yang dapat diedit.
- Menerapkan sistem dropdown beruntun untuk data wilayah (Provinsi → Kabupaten/Kota → Kecamatan → Desa).


Arsitektur Sistem

Aplikasi menggunakan arsitektur Client–Server:
- Client: Aplikasi Mobile (Flutter)
- Server: REST API (PHP)
- Database: MySQL
- Data absensi dikirim dari aplikasi ke server melalui API dan disimpan dalam database, kemudian ditampilkan kembali ke aplikasi secara real-time.

Fitur Utama

1. Autentikasi
- Login menggunakan email dan password
- Manajemen sesi pengguna

2. Absensi Harian
- Clock In (Absen Masuk) – dengan foto & lokasi GPS
- Break Out (Mulai Istirahat)
- Break In (Selesai Istirahat)
- Clock Out (Absen Pulang) – dengan foto & lokasi GPS

3. Riwayat & Detail Absensi
- Daftar riwayat absensi
- Detail absensi per tanggal:
- Jam masuk
- Jam istirahat
- Jam pulang
- Foto masuk & pulang
- Lokasi GPS (terintegrasi Google Maps)

4. Notifikasi
- Notifikasi berhasil absen
- Validasi status absensi

5. Pengajuan Izin, Cuti dan Sakit
- Tambah pengajuan
- Lampirkan File Pendukung
- Status pengajuan

6. Profil pengguna
- Data Profil pengguna
- Edit Data Profil Pengguna

Metode Pengelolaan Data (CRU)

Aplikasi menerapkan metode CRU (Create, Read, Update):
- Create: Clock-in (1x per hari, tervalidasi)
- Read: Riwayat & detail absensi
- Update: Break-out, break-in, dan clock-out
- Metode Delete belum diterapkan untuk menjaga integritas data absensi.

Teknologi yang Digunakan
- Flutter – Cross-platform mobile framework
- GetX – State management, navigasi, dependency injection
- REST API – Backend komunikasi data
- MySQL – Database penyimpanan absensi
- Google Maps – Visualisasi lokasi GPS
- Camera & Image Picker – Bukti foto absensi

Manajemen State & Navigasi

Aplikasi menggunakan GetX untuk:
- State management reaktif (RxBool, RxList)
- Navigasi tanpa BuildContext
- Dependency injection yang ringan dan efisien

Antarmuka (UI)

Halaman utama aplikasi:
- Login
- Home (status absensi & tombol aksi)
- Clock In
- Break Out
- Break In
- Clock Out
- Detail Absensi
- UI dirancang responsif dan menyesuaikan status absensi pengguna.

Pengujian

Pengujian dilakukan dengan:
- Debug log (debugPrint)
- Validasi data null (foto & lokasi)
- Uji tampilan pada berbagai ukuran layar
- Navigasi antar halaman berjalan dengan baik
- Data riwayat dan detail absensi ditampilkan dengan benar
- Pengajuan izin dan cuti dapat dilakukan tanpa error
- Dropdown wilayah dan pengajuan berfungsi sesuai alur
- Aplikasi berjalan stabil dan responsif 
- Animasi berjalan dengan baik
- Hasil pengujian menunjukkan aplikasi berjalan stabil dan data absensi tampil dengan baik.

Rencana Pengembangan Selanjutnya
- Sistem persetujuan izin dan cuti oleh admin
- Notifikasi real-time untuk status absensi dan izin
- Keamanan data yang lebih kuat
- Optimalisasi performa dan tampilan UI


📹 Demo Video
- ▶️ https://youtu.be/kTR1zLzLHhU?si=YMeo7qbLwOrYmHcP

📦 Repository
- 🔗 https://github.com/ahmadzipur/Trivanox.git

📄 Lisensi
- Proyek ini dikembangkan untuk keperluan akademik dan pembelajaran.