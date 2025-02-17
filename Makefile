.PHONY: test run
test:
	docker build -t terraform-diagram-generator-test:latest --target=test . && \
	docker run -it terraform-diagram-generator-test:latest ./test

run:
	docker build -t terraform-diagram-generator:latest --target=runtime . && \
	docker run -it -v $(PWD):/opt/input:z terraform-diagram-generator:latest /opt/input/test/terraform-aws-eks/eks-managed-node-group