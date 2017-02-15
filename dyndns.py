import secrets
import sys
import time
import urllib.request
import urllib.error

BREAK_TIME_SEC=60

while True:
    try:
        ip = urllib.request.urlopen('https://icanhazip.com').read().decode()
        print('IP: {ip}'.format(ip=ip))
    except urllib.error.HTTPError as e:
        print('Failed retrieve external ip: {error}'.format(error=e.msg))
        time.sleep(BREAK_TIME_SEC)
        continue

    for target in secrets.domains:
        url = 'https://domains.google.com/nic/update?hostname={hostname}&myip={ip}'.format(**target, ip=ip)
        request = urllib.request.Request(url)
        password_mgr = urllib.request.HTTPPasswordMgrWithDefaultRealm()
        auth_handler = urllib.request.HTTPBasicAuthHandler(password_mgr)
        auth_handler.add_password(None, url, target['username'], target['password'])

        opener = urllib.request.build_opener(auth_handler)

        try:
            response = opener.open(request)
            print('Success for {hostname}: {response}'.format(**target, response=response.read().decode()))
        except urllib.error.HTTPError as e:
            print('Failed to update dns for {hostname}: {error}'.format(**target, error=e.msg))
    time.sleep(BREAK_TIME_SEC)
    sys.stdout.flush()
