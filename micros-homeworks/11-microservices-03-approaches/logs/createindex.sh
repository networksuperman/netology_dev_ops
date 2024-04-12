#!/bin/sh
ret_code=22
http_code=$(curl --silent --output $(mktemp) \
    -X POST http://${ELASTICSEARCH_USERNAME}:${ELASTICSEARCH_PASSWORD}@kibana:5601/api/index_patterns/index_pattern \
    -H "kbn-xsrf: true" \
    -H "Content-Type: application/json" \
    -d'
    {
        "override": false,
        "refresh_fields": true,
        "index_pattern": {
            "title":"vector*",
            "timeFieldName":"timestamp"
        }
    }' \
    --write-out "%{http_code}")
if [ "$http_code" == "200" ] || [ "$http_code" == "400" ]; then
    ret_code=0
elif [ "$http_code" == "000" ]; then
    ret_code=22
else
    ret_code=${http_code}
fi
echo $ret_code
exit "$ret_code"