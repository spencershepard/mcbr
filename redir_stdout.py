# this script uses the urllib to send stdin to a web hook via post request, with the message ans json "content"

import sys
import urllib.request

#read the url from 'discord_webhook' file
with open("discord_webhook", "r") as f:
    url = f.read()

print(url)

# get the data from stdin
data = sys.stdin.read()

#json encode the data
data = '{"content": ' + data + '}'

#convert the data to bytes
data = data.encode('utf-8')

# send the data via post request
req = urllib.request.Request(url, data=data, method='POST', headers={'content-type': 'application/json'})

# get the response
with urllib.request.urlopen(req) as response:
    the_page = response.read()

# print the response    
print(the_page)
