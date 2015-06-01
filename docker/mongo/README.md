```bash
d build -t pemarchandet/mongo-asv-la-soiree .
d run -d -p 27017:27017 --name mongo-asv-la-soiree pemarchandet/mongo-asv-la-soiree
# Troubleshooting
d exec -ti mongo-asv-la-soiree bash
d run -ti -P pemarchandet/mongo-asv-la-soiree bash
# Checking log with exiting
d logs -f pemarchandet/mongo-asv-la-soiree
# Checking the last log and exit
d logs pemarchandet/mongo-asv-la-soiree
```
