Run the following commands in the terminal where you will the chaos command from:

export INGRESS_HOST=$(kubectl get po -l istio=ingressgateway -n istio-system -o 'jsonpath={.items[0].status.hostIP}')
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT
export PRODUCT_PAGE_URL=http://${GATEWAY_URL}
export JAEGER_HOST=$(kubectl get svc -n istio-system jaeger-agent -o 'jsonpath={.spec.clusterIP}')
export KUBERNETES_CONTEXT=microk8s

Also, fill these manually if you have an Humio account (otherwise leave them blank):

export HUMIO_DATASPACE=
export HUMIO_TOKEN=

