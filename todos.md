# To-Do List for March 23, 2025

- [ ] Task 1: Set up Kubernetes SAs and namespaces post cluster creation
      (probably gonna need a Kube Module)
      [Using this approach.](https://cloud.google.com/kubernetes-engine/docs/how-to/cloud-storage-fuse-csi-driver-setup#authentication)
- [ ] Task 2: Create IAM Access to my Bucket(s) for GCSFuse from the created
      cluster
      [Like in this guide](https://cloud.google.com/kubernetes-engine/docs/how-to/persistent-volumes/cloud-storage-fuse-csi-driver)
- [ ] Task 3: Make the deployment use module dependencies for clean code
- [ ] Task 4: Set up a basic helm deployment for a static site container (e.g., nginx) to test GCSFuse connectivity and basic deployment functionality. This will serve as a baseline for verifying the cluster and storage setup.
- [ ] Task 5: Add Cloudflare pod/helm as the frontend using my already done
      tunnels Using
      [this](https://github.com/community-charts/helm-charts/tree/main/charts/cloudflared)
      community helm charta
- [ ] Task 6: Investigate managing secrets entirely within GCP Secrets Manager.
- [ ] Task 7: Get Ghost running internally on cluster using GCSFuse backing
      [Using this guide](https://github.com/bitnami/charts/tree/main/bitnami/ghost/#installing-the-chart)
