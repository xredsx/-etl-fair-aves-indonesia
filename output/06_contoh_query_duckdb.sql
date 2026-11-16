-- =============================================================================
-- CONTOH QUERY SQL DUCKDB & PARQUET: DATASET AVES INDONESIA (CLEAN & QUARANTINE)
-- Jalankan di DuckDB CLI / Python setelah memasang kedua database (baca-saja):
-- =============================================================================
ATTACH 'C:/Users/radit/Skripsi/ETL/output/db/clean_store_aves_indonesia.duckdb' AS clean_db (READ_ONLY);
ATTACH 'C:/Users/radit/Skripsi/ETL/output/db/quarantine_store_aves_indonesia.duckdb' AS quarantine_db (READ_ONLY);

-- Contoh Query 1 (Clean DB): 10 spesies Aves dengan jumlah observasi terbanyak beserta taxonKey COL XR
SELECT scientificName AS nama_ilmiah_accepted,
       taxonKey AS taxon_key_col,
       family AS famili,
       COUNT(*) AS total_observasi,
       COUNT(DISTINCT stateProvince) AS jumlah_provinsi_sebaran
FROM clean_db.main.occurrence_clean
GROUP BY scientificName, taxonKey, family
ORDER BY total_observasi DESC
LIMIT 10;

-- Contoh Query 2 (Clean DB): 10 observasi berstatus 'Clean' dengan tanggal pengamatan terbaru
SELECT gbifID,
       scientificName,
       taxonKey,
       family,
       stateProvince,
       ROUND(decimalLatitude, 4) AS lat,
       ROUND(decimalLongitude, 4) AS lon,
       eventDate,
       publisher
FROM clean_db.main.occurrence_clean
WHERE record_routing_status = 'Clean'
  AND eventDate IS NOT NULL
ORDER BY eventDate DESC
LIMIT 10;

-- Contoh Query 3 (Quarantine DB): Distribusi penyebab record masuk Quarantine per dimensi kualitas
SELECT dimensi_invalid,
       jumlah_record
FROM quarantine_db.main.quarantine_reason_by_dimension
ORDER BY jumlah_record DESC;

-- Contoh Query 4 (Clean DB): Ringkasan perbandingan kualitas data Sebelum vs Sesudah ETL (Delta X)
SELECT Kode,
       Dimensi_Kualitas,
       "Baseline_Sebelum_ETL (%)",
       "Sesudah_ETL_Clean_Set (%)",
       "Kenaikan_Delta_X (%)"
FROM clean_db.main.etl_before_after_summary;

-- Contoh Query 5 (Direct Parquet Query): Agregasi langsung dari file occurrence_clean.parquet per Basis of Record
SELECT basisOfRecord,
       COUNT(*) AS jumlah_record,
       COUNT(DISTINCT scientificName) AS jumlah_spesies_unik
FROM read_parquet('C:/Users/radit/Skripsi/ETL/output/final_parquet/occurrence_clean.parquet')
GROUP BY basisOfRecord
ORDER BY jumlah_record DESC;
