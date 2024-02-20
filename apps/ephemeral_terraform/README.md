# Ephemeral Secrets Demo

## Step
1. Create an IAM User on first AWS account.   Use the following policy as a reference as permission policy

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:getfederationtoken",
                "ec2:Describe*"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": "kms:DescribeKey",
            "Resource": "<arn of kms key on 2nd AWS account>"
        }
    ]
}

2. Copy sample.env as .env, and update the AWS IAM User access key id and secret access key
3. (optional) Update resource-based policy on KMS key on the 2nd 

{
    "Version": "2012-10-17",
    "Id": "key-demo",
    "Statement": [
        ...
        {
            "Sid": "Allow use of the key",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:sts::<1st aws account id>:federated-user/...emeralsecret-apps-quincycheng"
            },
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:DescribeKey"
            ],
            "Resource": "*"
        }
    ]
}