resource "kubernetes_namespace_v1" "fargate_namespace" { 
metadata {
    name = "fargate"
}
}



resource "kubernetes_storage_class_v1" "gp3" {
    depends_on = [module.eks]
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


variable "mysql_root_password" {
  type      = string
}

variable "mysql_replication_password" {
  type      = string
}

variable "mysql_user_password" {
  type      = string
}


resource "kubernetes_secret_v1" "mysql_creds" {
    depends_on = [module.eks, kubernetes_namespace_v1.fargate_namespace]
    for_each =  toset(["default", "fargate"])
    metadata {
        name = "mysql-creds"
        namespace = each.value
    }

    data = {
        mysql-root-password = var.mysql_root_password
        mysql-password = var.mysql_user_password
        mysql-replication-password = var.mysql_replication_password
    }

    type = "Opaque"
}

