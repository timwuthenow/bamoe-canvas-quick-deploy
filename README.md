# bamoe-canvas-quick-deploy
Repository for quickly deploying BAMOE Canvas to OpenShift.

Login to your OpenShift cluster and pick the namespace that you want to deploy BAMOE Canvas to by running this script. The images are located at Quay.io, so you will need access to that repository to be able to use this. To register with Quay.io, you will need a Red Hat account. This account can be utilized with the free [Red Hat Developer Program](https://developers.redhat.com/articles/faqs-no-cost-red-hat-enterprise-linux) so you can get started quickly!

On a Mac or Linux run `./canvas.sh` and the script will deploy your Canvas instance, the Extended Services and CORS-proxy for Git communication.