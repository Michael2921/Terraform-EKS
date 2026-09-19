output "gp3_storageclass" {
    value = kubernetes_storage_class_v1.gp3.metadata[0].name

}

output "mysql_secrets" {
    value = {
        for namespace, secret in kubernetes_secret_v1.mysql_creds :
        namespace => secret.metadata[0].name
    }

}