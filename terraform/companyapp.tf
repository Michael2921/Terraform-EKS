variable "docker_username" {
  type = string
}

variable "docker_PAT" {
  type = string
}


resource "kubernetes_secret_v1" "docker-creds" {
    depends_on = [module.eks]
    metadata {
        name = "docker-creds"
        namespace = "kubernetes_namespace.fargate_namespace.metadata[0].name"
    }

    type = "kubernetes.io/dockerconfigjson"

    data = {
        ".dockerconfigjson" = jsonencode({
            auths = {
                "https://index.docker.io/v1/" = {
                    username = var.docker_username
                    password = var.docker_PAT
                    auth = base64encode("${var.docker_username}:${var.docker_PAT}")
                }
            }
        })
    }


    
}


resource "kubernetes_manifest" "companyapp-configmap" {
  manifest = yamldecode(
    file("companyapp-configmap.yaml")
  )
}


resource "kubernetes_manifest" "companyapp-deployment" {
  manifest = yamldecode(
    file("companyapp-deployment.yaml")
  )
}

resource "kubernetes_manifest" "companyapp-service" {
  manifest = yamldecode(
    file("companyapp-deployment.yaml")
  )
}