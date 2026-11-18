# Pipeline ETL Berbasis FAIR untuk Integrasi Data Biodiversitas dari GBIF: Studi Kasus Aves Indonesia

- **Judul**: *Rancang Bangun Pipeline ETL Berbasis FAIR untuk Integrasi Data Biodiversitas dari GBIF: Studi Kasus Aves Indonesia*
- **Peneliti**: Raditya Sajid (Program Studi S1 Sains Data, Departemen Statistika, FMIPA Universitas Brawijaya)
- **Sumber Data**: Global Biodiversity Information Facility (GBIF) — Kelas *Aves* di Indonesia (`https://doi.org/10.15468/dl.w5dmpc`)
- **Otoritas Taksonomi**: *Catalogue of Life eXtended Release* (`checklistKey = 7ddf754f-d193-4cc9-b351-99906754a03b`)
- **Total Data Diproses**: `1.551.741` *record* (`1.501.875` *Clean Set* | `49.866` *Quarantine Store*)

## Struktur Keluaran Utama (`output/`)
- `final_parquet/occurrence_clean.parquet`: Dataset bersih berformat *Apache Parquet* (41 kolom aktif).
- `final_parquet/occurrence_quarantine.parquet`: Dataset karantina berformat *Apache Parquet* (55 kolom aktif).
- `db/clean_store_aves_indonesia.duckdb`: Basis data analitik *DuckDB* untuk *Clean Set*.
- `db/quarantine_store_aves_indonesia.duckdb`: Basis data analitik *DuckDB* untuk *Quarantine Store*.
- `07_dataset_metadata_fair.json`: Dokumen metadata deskriptif, lisensi, dan provenansi berstandar FAIR.
- `07_tabel_2_10_evaluasi_indikator_fair.csv`: Hasil penilaian otomatis 12 indikator *RDA FAIR Data Maturity Model*.
