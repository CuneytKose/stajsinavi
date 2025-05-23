#!/bin/bash

KONTROL_DIZINI="/opt/scripts"
REFERANS_DOSYA="/opt/baseline_hashes.txt"
RAPOR_DOSYASI="/opt/integrity_report.txt"
GEÇİCİ_DOSYA=$(mktemp)

# Eğer referans dosyası yoksa, ilk çalıştırmadır; dosyaların hash'lerini oluşturup kaydediyoruz
if [ ! -f "$REFERANS_DOSYA" ]; then
    find "$KONTROL_DIZINI" -type f -exec sha256sum {} \; > "$REFERANS_DOSYA"
    exit 0
fi

# Geçerli dosya hash'lerini almak için
find "$KONTROL_DIZINI" -type f -exec sha256sum {} \; > "$GEÇİCİ_DOSYA"

# Rapor dosyasını başlatmak için
echo "==== $(date '+%Y-%m-%d %H:%M:%S') Integrity Report ====" > "$RAPOR_DOSYASI"

# İçeriği değişmiş dosyaları kontrol etmek için
echo -e "\n[!] Değişmiş Dosyalar:" >> "$RAPOR_DOSYASI"
comm -12 <(cut -d' ' -f3- "$REFERANS_DOSYA" | sort) <(cut -d' ' -f3- "$GEÇİCİ_DOSYA" | sort) | while read -r dosya; do
    eski_hash=$(grep " $dosya" "$REFERANS_DOSYA" | cut -d' ' -f1)
    yeni_hash=$(grep " $dosya" "$GEÇİCİ_DOSYA" | cut -d' ' -f1)
    if [ "$eski_hash" != "$yeni_hash" ]; then
        echo "$dosya" >> "$RAPOR_DOSYASI"
    fi
done

# Silinmiş dosyaları bulmak için
echo -e "\n[!] Silinmiş Dosyalar:" >> "$RAPOR_DOSYASI"
comm -23 <(cut -d' ' -f3- "$REFERANS_DOSYA" | sort) <(cut -d' ' -f3- "$GEÇİCİ_DOSYA" | sort) >> "$RAPOR_DOSYASI"

# Yeni eklenmiş dosyaları bulmak için
echo -e "\n[+] Yeni Eklenen Dosyalar:" >> "$RAPOR_DOSYASI"
comm -13 <(cut -d' ' -f3- "$REFERANS_DOSYA" | sort) <(cut -d' ' -f3- "$GEÇİCİ_DOSYA" | sort) >> "$RAPOR_DOSYASI"

# Geçici dosyayı silmek için
rm -f "$GEÇİCİ_DOSYA"
