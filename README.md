# Pipeline ETL Berbasis Prinsip FAIR untuk Integrasi Data Biodiversitas GBIF (Studi Kasus: Aves Indonesia)

[![Python](https://img.shields.io/badge/Python-3.11%2B-blue.svg)](https://www.python.org/)
[![DuckDB](https://img.shields.io/badge/Storage-DuckDB%20%26%20Parquet-yellow.svg)](https://duckdb.org/)
[![Standard](https://img.shields.io/badge/Standard-Darwin%20Core-green.svg)](https://dwc.tdwg.org/)
[![FAIR Score](https://img.shields.io/badge/FAIR%20Score-83.33%25-brightgreen.svg)](#evaluasi-kepatuhan-fair)

Repositori ini berisi implementasi pipeline *Extract, Transform, Load* (ETL) terotomatisasi yang dirancang berdasarkan prinsip **FAIR** (*Findable, Accessible, Interoperable, Reusable*) untuk mengintegrasikan, membersihkan, dan menstandardisasi data kemunculan (*occurrence*) kelas **Aves** di wilayah Indonesia dari **Global Biodiversity Information Facility (GBIF)**.

Penelitian ini merupakan bagian dari Tugas Akhir / Skripsi Program Studi S1 Sains Data, Departemen Statistika, Fakultas Matematika dan Ilmu Pengetahuan Alam (FMIPA), Universitas Brawijaya.

---

## Ringkasan Arsitektur Pipeline

Pipeline memproses data mentah GBIF berukuran besar menggunakan pendekatan pemrosesan berbasis *chunk* (*batch processing*) untuk efisiensi memori, dengan alur kerja enam tahap utama:

1. **Profiling & Baseline Quality Assessment:** Audit struktur skema awal dan pengukuran kualitas data mentah menggunakan lima metrik kualitas (*Lineage*, *Uniqueness*, *Validity Spatial*, *Validity Metadata & Temporal*, serta *Data Density*).
2. **Ingesti & Harmonisasi Darwin Core (DwC):** Pemetaan dan penyeragaman 50 atribut inti Darwin Core serta standarisasi format nilai dasar.
3. **Resolusi Taksonomi (Catalogue of Life):** Pencocokan dan normalisasi nama ilmiah melalui API *Catalogue of Life* (CoL) berbasis mekanisme *caching* untuk menghasilkan `matchedTaxonKey` yang terverifikasi.
4. **Validasi Geospasial & Kesesuaian Habitat:** Validasi koordinat terhadap batas poligon administratif dan perairan teritorial Indonesia (ZEE), pengecekan jarak terhadap garis pantai (*coastal buffer*), serta identifikasi anomali habitat (*terrestrial vs. marine*).
5. **Pemisahan Data (*Quarantine Routing*):** Pemisahan rekaman berbasis aturan kualitas menjadi dataset bersih siap pakai (**Clean Dataset**) dan rekaman bermasalah (**Quarantine Dataset**) beserta kode alasan penolakan (`quarantineReason`).
6. **Pemuatan & Katalogisasi Metadata:** Penyimpanan dataset ke dalam database analitik **DuckDB**, ekspor file **Apache Parquet** dan **CSV terkompresi (`.csv.gz`)**, serta penerbitan katalog metadata terstruktur berformat **JSON-LD** (Schema.org).

---

## Ringkasan Hasil & Metrik Kualitas

### 1. Statistik Pemrosesan Data
Dari total **1.551.741 rekaman** data mentah GBIF Aves Indonesia yang diproses:

| Entitas Keluaran | Jumlah Rekaman | Jumlah Kolom | Ukuran Parquet | Ukuran CSV (`.gz`) | Keterangan |
| :--- | :---: | :---: | :---: | :---: | :--- |
| **Clean DB (DuckDB)** | 1.491.370 | 52 kolom | 87,76 MB | 61,54 MB | Tabel analitik lengkap dengan 11 kolom turunan hasil validasi & taksonomi |
| **Clean Set (Ekspor Utama)** | 1.491.370 | 41 kolom | 85,80 MB | 61,10 MB | Dataset bersih terstandarisasi Darwin Core untuk pengguna akhir |
| **Quarantine Set** | 60.371 | 52 kolom | 2,40 MB | 1,68 MB | Rekaman tidak lolos validasi disertai label alasan karantina |

### 2. Peningkatan Kualitas Data (Sebelum vs. Sesudah ETL)

| Dimensi Kualitas | Sebelum ETL (*Raw*) | Sesudah ETL (*Clean*) | Perubahan |
| :--- | :---: | :---: | :---: |
| **Completeness (*Lineage*)** | 99,66% | 100,00% | +0,34% |
| **Uniqueness** | 97,70% | 100,00% | +2,30% |
| **Validity (Spatial)** | 87,78% | 100,00% | +12,22% |
| **Validity (Metadata & Temporal)** | 94,44% | 100,00% | +5,56% |
| **Data Density** | 88,83% | 91,48% | +2,65% |

### 3. Evaluasi Kepatuhan FAIR
Evaluasi kuantitatif dilakukan menggunakan 12 indikator terukur pada empat dimensi prinsip FAIR:

* **Findable ($FAIR_F$):** `83,33%` (DOI terverifikasi, metadata JSON-LD terindeks, pengenal unik persisten).
* **Accessible ($FAIR_A$):** `100,00%` (Akses terbuka melalui repositori publik, protokol standar HTTP/HTTPS, metadata tetap dapat diakses).
* **Interoperable ($FAIR_I$):** `83,33%` (Kosakata standar Darwin Core, format terbuka Parquet/CSV/JSON-LD, resolusi taksonomi Catalogue of Life).
* **Reusable ($FAIR_R$):** `66,67%` (Lisensi terbuka CC-BY 4.0, dokumentasi *provenance* & log eksekusi pipeline).
* **Overall FAIR Score:** **`83,33%`** (Kategori: *Sangat Baik / Tinggi*).

---

## Struktur Repositori

```text
├── notebooks/                  # Jupyter Notebooks untuk setiap tahapan ETL & evaluasi
│   ├── 01_data_profiling.ipynb
│   ├── 02_dwc_harmonization.ipynb
│   ├── 03_taxonomy_resolution.ipynb
│   ├── 04_spatial_habitat_validation.ipynb
│   ├── 05_quarantine_and_loading.ipynb
│   └── 06_fair_evaluation.ipynb
├── data/
│   ├── clean/                  # Dataset bersih (Parquet & CSV terkompresi)
│   ├── quarantine/             # Dataset karantina beserta alasan penolakan
│   └── metadata/               # File katalog metadata JSON-LD & laporan profiling
├── database/                   # Skema & file database analitik DuckDB
├── scripts/                    # Modul utilitas Python (API caching, poligon spasial, logger)
├── requirements.txt            # Daftar dependensi pustaka Python
└── README.md
