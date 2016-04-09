import subprocess
import cfscrape
import requests

requests.packages.urllib3.util.ssl_.DEFAULT_CIPHERS = 'ALL'

cookie_arg, user_agent = cfscrape.get_cookie_string("https://aduanku.my")
print("Cookie: ", cookie_arg, " Agent:", user_agent)
result = subprocess.check_output(["curl", "--cookie", cookie_arg, "-A", user_agent, "https://aduanku.my/open311/v2/requests.json", "-o", "./DATA/all-aduanku-requests.json"])
