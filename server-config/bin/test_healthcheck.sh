#!/bin/bash

fun_test_healthcheck(){

}
echo "10.10.1.11 "
curl http://10.10.1.11/health-check.php
echo "10.10.1.12 "
curl http://10.10.1.12/health-check.php
echo "10.10.1.13 "
curl http://10.10.1.13/health-check.php
echo "10.10.1.14 "
curl http://10.10.1.14/health-check.php
echo ""