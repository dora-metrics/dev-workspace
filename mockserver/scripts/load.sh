#!/bin/bash
# reset all data
curl -v -X PUT "http://localhost:9090/mockserver/reset"

# load data from json file
curl -v -X PUT "http://localhost:9090/mockserver/expectation" -d @${PROJECTS_ROOT}/dev-workspace/mockserver/mockdata.json
