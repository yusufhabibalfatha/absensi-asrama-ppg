START TRANSACTION;

INSERT INTO ppg_generus (
    id,
    kelompok_id,
    nama_lengkap,
    nama_panggilan,
    jenis_kelamin,
    tempat_lahir,
    tanggal_lahir,
    golongan_darah
)
SELECT 
    g.id,
    (
        SELECT id 
        FROM ppg_kelompok 
        WHERE nama = 'Amin Manshurin'
    ),
    g.nama_lengkap,
    g.nama_panggilan,
    CASE 
        WHEN g.jenis_kelamin = 'Laki-laki' THEN 'L'
        WHEN g.jenis_kelamin = 'Perempuan' THEN 'P'
        ELSE 'L'
    END,
    g.tempat_lahir,
    g.tanggal_lahir,
    g.golongan_darah
FROM wp_ppg_generus g
JOIN wp_ppg_alamat_sambung a
    ON g.id = a.id_generus
WHERE a.kelompok = 'Amin Manshurin';

INSERT INTO ppg_generus_alamat (
    generus_id,
    jalan,
    rt,
    rw,
    kelurahan,
    kecamatan
)
SELECT 
    al.id_generus,
    al.jalan,
    al.rt,
    al.rw,
    al.kelurahan,
    al.kecamatan
FROM wp_ppg_alamat al
JOIN wp_ppg_alamat_sambung a
    ON al.id_generus = a.id_generus
WHERE a.kelompok = 'Amin Manshurin';

INSERT INTO ppg_orang_tua (
    generus_id,
    nama_ayah,
    nama_ibu,
    pekerjaan_ayah,
    pekerjaan_ibu,
    pendidikan_ayah,
    pendidikan_ibu,
    no_hp
)
SELECT 
    o.id_generus,
    o.nama_ayah,
    o.nama_ibu,
    o.pekerjaan_ayah,
    o.pekerjaan_ibu,
    o.pendidikan_terakhir_ayah,
    o.pendidikan_terakhir_ibu,
    o.no_hp
FROM wp_ppg_orangtua o
JOIN wp_ppg_alamat_sambung a
    ON o.id_generus = a.id_generus
WHERE a.kelompok = 'Amin Manshurin';

INSERT INTO ppg_generus_no_hp (
    generus_id,
    no_hp,
    tipe
)
SELECT 
    n.id_generus,
    n.no_hp,
    'utama'
FROM wp_ppg_no_hp_generus n
JOIN wp_ppg_alamat_sambung a
    ON n.id_generus = a.id_generus
WHERE a.kelompok = 'Amin Manshurin';

INSERT IGNORE INTO ppg_hobi (nama)
SELECT DISTINCT h.hobi
FROM wp_ppg_hobi h
JOIN wp_ppg_alamat_sambung a
    ON h.id_generus = a.id_generus
WHERE a.kelompok = 'Amin Manshurin'
AND h.hobi IS NOT NULL;

INSERT IGNORE INTO ppg_generus_hobi (generus_id, hobi_id)
SELECT DISTINCT
    h.id_generus,
    b.id
FROM wp_ppg_hobi h
JOIN wp_ppg_alamat_sambung a
    ON h.id_generus = a.id_generus
JOIN ppg_hobi b
    ON h.hobi = b.nama
WHERE a.kelompok = 'Amin Manshurin';


INSERT INTO ppg_pendidikan (
    generus_id,
    jenjang,
    nama_sekolah
)
SELECT 
    p.id_generus,
    p.jenjang_pendidikan,
    p.nama_sekolah
FROM wp_ppg_pendidikan p
JOIN wp_ppg_alamat_sambung a
    ON p.id_generus = a.id_generus
WHERE a.kelompok = 'Amin Manshurin';

INSERT INTO ppg_generus_prestasi (
    generus_id,
    prestasi
)
SELECT 
    pr.id_generus,
    pr.prestasi
FROM wp_ppg_prestasi pr
JOIN wp_ppg_alamat_sambung a
    ON pr.id_generus = a.id_generus
WHERE a.kelompok = 'Amin Manshurin';

INSERT INTO ppg_generus_kejuaraan (
    generus_id,
    kejuaraan
)
SELECT 
    k.id_generus,
    k.kejuaraan
FROM wp_ppg_kejuaraan k
JOIN wp_ppg_alamat_sambung a
    ON k.id_generus = a.id_generus
WHERE a.kelompok = 'Amin Manshurin';

INSERT IGNORE INTO ppg_minat (nama)
SELECT DISTINCT m.minat
FROM wp_ppg_minat m
JOIN wp_ppg_alamat_sambung a
    ON m.id_generus = a.id_generus
WHERE a.kelompok = 'Amin Manshurin'
AND m.minat IS NOT NULL;

INSERT IGNORE INTO ppg_generus_minat (generus_id, minat_id)
SELECT DISTINCT
    m.id_generus,
    b.id
FROM wp_ppg_minat m
JOIN wp_ppg_alamat_sambung a
    ON m.id_generus = a.id_generus
JOIN ppg_minat b
    ON m.minat = b.nama
WHERE a.kelompok = 'Amin Manshurin';

INSERT IGNORE INTO ppg_cita_cita (nama)
SELECT DISTINCT c.cita_cita
FROM wp_ppg_cita_cita c
JOIN wp_ppg_alamat_sambung a
    ON c.id_generus = a.id_generus
WHERE a.kelompok = 'Amin Manshurin'
AND c.cita_cita IS NOT NULL;

INSERT INTO ppg_generus_cita_cita (generus_id, cita_cita_id)
SELECT 
    c.id_generus,
    b.id
FROM wp_ppg_cita_cita c
JOIN wp_ppg_alamat_sambung a
    ON c.id_generus = a.id_generus
JOIN ppg_cita_cita b
    ON c.cita_cita = b.nama
WHERE a.kelompok = 'Amin Manshurin';

INSERT IGNORE INTO ppg_jenjang (nama, urutan)
SELECT DISTINCT 
    p.jenjang_pembinaan,
    1
FROM wp_ppg_pembinaan p
JOIN wp_ppg_alamat_sambung a
    ON p.id_generus = a.id_generus
WHERE a.kelompok = 'Amin Manshurin'
AND p.jenjang_pembinaan IS NOT NULL;

INSERT INTO ppg_generus_jenjang (
    generus_id,
    jenjang_id,
    tahun,
    status
)
SELECT 
    p.id_generus,
    j.id,
    2025,
    'aktif'
FROM wp_ppg_pembinaan p
JOIN wp_ppg_alamat_sambung a
    ON p.id_generus = a.id_generus
JOIN ppg_jenjang j
    ON p.jenjang_pembinaan = j.nama
WHERE a.kelompok = 'Amin Manshurin';
