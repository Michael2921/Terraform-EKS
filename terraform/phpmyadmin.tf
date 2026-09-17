data "aws_eks_cluster_auth" "cluster" { //retrieves auth token
    name = module.eks.cluster_name

}


provider "helm" {
     kubernetes = {
    host = module.eks.cluster_endpoint
    token = data.aws_eks_cluster_auth.cluster.token
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

}


}

resource "helm_release" "phpmyadmin" {
    name = "phpmyadmin-release"
    repository = "https://charts.bitnami.com/bitnami"
    chart = "phpmyadmin"
    version = "20.0.0" 
    timeout = 120


    values = ["${file("helmvalues-phpmyadmin.yaml")}"]
    

    depends_on = [
        kubernetes_storage_class_v1.gp3,
        kubernetes_secret_v1.mysql_creds
    ]


}