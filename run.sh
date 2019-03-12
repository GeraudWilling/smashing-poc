
#!/bin/sh
docker run -v=./dashboards:/dashboards -v=./jobs:/jobs -v=./widgets:/widgets -d -e PORT=8080 -p 80:8080 visibilityspots/smashing

