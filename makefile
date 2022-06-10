mounts:
	minikube mount $(shell pwd):/mimir

dirs:
	mkdir -p /data/mimir-blocks
	mkdir -p /data/mimir-ruler
	mkdir -p /data/mimir-alertmanager

run:
	kubectl create namespace cos
	kubectl config set-context --current --namespace=cos

clean:
	kubectl delete namespace cos
	kubectl config set-context --current --namespace=default

dataclean: 
	rm -rf data/*
	rm -rf data/.minio.sys
	rm -rf data/.writable*
