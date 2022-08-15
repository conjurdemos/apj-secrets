import boto3
import json
import configparser

def get_secrets_from_asm():

    # Get Configuration
    config = configparser.ConfigParser()
    config.read('config.ini')
    shASMName = config['SecretsHub']['ASMSecretName']

    # Get Secret from ASM
    client = boto3.client('secretsmanager', region_name='us-east-1')
    response = client.get_secret_value(SecretId=shASMName)
    theSecret = json.loads(response['SecretString'])

    return { 
        "shASMName": shASMName,
    	"dbUser": theSecret['username'],
        "dbPass": theSecret['secret'],
        "dbName": theSecret['Database'],
        "dbAddr": theSecret['address']
    }
