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