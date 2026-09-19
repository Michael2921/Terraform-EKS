resource "helm_release" "phpmyadmin" {
    name = "phpmyadmin-release"
    repository = "https://charts.bitnami.com/bitnami"
    chart = "phpmyadmin"
    version = "20.0.0" 
    timeout = 120


    values = ["${file("helmvalues-phpmyadmin.yaml")}"]


}