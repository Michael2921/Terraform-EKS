resource "kubernetes_manifest" "java_app" {
  manifest = yamldecode(
    file("${path.module}/java-app.yaml")
  )
}