module "argocd_dev" {
  source           = "./terraform_argocd_eks"
  eks_cluster_name = "demo-dev"
  chart_version    = "7.4.7"
}


module "argocd_prod" {
  source           = "./terraform_argocd_eks"
  eks_cluster_name = "demo-prod"
  chart_version    = "7.5.0"
}


# Can be deployed ONLY after ArgoCD deployment: depends_on = [module.argocd_dev]
module "argocd_dev_root" {
  source             = "./terraform_argocd_root_eks"
  eks_cluster_name   = "demo-dev"
  git_source_path    = "manifests/demo-dev/applications"
  git_source_repoURL = "git@github.com:chesnokov70/argocd.git"
}

# Can be deployed ONLY after ArgoCD deployment: depends_on = [module.argocd_prod]
module "argocd_prod_root" {
  source             = "./terraform_argocd_root_eks"
  eks_cluster_name   = "demo-prod"
  git_source_path    = "manifests/demo-prod/applications"
  git_source_repoURL = "git@github.com:chesnokov70/argocd.git"
}
