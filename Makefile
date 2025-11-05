default: aws-deploy
init:
	terraform init
	
apply:
	terraform apply -auto-approve

build:
	npm install
	npm run build

docker-build:
	docker build -t jewelry-app .

docker-run: docker-build
	docker run -p 8080:80 jewelry-app

aws-deploy: init apply
	@echo "Aguarde alguns minutos para a aplicação inicializar..."
	@echo "URL: http://$$(terraform output -raw vm_public_ip):8080"

aws-destroy:
	terraform destroy -auto-approve
