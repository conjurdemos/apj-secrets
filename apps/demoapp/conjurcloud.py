import configparser

import os, boto3, base64, json, requests
import urllib.parse
from signer import authenticate_conjur_with_iam, fetch_aws_headers


def get_secrets_from_conjur_cloud():

    # Get Configuration
    config = configparser.ConfigParser()
    config.read('config.ini')

    ccPathUser = config['ConjurCloud']['DatabaseUser']
    ccPathPass = config['ConjurCloud']['DatabasePassword']
    ccPathName = config['ConjurCloud']['DatabaseName']
    ccPathAddr = config['ConjurCloud']['DatabaseAddress']

    awsRole = config['ConjurCloud']['AWSRole']
    awsRegion = config['ConjurCloud']['AWSRegion']

    conjurUrl = config['ConjurCloud']['ConjurURL']
    conjurAccount = config['ConjurCloud']['ConjurAccount']
    conjurService = config['ConjurCloud']['ConjurService']
    conjurAppId = config['ConjurCloud']['ConjurAppId']

    #Get Conjur Access Token
    headers = fetch_aws_headers()
    token_b64 = authenticate_conjur_with_iam(headers)

    #now we can retrieve secrets to our heart's content
    retrieve_variable_url = "{conjur_appliance_url}/secrets/{account}/variable/".format(
                            conjur_appliance_url = conjurUrl,
                            account = conjurAccount
                            )
    dbUser = requests.get(retrieve_variable_url + ccPathUser, headers={'Authorization' : "Token token=\"" + token_b64 + "\""}).text
    dbPass = requests.get(retrieve_variable_url + ccPathPass, headers={'Authorization' : "Token token=\"" + token_b64 + "\""}).text
    dbName = requests.get(retrieve_variable_url + ccPathName, headers={'Authorization' : "Token token=\"" + token_b64 + "\""}).text
    dbAddr = requests.get(retrieve_variable_url + ccPathAddr, headers={'Authorization' : "Token token=\"" + token_b64 + "\""}).text




    # return results
    return { "ccPathUser" : ccPathUser, 
	"ccPathPass": ccPathPass, 
	"ccPathAddr": ccPathAddr, 
	"ccPathName": ccPathName,
	"dbUser": dbUser,
	"dbPass": dbPass,
	"dbName": dbName,
	"dbAddr": dbAddr
    }
  
