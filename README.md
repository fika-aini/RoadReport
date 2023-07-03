# RoadReport
RoadReport adalah aplikasi untuk mengelola dan merekomendasikan rute tracking di alam. Aplikasi ini memungkinkan pengguna untuk menelusuri rute tracking berdasarkan wilayah dan level kesulitan. Setiap rute memiliki galeri foto yang memperlihatkan keindahan alam sepanjang perjalanan.

Skema Database
Aplikasi ini menggunakan PostgreSQL sebagai sistem manajemen basis data. Skema database yang digunakan terdiri dari tabel-tabel berikut:

Tabel "users": Berisi informasi pengguna yang memiliki akses ke dashboard.
Tabel "routes": Berisi informasi rute tracking seperti nama rute, panjang, ketinggian awal, ketinggian akhir, wilayah, dan level kesulitan.
Tabel "photos": Berisi informasi foto-foto terkait rute tracking.
Tabel "regions": Berisi informasi wilayah.
Tabel "levels": Berisi informasi level kesulitan.
