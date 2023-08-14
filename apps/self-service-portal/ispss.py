import requests, json, string, random
import boto3
import json
import configparser


from randompassword import *

def onboard(email, name, phone):
    email = email.lower()
    if email.find("@cyberark.com") == -1:
        return "Invalid corp email: email must be @cyberark.com"

    theSecret = get_secrets_from_asm()
    token = getToken(theSecret['username'],theSecret['secret'])

    adminAcc=addUser(token, "admin", email, name+" (Admin)", phone)
    userAcc=addUser(token, "user", email, name+" (User)", phone)

    addUserToRole(token, "19974e99_9e55_49f5_a513_fedfc0cd1227", adminAcc)
    addUserToRole(token, "8adb48d2_f923_4085_8c85_d3e976ce056d", userAcc)

    return "ok"

def getToken(username, password):
    url = "https://apj-secrets.cyberark.cloud/api/idadmin/oauth2/platformtoken"
    payload={'grant_type': 'client_credentials'}
    resp = requests.post(url, data=payload, auth=(username, password))
    j = json.loads(resp.text)
    return j["access_token"]

def addUser(token, role, email, name, phone):
    url = "https://apj-secrets.cyberark.cloud/api/idadmin/CDirectoryService/CreateUser"

    password=generate_random_password(16,3,3,3)

    username=email.split("@")[0]+"+"+role+"@cyberark.cloud.3434"
    headers = {'Content-type': 'application/json', 
               'Accept': '*/*',
               "Authorization": "Bearer "+token}
    payload= json.dumps({
        "Name": username,
        "Password": password,
        "DisplayName": name,
        "Mail": email.split("@")[0]+"+"+role+"@" + email.split("@")[1],
        "MobileNumber": phone
    })
    print(payload)
    resp=requests.post(url, data=payload, headers=headers)
    print(resp.text)
    return username

def addUserToRole(token, role, username):
    url = "https://apj-secrets.cyberark.cloud/api/idadmin/roles/updaterole"
    headers = {'Content-type': 'application/json', 
               'Accept': '*/*',
               "Authorization": "Bearer "+token}
    payload = json.dumps({
      "Name": role,
      "Users": {
        "Add": [
          username
        ]
     }
    })
    requests.post(url, data=payload, headers=headers)
    return "ok"

def get_secrets_from_asm():

    # Get Configuration
    config = configparser.ConfigParser()
    config.read('config.ini')
    shASMName = config['SelfService']['ASMSecretName']

    # Get Secret from ASM
    client = boto3.client('secretsmanager', region_name='us-east-1')
    response = client.get_secret_value(SecretId=shASMName)
    theSecret = json.loads(response['SecretString'])

    return theSecret
