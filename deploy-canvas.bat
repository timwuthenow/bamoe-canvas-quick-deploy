@echo off
setlocal

set APP_PART_OF=bamoe-canvas-app
set APP_NAME_EXTENDED_SERVICES=bamoe-extended-services
set APP_NAME_CORS_PROXY=bamoe-cors-proxy
set APP_NAME_BAMOE_CANVAS=bamoe-canvas
set VERSION=9.1.1
set TAG=-ibm-0003

echo Deploying Extended Services

oc new-app quay.io/bamoe/extended-services:%VERSION%%TAG% --name=%APP_NAME_EXTENDED_SERVICES%

oc create route edge --service=%APP_NAME_EXTENDED_SERVICES%

oc label services/%APP_NAME_EXTENDED_SERVICES% app.kubernetes.io/part-of=%APP_PART_OF%

oc label routes/%APP_NAME_EXTENDED_SERVICES% app.kubernetes.io/part-of=%APP_PART_OF%

oc label deployments/%APP_NAME_EXTENDED_SERVICES% app.kubernetes.io/part-of=%APP_PART_OF%

oc label deployments/%APP_NAME_EXTENDED_SERVICES% app.openshift.io/runtime=golang

echo Deploying CORS

oc new-app quay.io/bamoe/cors-proxy:%VERSION%%TAG% --name=%APP_NAME_CORS_PROXY%

oc create route edge --service=%APP_NAME_CORS_PROXY%

oc label services/%APP_NAME_CORS_PROXY% app.kubernetes.io/part-of=%APP_PART_OF%

oc label routes/%APP_NAME_CORS_PROXY% app.kubernetes.io/part-of=%APP_PART_OF%

oc label deployments/%APP_NAME_CORS_PROXY% app.kubernetes.io/part-of=%APP_PART_OF%

oc label deployments/%APP_NAME_CORS_PROXY% app.openshift.io/runtime=nodejs

echo Deploying Canvas

for /f "tokens=*" %%i in ('oc get route %APP_NAME_EXTENDED_SERVICES% --output jsonpath={.spec.host}') do set EXTENDED_SERVICES_URL=%%i
for /f "tokens=*" %%i in ('oc get route %APP_NAME_CORS_PROXY% --output jsonpath={.spec.host}') do set CORS_PROXY_URL=%%i

oc new-app quay.io/bamoe/canvas:%VERSION%%TAG% --name=%APP_NAME_BAMOE_CANVAS% -e KIE_SANDBOX_EXTENDED_SERVICES_URL=https://%EXTENDED_SERVICES_URL% -e KIE_SANDBOX_CORS_PROXY_URL=https://%CORS_PROXY_URL%

oc create route edge --service=%APP_NAME_BAMOE_CANVAS%

oc label services/%APP_NAME_BAMOE_CANVAS% app.kubernetes.io/part-of=%APP_PART_OF%

oc label routes/%APP_NAME_BAMOE_CANVAS% app.kubernetes.io/part-of=%APP_PART_OF%

oc label deployments/%APP_NAME_BAMOE_CANVAS% app.kubernetes.io/part-of=%APP_PART_OF%

oc label deployments/%APP_NAME_BAMOE_CANVAS% app.openshift.io/runtime=js

echo Canvas Route
oc get route %APP_NAME_BAMOE_CANVAS% --output jsonpath={.spec.host}


set BAMOE_MAVEN_REPOSITORY_IMAGE=maven-repository:%VERSION%%TAG%
set BAMOE_MAVEN_REPOSITORY_IMAGE=quay.io/bamoe/%BAMOE_MAVEN_REPOSITORY_IMAGE%

oc new-app %BAMOE_MAVEN_REPOSITORY_IMAGE% --name bamoe-maven-repo
oc create route edge --service=bamoe-maven-repo
oc get route bamoe-maven-repo --output jsonpath={.spec.host}

endlocal
