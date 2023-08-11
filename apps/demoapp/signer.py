import requests
import json
from schema import Schema, And
from urllib.parse import quote

from botocore.auth import SigV4Auth
from botocore.awsrequest import AWSRequest
from botocore.credentials import get_credentials
from botocore.session import Session

REGION = "us-east-1"
SERVICE = "sts"
HOST = "{service}.amazonaws.com".format(service=SERVICE)
URL = "https://{host}/?Action=GetCallerIdentity&Version=2011-06-15".format(host=HOST)
METHOD = "GET"
CONTENT_TYPE = "application/x-www-form-urlencoded; charset=utf-8"
AWS_HEADERS_SCHEMA = Schema({
    "Host": And(str, len),
    "Content-Type": And(str, len),
    "X-Amz-Date": And(str, len),
    "X-Amz-Security-Token": And(str, len),
    "Authorization": And(str, len)
})

def fetch_aws_headers():
    creds = get_credentials(Session())
    sigv4 = SigV4Auth(creds, SERVICE, REGION)
    req = AWSRequest(method=METHOD, url=URL, headers={"Host": HOST, "Content-Type": CONTENT_TYPE})
    sigv4.add_auth(req)
    req = req.prepare()
    aws_headers = dict(req.headers)
    AWS_HEADERS_SCHEMA.validate(aws_headers)
    return aws_headers


AUTHENTICATE_URL = "{url}/{authenticator}/{account}/{identity}/authenticate"

def authenticate_conjur_with_iam(headers:dict):
    url =  "https://apj-secrets.secretsmgr.cyberark.cloud/api"
    identity="host/data/apj_secrets/iam-apps/409556437035/APJSecrets"
    encoded_identity = quote(identity, safe="")
    authn_url = AUTHENTICATE_URL.format(url=url, authenticator="authn-iam/apj_secrets", account="conjur",
                                        identity=encoded_identity)
    response = requests.post(authn_url, headers={ 'Accept-Encoding': 'base64'}, data=json.dumps(headers), verify=True)
    token = response.content.decode("utf-8").strip()
    return token

