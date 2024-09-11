data "aws_eks_cluster" "this" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = var.eks_cluster_name
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    token                  = data.aws_eks_cluster_auth.this.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  }
}

#---------------------------------add--------------------------------

resource "null_resource" "install_argo_cd_crds" {
  provisioner "local-exec" {
    command = "kubectl apply -f https://github.com/argoproj/argo-cd/blob/master/manifests/crds/application-crd.yaml"
  }

  # Optional: Add a trigger to re-run the provisioner if the CRD URL changes
  triggers = {
    crd_url = "https://github.com/argoproj/argo-cd/blob/master/manifests/crds/application-crd.yaml"
  }
}


#--------------------------------------------------------------------

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm" # Official Chart Repo
  chart            = "argo-cd"                              # Official Chart Name
  namespace        = "argocd"
  version          = var.chart_version
  create_namespace = true
  values           = [file("${path.module}/argocd.yaml")]
}


