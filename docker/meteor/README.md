```bash
./import.sh
d build -t pemarchandet/meteor-asv_la_soiree .
d run -d -p 3000:3000 --link mongo-asv_la_soiree:mongo-asv_la_soiree --name meteor-asv_la_soiree pemarchandet/meteor-asv_la_soiree
d exec -ti meteor-asv_la_soiree bash
d run -ti -P pemarchandet/meteor-asv_la_soiree bash
# Checking log with exiting
d logs -f pemarchandet/meteor-asv_la_soiree
# Checking the last log and exit
d logs pemarchandet/meteor-asv_la_soiree
```
