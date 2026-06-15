start: stop
	docker compose up --build -d

stop:
	docker compose down
	

publish:
	@version=${version}; \
	if [ -z "$$version" ]; then version=latest; fi; \
	docker build -t us-central1-docker.pkg.dev/markitos-mdk-gke/mdk-cluster-repo-images/markitos-es-gke-terraform-database:$$version -f backend/Dockerfile backend; \
	docker build -t us-central1-docker.pkg.dev/markitos-mdk-gke/mdk-cluster-repo-images/markitos-es-gke-terraform-frontend:$$version -f frontend/Dockerfile frontend; \
	docker build -t us-central1-docker.pkg.dev/markitos-mdk-gke/mdk-cluster-repo-images/markitos-es-gke-terraform-backend:$$version -f backend/Dockerfile backend; \
	docker push us-central1-docker.pkg.dev/markitos-mdk-gke/mdk-cluster-repo-images/markitos-es-gke-terraform-database:$$version; \
	docker push us-central1-docker.pkg.dev/markitos-mdk-gke/mdk-cluster-repo-images/markitos-es-gke-terraform-frontend:$$version; \
	docker push us-central1-docker.pkg.dev/markitos-mdk-gke/mdk-cluster-repo-images/markitos-es-gke-terraform-backend:$$version;


gcloud-verify:
	echo "Verifying images in Artifact Registry:"
	echo "Listing images in the repository:"
	gcloud artifacts docker images list us-central1-docker.pkg.dev/markitos-mdk-gke/mdk-cluster-repo-images
	gcloud artifacts repositories describe markitos-es-mdk-images --location=us-central1 --project=mdk-pipelines