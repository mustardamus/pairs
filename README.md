# Pairs.io - A web remote control

## Introduction

## Installation

First install all the third party tools and libraries via:

    npm install
    bower install
    npm install coffee-script -g

Next we need to initialize the flat files for storing the numbers of visits and
pairings:

    mkdir statistics
    echo 1 > statistics/visits.txt
    echo 1 > statistics/pairings.txt

## Run local environment

Since we are using multiple devices (desktop and mobile(s)) to test the whole
thing, we need to specify the IP address for the local network. First find out
your IP in your network, if you are on a Unix:

    ifconfig

Then update the hardcoded IP address in the following files:

- `./app/index.html`
- `./app/remote.html`
- `./app/scripts/socket.coffee`
- `./app/scripts/desktop/qrcode.coffee`

Sweet. Now let's start the backend socket server:

    coffee server/socket.coffee

And the frontend development server:

    gulp

If everything is working fine, visit `http://<local-ip-address>:9000`.

## Resources

- remotes picture: https://secure.flickr.com/photos/79818573@N04/10730490594/sizes/k/
- phone picture: http://dribbble.com/shots/1193973-Flat-Nexus-4-Phone
- css spinners: http://css-spinners.com/#/spinner/gauge/
