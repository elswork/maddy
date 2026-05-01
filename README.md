# maddy

A [Docker](http://docker.com) file to build [maddy](https://github.com/foxcpp/maddy).

Maddy Mail Server implements all functionality required to run a e-mail
server. It can send messages via SMTP (works as MTA), accept messages via SMTP
(works as MX) and store messages while providing access to them via IMAP.
In addition to that it implements auxiliary protocols that are mandatory
to keep email reasonably secure (DKIM, SPF, DMARC, DANE, MTA-STS).

* [Setup tutorial](https://maddy.email/tutorials/setting-up/)
* [Documentation](https://maddy.email/)

> Be aware! You should carefully read the usage documentation of every tool!

## Details

| Website | GitHub | Docker Hub |
| --- | --- | --- |
| [Deft.Work my personal blog](https://deft.work) | [maddy](https://github.com/elswork/maddy) | [maddy](https://hub.docker.com/r/elswork/maddy) |

| Docker Pulls | Docker Stars | Size | Sponsors |
| --- | --- | --- | --- |
| [![Docker pulls](https://img.shields.io/docker/pulls/elswork/maddy.svg)](https://hub.docker.com/r/elswork/maddy "maddy on Docker Hub") | [![Docker stars](https://img.shields.io/docker/stars/elswork/maddy.svg)](https://hub.docker.com/r/elswork/maddy "maddy on Docker Hub") | [![Docker Image size](https://img.shields.io/docker/image-size/elswork/maddy)](https://hub.docker.com/r/elswork/maddy "maddy on Docker Hub") | [![GitHub Sponsors](https://img.shields.io/github/sponsors/elswork)](https://github.com/sponsors/elswork "Sponsor me!") |

## Compatible Architectures

This image has been builded using [buildx](https://docs.docker.com/buildx/working-with-buildx/) for these architectures: 
- amd64 arm64

## Usage Example

### Start container

```bash
docker run --rm elswork/maddy \
 someparameter
```
or
```bash
make start PARAM=someparameter
```
---
**[Sponsor me!](https://github.com/sponsors/elswork) Together we will be unstoppable.**

Other ways to fund me:

[![GitHub Sponsors](https://img.shields.io/github/sponsors/elswork)](https://github.com/sponsors/elswork) [![Donate PayPal](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/donate/?business=LFKA5YRJAFYR6&no_recurring=0&item_name=Open+Source+Donation&currency_code=EUR)