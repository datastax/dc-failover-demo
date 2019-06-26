#!/bin/bash

locust -f locustfile.py --host=http://$1:8080
