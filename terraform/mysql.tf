
data "aws_eks_cluster_auth" "cluster" { //retrieves auth token
    name = module.eks.cluster_name

}




provider "kubernetes" {
    host = module.eks.cluster_endpoint
    token = data.aws_eks_cluster_auth.cluster.token
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

}

# create a storage class using the kubernetes provider

resource "kubernetes_storage_class_v1" "gp3" {
    metadata {
        name = "gp3"
    }

    storage_provisioner = "ebs.csi.aws.com"
    volume_binding_mode = "WaitForFirstConsumer"
    allow_volume_expansion = true
    reclaim_policy = "Delete"

    parameters = {
        type = "gp3"
        encrypted = "true"
        fsType = "ext4"
    }
}



provider "helm" {

    provider "kubernetes" {
    host = module.eks.cluster_endpoint
    token = data.aws_eks_cluster_auth.cluster.token
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

}

variable "mysql_root_password" {
  type      = string
}

variable "mysql_replication_password" {
  type      = string
}

variable "mysql_user_password" {
  type      = string
}


user_data = <<EOF
    
    #!/bin/bash
    kubectl create secret generic mysql-creds --from-literal=mysql-root-password=${var.mysql_root_password} --from-literal=mysql-password=${var.mysql_user_password} --from-literal=mysql-replication-password=${var.mysql_replication_password}

    EOF

resource "helm_release" "mysql" {
    name = "mysql-release"
    repository = "https://charts/bitnami.com/bitnami"
    chart = "mysql"
    version = "14.0.3" //watch this version
    timeout = "120"

    // add values file here

    values = ["${file("helmvalues-mysql.yaml")}"]
    

    set {
        name = "volumePermissions.enabled"
        value = true
    }


}

}