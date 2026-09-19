data "terraform_remote_state" "kubernetes" {
    backend = "s3"
    config = {
        bucket = "terraform-eks20"
        key = "terraform/kubernetes.tfstate"
        region = "us-east-1"
    }

}