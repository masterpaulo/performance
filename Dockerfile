FROM node:latest

MAINTAINER masterpaulo315 < pet3175@gmail.com >

RUN apt-get update
RUN apt-get upgrade -y

RUN npm install -g pm2 nodemon sails


ADD BOOT /

WORKDIR /src

EXPOSE 1337

CMD bash -C '/BOOT';'bash'