# Panduan Penjelasan Source Code untuk Dosen (InvenTrack)

Aplikasi InvenTrack adalah prototipe sistem ERP Manufaktur berbasis Flutter. Dokumen ini merangkum **logika kodingan inti** (potongan kode) yang paling sering ditanyakan oleh dosen penguji, berfokus pada navigasi, manajemen *state* sederhana, dan cara menampilkan data.

---

## 1. Konfigurasi Rute Aplikasi (Routing)
**File:** `lib/app.dart`

**Penjelasan Singkat:** 
Aplikasi ini menggunakan *Named Routes* untuk perpindahan antar halaman. Semua jalur (rute) didaftarkan di satu tempat (`MaterialApp`), sehingga navigasi lebih terstruktur.

**Potongan Kode:**
```dart
initialRoute: loginRoute, // Halaman yang pertama kali dibuka
routes: {
  loginRoute: (_) => const LoginScreen(),
  homeRoute: (_) => const HomeShellScreen(),
  poTrackingRoute: (_) => const PoTrackingScreen(),
  goodsReceiptRoute: (_) => const GoodsReceiptScreen(),
  auditLogRoute: (_) => const AuditLogScreen(),
},
```

**Penjelasan Detil Kodenya:**
- `initialRoute: loginRoute`: Perintah dari `MaterialApp` yang menentukan variabel/path mana (`/`) yang pertama kali dieksekusi atau ditampilkan ketika aplikasi dibuka (dalam hal ini `loginRoute`).
- `routes: {...}`: Ini adalah tipe data peubah (Map). Kuncinya (Key) adalah teks URL (contoh: `/home`), dan nilainya (Value) adalah fungsi `(_) => const HomeShellScreen()` yang berarti fungsi pengembali objek layar. Saat pengguna dialihkan ke rute tersebut, Flutter akan merender komponen Screen yang telah didaftarkan ini tanpa harus memuat ulang semuanya lagi secara manual.

---

## 2. Simulasi Login (Keamanan Navigasi Mendasar)
**File:** `lib/screens/login_screen.dart`

**Penjelasan Singkat:** 
Setelah tombol "Sign In" ditekan, aplikasi tidak menggunakan perintah pindah biasa. Ia menggeser dan menghapus rute dari memori.

**Potongan Kode:**
```dart
onPressed: () {
  Navigator.pushReplacementNamed(
    context,
    InvenTrackApp.homeRoute, // Pindah ke HomeShellScreen (Dashboard)
  );
},
```

**Penjelasan Detil Kodenya:**
- `onPressed: () { ... }`: Ini adalah event-listener yang akan dijalankan aplikasinya sewaktu tombol login diklik / di-tap oleh pengguna. 
- `Navigator.pushReplacementNamed`: `Navigator` mengontrol pergerakan layar berbentuk 'tumpukan' (Stack). Fungsi `pushReplacementNamed` bertugas memindahkan kita ke halaman `homeRoute` SEMBARI "menghapus/mematikan" halaman Login saat ini dari tumpukan memori. Artinya apabila user memencet tombol mundur di HP Android, layer aplikasi tidak akan mundur ke menu login lagi (mencegah bug autentikasi flow user).

---

## 3. Mekanisme Navigasi Tab Bawah (State Management)
**File:** `lib/screens/home_shell_screen.dart`

**Penjelasan Singkat:** 
Navigasi bar bagian bawah di aplikasi tidak me-refresh keseluruhan layar. Ia cuma memalsukan transisi menu dengan cara mengubah index angka. 

**Potongan Kode:**
```dart
int _currentIndex = 0; // Menyimpan indeks tab yang sedang aktif

// ... di dalam build() ...
bottomNavigationBar: NavigationBar(
  selectedIndex: _currentIndex,
  onDestinationSelected: (value) {
    // Memperbarui UI ke tab yang dipilih secara instan
    setState(() => _currentIndex = value); 
  },
  destinations: const [
    NavigationDestination(icon: Icon(Icons.dashboard), label: 'Dashboard'),
    NavigationDestination(icon: Icon(Icons.pending_actions), label: 'Requests'),
    // ... tab lainnya ...
  ],
)
```

**Penjelasan Detil Kodenya:**
- `int _currentIndex = 0`: Variabel default ini mengatur posisi layar mana yang terbuka pada awal proses (0 = Index ke-0 / Tab Dashboard).
- `onDestinationSelected: (value)`: Method bawaan yang membaca ketukan user ke arah menu navigasi bawah. `value` adalah nilai index dari layar ke posisi yang ditekan user.
- `setState(() => _currentIndex = value)`: Sintaks ini sangat mematikan di dalam sebuah objek `StatefulWidget`. Perintah `setState` digunakan guna menginterupsi mesin Flutter untuk segera *menggambar ulang antarmuka (re-render)* dengan memaksakan nilai lama `_currentIndex` tergantikan dengan input index tujuan (value). UI langsung reaktif.

---

## 4. Menampilkan Log Data Efisien (Lazy-Loading)
**File:** `lib/screens/audit_log_screen.dart`

**Penjelasan Singkat:** 
Simulasi daftar antrean besar di dalam array disimpan secara optimal dan ditampilkan menggunakan metode yang tak menyita banyak beban pengoperasian ponsel.

**Potongan Kode:**
```dart
// Data Simulasi (Mock Data) menggunakan Tuple / Record Dart modern
final logs = [
  ('14:22', 'Marcus Thorne', 'Updated stock level...'),
  ('11:05', 'Security System', 'New API key generated...'),
];

// Menampilkan Data ke Layar
ListView.builder(
  itemCount: logs.length,
  itemBuilder: (_, index) {
    final item = logs[index]; // Ambil data per index baris
    return Row(
      children: [
        Text(item.$2), // Memanggil value tuple ke-2: Nama Pelaku
        Text(item.$1), // Memanggil value tuple ke-1: Waktu Aksi
        Text(item.$3), // Memanggil value tuple ke-3: Detail Aksi
      ],
    );
  },
)
```

**Penjelasan Detil Kodenya:**
- `final logs = [ ('A', 'B', 'C') ]`: Sintaks kurung biasa `()` tanpa penamaan ini dinamakan pola `Record/Tuple` terbaru dari bahasa Dart 3.0. Ia sangat fleksibel menampung data jamak multi-tipe untuk dikemas instan ke dalam 1 varibel list dengan format yang konsisten.
- `ListView.builder(...)`: Merupakan elemen penampil data jamak (*Dynamic Scroller*). Berbeda dengan *ListView standar* (yang menampilkan konten dengan menumpuk memori di satu waktu), `.builder` menerapkan efisiensi metode ***Lazy Loading***—ia cuma akan merender barisan item persis sebatas yang dapat dilihat layar mata user saja.
- `itemCount: logs.length`: Mambatas ruang cetak *builder* sejumlah banyak total objek yang ada di dalam list `logs` saja. 
- `item.$1, item.$2, item.$3`: Simbol dollar `$` menandakan penarikan properti bawaan dari Tuple (*Anonymous Field Extraction*). Aplikasi mengambil langsung value Data Index Tuple ke-2 (Pelaku) dan ke-1 (Waktu Aksi) secara efisien dengan ukuran bytes tipis untuk dicetak ke widget Teks (`Text(...)`).
