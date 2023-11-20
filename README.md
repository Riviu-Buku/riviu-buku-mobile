<a name="readme-top"></a>

<br />
<div align="center">
  <a href="http://samuel-taniel-tutorial.pbp.cs.ui.ac.id">
    <img src="https://github.com/Riviu-Buku/riviu-buku/blob/main/logo.png" alt="Logo Riviu Buku" width="80" height="80">
  </a>

  <h3 align="center">📚Riviu Buku✨</h3>

  <p align="center">
    Riviu Buku: Ulas Buku Untukmu
    <br />
    <a href="https://github.com/Riviu-Buku/riviu-buku"><strong>Explore the code »</strong> </a>
    <br />
    <br />
    <a href="http://samuel-taniel-tutorial.pbp.cs.ui.ac.id">View Site</a>
    ·
    <a href="https://pbp-fasilkom-ui.github.io/ganjil-2024/assignments/group/midterm"> View Assignment </a>
  </p>
</div>

<details>
  <summary>Daftar Pustaka</summary>
  <ol>
    <li>
      <a href="#anggota">🙋‍♀️ Anggota 🙋‍♂️</a>
    </li>
    <li>
      <a href="#cerita">📜 Cerita Aplikasi Yang Diajukan serta Manfaatnya 📜</a>
    </li>
    <li>
      <a href="#daftar-modul">📃 Daftar Modul Yang Akan Diimplementasikan 📃</a>
    </li>
    <li>
      <a href="#dataset">🌐 Sumber Dataset Katalog Buku 🌐</a>
    </li>
    <li>
      <a href="#role">🧑‍🦳 Role atau Peran Pengguna Beserta Deskripsinya 🧑‍🦳</a>
    </li>
  </ol>
</details>

<hr>

<a name="anggota"></a>
## 🙋‍♀️ Anggota 🙋‍♂️
- 🐥 Emmanuel Patrick - 2206081420
- 🐥 Khansa Mahira - 2206819413
- 🐥 Ken Balya - 2206081811
- 🐥 Samuel Taniel Mulyadi - 2206081805
- 🐥 Syazantri Salsabila - 2206029443

<hr>
<a name="cerita"></a>

## 📜 Cerita Aplikasi Yang Diajukan serta Manfaatnya 📜
Seperti namanya, Riviu Buku adalah aplikasi untuk mereview buku. Riviu Buku cocok untuk kamu para pecinta buku maupun kamu yang baru ingin mulai membaca buku loh, yuk simak gambaran tentang Riviu Buku!😉. 

Apa yang membedakan Riviu Buku dengan aplikasi lainnya?🤔Riviu Buku fokus pada interaksi dan kolaborasi antar pembaca. Pengguna dapat membuat ulasan buku serta menulis catatan atau komentar pribadi mengenai suatu buku. Ulasan tersebut dapat membantu pengguna lain dalam memilih buku yang sesuai dengan minat mereka sehingga diharapkan dapat menciptakan komunitas pembaca buku yang lebih aktif🤩. 

Salah satu fitur menarik dari Riviu Buku adalah fitur untuk melihat rekomendasi buku dari pengguna lain sehingga kamu dapat bertemu dengan orang-orang yang minat bacanya serupa denganmu. Selain itu, kamu dapat membuat daftar bacaan pribadi, menandai buku sebagai "ingin dibaca", "sedang dibaca", atau "sudah selesai" sehingga fitur ini dapat membantu melacak perkembangan literasimu👌.

Terima kasih telah membaca cerita Riviu Buku, selamat membaca dan mereview!😇📖⭐️

<hr>
<a name="daftar-modul"></a>

## 📃 Daftar Modul Yang Akan Diimplementasikan 📃

- 📕 Modul untuk me-review buku yang oleh pengguna yang disertai oleh leaderboard berdasarkan review terbaik menggunakan fitur upvote dan downvote; dikerjakan oleh Samuel Taniel Mulyadi;</p> 
- 📕 Modul koleksi, kategori, dan favorit yang memungkinkan pengguna untuk menyimpan daftar buku favorit dan fungsi untuk menambahkan buku ke album/wishlist pengguna serta upload buku untuk bisa di review; dikerjakan oleh Ken Balya</p>
- 📕 Modul homepage yang menyajikan rekomendasi berdasarkan jumlah likes pada suatu kategori buku oleh pengguna; dikerjakan oleh Khansa Mahira</p>
- 📕 Modul wishlist pada profil pengguna yang berisi katalog ulasan yang telah ditulis oleh pengguna, dan kategori buku favorit; dikerjakan oleh Syazantri Salsabila</p>
- 📕 Modul Album Buku dimana pengguna bisa mengumpulkan berbagai buku ke dalam suatu folder contohnya buku a,b, dan c yang mencakup kurikulum IPS, serta dengan implementasinya di dalam kotak pencarian homepage; dikerjakan oleh Emmanuel Patrick.</p>

<p></p>

<hr>
<a name="dataset"></a>

## 🌐 Sumber Dataset Katalog Buku 🌐
Kaggle Dataset: https://www.kaggle.com/datasets/thedevastator/comprehensive-overview-of-52478-goodreads-best-b karena sesuai dengan modul-modul yang ingin kita implementasikan serta tambahan aplikasi Riviu dimana bisa memberikan ulasan dan menciptakan komunitas.

Referensi: Docs Asisten Dosen

<hr>
<a name="role"></a>

## 🧑‍🦳 Role atau Peran Pengguna Beserta Deskripsinya 🧑‍🦳
Pengguna aplikasi hanya ada satu jenis, semua pengguna berkedudukan sama, yaitu dapat mengakses semua buku yang ada, melihat dan membuat review buku dan juga membuat album buku yang bisa dioptimalkan sesuai preferensi pengguna.

<hr>
<a name="Integrasi Web Service"></a>

## 💻 Alur Pengintegrasian dengan Web Service 💻
Berikut adalah langkah-langkah yang akan diambil untuk mengintegrasikan aplikasi dengan server web:

1. Langkah pertama yang kami lakukan adalah membuat sebuah kelas pembungkus (wrapper class) dengan menggunakan pustaka (library) http dan map untuk mendukung penggunaan autentikasi berbasis cookie pada aplikasi.
2. Selanjutnya, kami mengimplementasikan REST API pada Django (views.py) yang telah dibuat sebelumnya dengan menggunakan JsonResponse atau Django JSON Serializer.
3. Setelah itu, kami melanjutkan dengan melakukan integrasi desain front-end aplikasi berdasarkan desain web yang telah ditentukan.
4. Terakhir, kami melakukan integrasi antara front-end dan back-end dengan menggunakan konsep HTTP asynchronous.

<hr>
<a name="berita-acara"></a>

## 🌐 Tautan Berita Acara 🌐
Tautan: https://univindonesia-my.sharepoint.com/:x:/g/personal/khansa_mahira_office_ui_ac_id/EfMk6a4yS5VJvq2IBvBQgSwB8pGJL7S7XC3No9OCEtSIcA?e=bwasXy

<p align="right">(<a href="#readme-top">back to top</a>)</p>

