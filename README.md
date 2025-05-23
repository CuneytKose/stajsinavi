🛡️ Güvenlik Scriptleri – IP Reputation & Dosya Bütünlüğü Kontrolü
Bu repoda iki farklı güvenlik odaklı betik yer almaktadır. Her biri kendi klasöründe, belirli bir görevi yerine getirmek için yapılandırılmıştır.

📂 python/reputationchecker.py
➤ Amaç:
ips.txt dosyasındaki IP adreslerini VirusTotal Public API üzerinden kontrol eder. IP adresi "malicious" veya "suspicious" olarak işaretlenmişse malicious_ips.txt dosyasına yazılır. Yanıt bulunamazsa not_found_ips.txt dosyasına yazılır. Tüm sonuçlar responses/ klasörüne .json olarak kaydedilir.

🔧 Kurulum:
bash
Kopyala
Düzenle
pip install -r requirements.txt
🔐 API Anahtarı:
.env dosyasına aşağıdaki formatta kaydedilmelidir:

ini
Kopyala
Düzenle
VT_API_KEY=your_virustotal_api_key_here
📁 Girdi:
ips.txt → Her satırda bir IP olacak şekilde liste.

📁 Çıktı:
malicious_ips.txt, not_found_ips.txt, responses/

⚠️ Not:
Rate limit nedeniyle her sorgu arasında otomatik olarak bekleme vardır (15 saniye).

API anahtarı .env içinde saklanır, .gitignore tarafından korunur.

📂 bash/integritycheck.sh
➤ Amaç:
/opt/scripts dizinindeki dosyaların SHA256 hash'lerini kontrol eder. Her gece çalıştırıldığında bu dosyaların değişip değişmediğini tespit eder. Değişmiş, silinmiş veya yeni eklenmiş dosyalar integrity_report.txt dosyasına yazılır.

🧩 Kullanım:
İlk çalıştırmada, mevcut hash değerleri baseline_hashes.txt dosyasına kaydedilir. Sonraki çalışmalarda bu referansla karşılaştırma yapılır.

📁 Çıktı:
baseline_hashes.txt: İlk referans hash'ler

integrity_report.txt: Değişiklik raporu

🕒 Cron Örneği:
bash
Kopyala
Düzenle
0 2 * * * /bin/bash /opt/bash/integritycheck.sh
Yukarıdaki cron satırı scripti her gece 02:00'de çalıştırır.

