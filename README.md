# ASV, La soirée
A subscription platform based on OrionJS CMS.

## Content
A simple project that requires new plugins for OrionJS. This plugins will
eventually get published on Atmosphere once finished if they are well
enough reusable.

## Note
As this is my first app using OrionJS, consider this repo with care.

## License
MIT

## Requirements
* ffmpeg
```bash
brew install ffmpeg
```
* ImageMagick
```bash
brew install imagemagick
```
* JpegOptim
```bash
brew install jpegoptim
```
* WebP
```bash
brew install webp
```
* Gulp
```bash
npm -g install gulp
cd assets
npm install
```

## Vagrant - Test environment
```
vagrant up
vagrant ssh
sudo bash
apt-get update
apt-get -y upgrade
systemctl enable docker
reboot
vagrant ssh
sudo bash
docker pull pemarchandet/mongo-asv_la_soiree
docker run -d -p 27017:27017 --name mongo-asv_la_soiree pemarchandet/mongo-asv_la_soiree
docker pull pemarchandet/meteor-asv_la_soiree
docker run -d -p 3000:3000 --link mongo-asv_la_soiree:mongo-asv_la_soiree --name meteor-asv_la_soiree pemarchandet/meteor-asv_la_soiree
# It will fails, relaunch it
docker ps -a
docker stop XXX
docker run XXX
docker pull pemarchandet/nginx-asv_la_soiree
docker run --link meteor-asv_la_soiree:meteor-asv_la_soiree --name nginx-asv_la_soiree -d -p 80:80 pemarchandet/nginx-asv_la_soiree
```
