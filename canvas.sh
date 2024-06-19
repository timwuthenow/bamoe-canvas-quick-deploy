export APP_PART_OF=bamoe-canvas-app
export APP_NAME_EXTENDED_SERVICES=bamoe-extended-services
export APP_NAME_CORS_PROXY=bamoe-cors-proxy
export APP_NAME_BAMOE_CANVAS=bamoe-canvas
    export VERSION=9.1.0
    export TAG=-ibm-0001

   echo "Deploying Extended Services"
 
    oc new-app quay.io/bamoe/extended-services:${VERSION}${TAG} --name=$APP_NAME_EXTENDED_SERVICES
 
    oc create route edge --service=$APP_NAME_EXTENDED_SERVICES
 
    oc label services/$APP_NAME_EXTENDED_SERVICES app.kubernetes.io/part-of=$APP_PART_OF
 
    oc label routes/$APP_NAME_EXTENDED_SERVICES app.kubernetes.io/part-of=$APP_PART_OF
 
    oc label deployments/$APP_NAME_EXTENDED_SERVICES app.kubernetes.io/part-of=$APP_PART_OF
 
    oc label deployments/$APP_NAME_EXTENDED_SERVICES app.openshift.io/runtime=golang
 
    echo "Deploying CORS"
 
    oc new-app quay.io/bamoe/cors-proxy:${VERSION}${TAG} --name=$APP_NAME_CORS_PROXY
 
    oc create route edge --service=$APP_NAME_CORS_PROXY
 
    oc label services/$APP_NAME_CORS_PROXY app.kubernetes.io/part-of=$APP_PART_OF
 
    oc label routes/$APP_NAME_CORS_PROXY app.kubernetes.io/part-of=$APP_PART_OF
 
    oc label deployments/$APP_NAME_CORS_PROXY app.kubernetes.io/part-of=$APP_PART_OF
 
    oc label deployments/$APP_NAME_CORS_PROXY app.openshift.io/runtime=nodejs
 
    echo "Deploying Canvas"
 
    oc new-app quay.io/bamoe/canvas:${VERSION}${TAG} --name=$APP_NAME_BAMOE_CANVAS \
      -e KIE_SANDBOX_EXTENDED_SERVICES_URL=https://$(oc get route $APP_NAME_EXTENDED_SERVICES --output jsonpath={.spec.host}) \
      -e KIE_SANDBOX_CORS_PROXY_URL=https://$(oc get route $APP_NAME_CORS_PROXY --output jsonpath={.spec.host})
 
    oc create route edge --service=$APP_NAME_BAMOE_CANVAS
 
    oc label services/$APP_NAME_BAMOE_CANVAS app.kubernetes.io/part-of=$APP_PART_OF
 
    oc label routes/$APP_NAME_BAMOE_CANVAS app.kubernetes.io/part-of=$APP_PART_OF
 
    oc label deployments/$APP_NAME_BAMOE_CANVAS app.kubernetes.io/part-of=$APP_PART_OF
 
    oc label deployments/$APP_NAME_BAMOE_CANVAS app.openshift.io/runtime=js
 
    echo "Canvas Route"
    oc get route $APP_NAME_BAMOE_CANVAS --output jsonpath={.spec.host}