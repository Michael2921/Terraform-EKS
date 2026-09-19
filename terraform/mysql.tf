
# data "aws_eks_cluster_auth" "cluster" { //retrieves auth token
#     name = module.eks.cluster_name

# }









# provider "helm" {
#      kubernetes = {
#     host = module.eks.cluster_endpoint
#     token = data.aws_eks_cluster_auth.cluster.token
#     cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

# }


# }


resource "helm_release" "mysql" {
    name = "mysql-release"
    repository = "https://charts.bitnami.com/bitnami"
    chart = "mysql"
    version = "14.0.3" 
    timeout = 120

    // add values file here

    values = ["${file("helmvalues-mysql.yaml")}"]
    

    set = [{
        name = "volumePermissions.enabled"
        value = true
    }]

    depends_on = [
        kubernetes_storage_class_v1.gp3,
        kubernetes_secret_v1.mysql_creds
    ]


}