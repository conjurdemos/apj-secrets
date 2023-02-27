#!/bin/bash

SECRETS=$(/opt/CARKaim/sdk/clipasswordsdk \
 GetPassword -p AppDescs.AppID=ScriptDemo \
 -p Query="Safe=POV;Folder=Root;Object=Database-MySQL-database.pov.quincycheng.com-app_service" \
 -p RequiredProps=Address,UserName  \
 -o Password,PassProps.Address,PassProps.UserName )

arrSECRETS=(${SECRETS//,/ })

mysql -h ${arrSECRETS[1]} -u ${arrSECRETS[2]} --password=${arrSECRETS[0]} app_db \
  -e "SELECT * from log"

#echo ${arrSECRETS[0]}
