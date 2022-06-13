mounts:
	minikube mount $(shell pwd):/mimir

dirs:
	mkdir -p /data

run:
	kubectl create namespace cos && \
	kubectl config set-context --current --namespace=cos
	kubectl apply -f local-storage.yaml
	kubectl apply -f minio.yaml
	kubectl apply -f mimir-volumes.yaml
	kubectl apply -f mimir.yaml
	kubectl apply -f nginx.yaml
	kubectl apply -f prometheus.yaml
	kubectl apply -f grafana.yaml
clean:
	-kubectl delete -f grafana.yaml > /dev/null || true
	-kubectl delete -f prometheus.yaml > /dev/null || true
	-kubectl delete -f nginx.yaml > /dev/null || true
	-kubectl scale statefulset mimir --replicas=0 > /dev/null || true
	-kubectl delete -f mimir.yaml > /dev/null || true
	-kubectl	delete pvc mimir-config-mimir-0 > /dev/null || true
	-kubectl	delete pvc mimir-config-mimir-1 > /dev/null || true
	-kubectl	delete pvc mimir-config-mimir-2 > /dev/null || true
	-kubectl delete pv mimir-0 > /dev/null || true
	-kubectl delete pv mimir-1 > /dev/null || true
	-kubectl delete pv mimir-2 > /dev/null || true
	-kubectl delete -f mimir-volumes.yaml > /dev/null || true
	-kubectl delete -f local-storage.yaml > /dev/null || true
	-kubectl delete -f minio.yaml > /dev/null || true
	-kubectl delete namespace cos > /dev/null || true
	kubectl config set-context --current --namespace=default

dataclean:
	rm -rf data/*
	rm -rf data/.minio.sys
	rm -rf data/.writable*

distclean: clean dataclean

.PHONY: mounts dirs run clean dataclean distclean
