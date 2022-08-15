import configparser

import os, boto3, base64, json, requests
import urllib.parse
from signer import headers_for_signed_url


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

    #assume AWS role with access to Conjur Secrets
    client = boto3.client('sts')
    assumeConjurRole = client.assume_role(RoleArn=awsRole, RoleSessionName='10001', DurationSeconds=900)


    #get signed AWSv4 headers from STS GetCallerID Function
    signed_headers = headers_for_signed_url(assumeConjurRole["Credentials"]["AccessKeyId"], 
        assumeConjurRole["Credentials"]["SecretAccessKey"], 
        assumeConjurRole["Credentials"]["SessionToken"],
        awsRegion)

    authenticate_url = "{conjur_appliance_url}/authn-iam/{webservice}/{account}/{host}/authenticate".format(
                        conjur_appliance_url = conjurUrl,
                        account = conjurAccount,
                        webservice = conjurService,
                        host = urllib.parse.quote_plus(conjurAppId)
                    )

    authResponse = requests.post(authenticate_url, data=signed_headers)
    #convert auth token to base64
    token_b64 = base64.b64encode(authResponse.text.encode('utf-8')).decode("utf-8")

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
  
