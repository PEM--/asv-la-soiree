```bash
./import.sh
docker build -t pemarchandet/nginx-asv_la_soiree .
docker run --link meteor-asv_la_soiree:meteor-asv_la_soiree --name nginx-asv_la_soiree -d -p 80:80 pemarchandet/nginx-asv_la_soiree
docker exec -ti nginx-asv_la_soiree bash
docker run -ti -P pemarchandet/nginx-asv_la_soiree bash
```
