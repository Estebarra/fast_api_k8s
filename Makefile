.PHONY: build, push, deploy

build:
		docker build -t estebarra/fast_api_test .

push:
		docker push estebarra/fast_api_test:latest

deploy:
		kubectl apply -f deployment.yaml
		kubectl apply -f service.yaml
