AWS_DEFAULT_REGION:=ap-northeast-1
TERRAFORM=$(shell which terraform)
TERRAFORM8=bin/terraform8
terraform_remote_bucket=terraform-sample-tfstate
terraform_remote_key=sample.tfstate
terraform_remote_region=$(AWS_DEFAULT_REGION)
dirs=bin tmp

terraform/plan: .terraform
	$(TERRAFORM) plan

terraform/apply: .terraform
	$(TERRAFORM) apply

terraform/remote_config: .terraform

.terraform:
	$(TERRAFORM) init \
		-backend-config="bucket=$(terraform_remote_bucket)" \
		-backend-config="key=$(terraform_remote_key)" \
		-backend-config="region=$(terraform_remote_region)" \
		-backend=true \
		-force-copy \
		-get=true \
		-input=false

clean:
	rm -rf .terraform

terraform8/remote/config:
	$(TERRAFORM8) remote config \
		-backend=s3 \
		-backend-config="bucket=$(terraform_remote_bucket)" \
		-backend-config="key=$(terraform_remote_key)" \
		-backend-config="region=$(terraform_remote_region)"

OS_TYPE=$(shell echo $(shell uname) | tr A-Z a-z)
OS_ARCH=amd64
$(TERRAFORM8): $(dirs)
	wget https://releases.hashicorp.com/terraform/0.8.8/terraform_0.8.8_$(OS_TYPE)_$(OS_ARCH).zip -O ./tmp/terraform_0.8.8.zip
	cd tmp && unzip ./terraform_0.8.8.zip
	mv tmp/terraform $@

$(dirs):
	mkdir -p $@

