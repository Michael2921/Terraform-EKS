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


}