FROM docker.io/golang:alpine

RUN mkdir /app
COPY . /app
WORKDIR /app

RUN apk add curl
RUN curl -sSL https://raw.githubusercontent.com/cyberark/summon/main/install.sh | sh

RUN go build -o main .

COPY summon-conjur /usr/local/lib/summon/

CMD ["/usr/local/bin/summon","-f","/app/secrets.yml","-p","/app/summon-conjur","/app/main"]

