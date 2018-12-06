snap install microk8s --beta --classic
if [[ $? -ne 0 ]]; then
    echo "Failed to install microk8s"
    exit 1
fi

echo
echo "microk8s package installed, waiting for Kubernetes to get started"
microk8s.status --wait-ready
microk8s.enable dns istio


echo
echo "Switching kubectl context to '${CONTEXT_NAME}'"
# add entries to the kubectl configuration file so we can directly use
# the kubectl CLI
CLUSTER_NAME=$(microk8s.kubectl config view -o=jsonpath='{.clusters[0].name}')
CLUSTER_URL=$(microk8s.kubectl config view -o=jsonpath='{.clusters[0].cluster.server}')
kubectl config set-cluster ${CLUSTER_NAME} --server=${CLUSTER_URL}

CREDS_NAME=$(microk8s.kubectl config view -o=jsonpath='{.users[0].name}')
CREDS_USERNAME=$(microk8s.kubectl config view -o=jsonpath='{.users[0].user.username}')
kubectl config set-credentials ${CREDS_NAME} --username=${CREDS_USERNAME}

CONTEXT_NAME=$(microk8s.kubectl config view -o=jsonpath='{.contexts[0].name}')
CONTEXT_USER=$(microk8s.kubectl config view -o=jsonpath='{.contexts[0].context.user}')
kubectl config set-context ${CONTEXT_NAME} --cluster=${CLUSTER_NAME} --user=${CONTEXT_USER}

kubectl config use-context ${CONTEXT_NAME}
echo "Switched kubectl context to '${CONTEXT_NAME}'"

echo
echo "Deploy application"
kubectl label namespace default istio-injection=enabled
kubectl apply -f https://raw.githubusercontent.com/istio/istio/master/samples/bookinfo/platform/kube/bookinfo.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/master/samples/bookinfo/networking/bookinfo-gateway.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/master/samples/bookinfo/networking/destination-rule-all.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/master/samples/bookinfo/networking/virtual-service-all-v1.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/master/samples/bookinfo/networking/virtual-service-reviews-test-v2.yaml
kubectl replace --force -f manifests/service/jaeger-agent.yaml

echo
echo "Please allow for a few minutes for the services to settle."
echo
echo "Then run: `cat scripts/get-env.sh`"

JAEGER_QUERY_HOST=$(kubectl get svc -n istio-system jaeger-query -o 'jsonpath={.spec.clusterIP}')
echo
echo "Jaeger UI is available at http://${JAEGER_QUERY_HOST}:16686/search"
echo