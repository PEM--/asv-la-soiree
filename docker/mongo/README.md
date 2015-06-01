```bash
d build -t pemarchandet/mongo-asv_la_soiree .
d run -d -p 27017:27017 --name mongo-asv_la_soiree pemarchandet/mongo-asv_la_soiree
# Troubleshooting
d exec -ti mongo-asv_la_soiree bash
d run -ti -P pemarchandet/mongo-asv_la_soiree bash
# Checking log with exiting
d logs -f pemarchandet/mongo-asv_la_soiree
# Checking the last log and exit
d logs pemarchandet/mongo-asv_la_soiree
```
