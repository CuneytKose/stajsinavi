import os
import time
import json
import requests
from dotenv import load_dotenv

load_dotenv()

API_KEY = os.getenv("VT_API_KEY")

INPUT_FILE = 'ips.txt'
MALICIOUS_FILE = 'malicious_ips.txt'
NOT_FOUND_FILE = 'not_found_ips.txt'
RESPONSES_DIR = 'responses'

if not os.path.exists(RESPONSES_DIR):
    os.mkdir(RESPONSES_DIR)

open(MALICIOUS_FILE, 'w').close()
open(NOT_FOUND_FILE, 'w').close()

with open(INPUT_FILE, 'r') as f:
    ip_list = [line.strip() for line in f if line.strip()]

for ip in ip_list:
    print(f"Sorgulanıyor: {ip}")
    url = f"https://www.virustotal.com/api/v3/ip_addresses/{ip}"
    headers = {"x-apikey": API_KEY}

    try:
        response = requests.get(url, headers=headers)
        time.sleep(15)

        if response.status_code == 200:
            data = response.json()

            with open(os.path.join(RESPONSES_DIR, f"{ip}.json"), 'w') as f:
                json.dump(data, f, indent=2)

            stats = data.get("data", {}).get("attributes", {}).get("last_analysis_stats", {})
            malicious = stats.get("malicious", 0)
            suspicious = stats.get("suspicious", 0)

            if malicious >= 1 or suspicious >= 1:
                with open(MALICIOUS_FILE, 'a') as f:
                    f.write(ip + '\n')

        elif response.status_code == 404:
            with open(NOT_FOUND_FILE, 'a') as f:
                f.write(ip + '\n')

        else:
            print(f"{ip} için beklenmeyen bir hata oluştu. Kod: {response.status_code}")

    except Exception as e:
        print(f"Hata oluştu: {ip} - {str(e)}")
