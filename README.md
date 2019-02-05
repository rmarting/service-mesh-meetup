# Managing Microservices with Service Mesh on OpenShift

# Service Mesh

To deploy Service Mesh execute in order the scripts located in 
[servicemesh](./servicemesh) folder.

After installation process the following components will be available:

* OpenShift: https://$(minishift ip):8443/console
* Kiali: https://kiali-istio-system.$(minishift ip).nip.io/console
* Jaeger: https://jaeger-query-istio-system.$(minishift ip).nip.io/search
* Grafana: http://grafana-istio-system.$(minishift ip).nip.io

# Microservices

Microservices deployed are available at:

* Web UI: http://istio-ingressgateway-istio-system.$(minishift ip).nip.io/
* Gateway: http://gateway-coolstore.$(minishift ip).nip.io/api/products
* Catalog: http://catalog-coolstore.$(minishift ip).nip.io/api/catalog
* Inventory: http://inventory-coolstore.$(minishift ip).nip.io/api/inventory/329299 (Sample)

# Break and Fix

[break-and-fix-scripts](./break-and-fix-scripts) folder includes a set of
scripts to reproduce the following cases:

1. Coolstore deployed and running successfully (00-run-load-web-api.sh)
2. Break Catalog (2 pods, 1 down) (01-break-catalog.sh)
3. Notice (Kiali, Grafana, Jaeger)
4. Find the root cause (02-catalog-retry.sh)
5. Fix → retry policy (2 pods, 1 down, avoid the one down!)
6. New version Inventory (03-inventory-v1.sh)
7. Distribute load (04-inventory-v1-v2.sh)
8. Break inventory (2 versions, 1 version down) (05-break-inventory.sh)
9. Notice (Kiali, Grafana, Jaeger)
10. Fix → circuit breaker (avoid damaged version) (06-inventory-cb.sh)
