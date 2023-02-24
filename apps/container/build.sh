#!/bin/bash

docker build -t quincycheng/original-simple-golang-app:v1.0 original-simple-golang-app
docker push quincycheng/original-simple-golang-app:v1.0

docker build -t quincycheng/summon-simple-golang-app:v1.0.2 summon-simple-golang-app
docker push quincycheng/summon-simple-golang-app:v1.0.2

docker build -t quincycheng/api-simple-golang-app:v1.0 api-simple-golang-app
docker push quincycheng/api-simple-golang-app:v1.0

