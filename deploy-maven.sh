export BAMOE_MAVEN_REPOSITORY_IMAGE=maven-repository:9.1.1-ibm-0003 
export BAMOE_MAVEN_REPOSITORY_IMAGE=quay.io/bamoe/$BAMOE_MAVEN_REPOSITORY_IMAGE
oc new-app ${BAMOE_MAVEN_REPOSITORY_IMAGE} --name bamoe-maven-repo
oc create route edge --service=bamoe-maven-repo
oc get route bamoe-maven-repo --output jsonpath={.spec.host}
