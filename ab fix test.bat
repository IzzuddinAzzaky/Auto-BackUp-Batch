@echo off
setlocal enabledelayedexpansion

REM Tentukan folder utama tujuan untuk menyimpan file ZIP berdasarkan tanggal hari ini
for /f "delims=" %%a in ('wmic OS Get localdatetime ^| find "."') do set datetime=%%a
set "tanggal_waktu=!datetime:~0,4!-!datetime:~4,2!-!datetime:~6,2!"
set "tujuan_utama=E:\backup\!tanggal_waktu!"

REM Pastikan folder tujuan utama ada, atau buat jika belum ada
if not exist "!tujuan_utama!" mkdir "!tujuan_utama!"

REM Loop untuk setiap folder dalam struktur direktori C:\laragon\www
for /d /r "C:\laragon\www" %%f in (*) do (
    REM Periksa apakah folder ini mengandung subfolder "views"
    if exist "%%f\views" (
        REM Mendapatkan dua nama path terakhir dari path folder sumber
        set "path_sumber=%%~pf"
        for %%I in ("%%~f") do (
            set "folder1=%%~nI"
            set "folder2=views"
        )
        
        REM Tentukan nama file ZIP dengan format nama sesuai dengan yang Anda inginkan dan menyimpannya di folder tujuan yang sesuai dengan tanggal hari ini di E:\backup
        for /f "delims=" %%a in ('wmic OS Get localdatetime ^| find "."') do set datetime=%%a
        set "jam_waktu=!datetime:~8,2!!datetime:~10,2!!datetime:~12,2!"
        set "nama_zip=!tujuan_utama!\!folder1!_!folder2!_!jam_waktu!.zip"
        
        REM Buat file ZIP dari folder sumber dengan opsi -Force dan arahkan pesan kesalahan ke nul
        powershell Compress-Archive -Path "%%f\views" -DestinationPath "!nama_zip!" -Force 2>nul
    )
)

exit
