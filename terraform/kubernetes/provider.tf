provider "aws" {
    region = "us-east-1"
}

provider "kubernetes" {
    host = data.terraform_remote_state.infrastructure.outputs.cluster_endpoint
    token = data.aws_eks_cluster_auth.cluster.token
    cluster_ca_certificate = base64decode(data.terraform_remote_state.infrastructure.outputs.cluster_certificate_authority_data)

}

data "aws_eks_cluster_auth" {
    name = data.terraform_remote_state.infrastructure.outputs.cluster_name
}

provider "helm" {
     kubernetes = {
    host = data.terraform_remote_state.infrastructure.outputs.cluster_endpoint
    token = data.aws_eks_cluster_auth.cluster.token
    cluster_ca_certificate = base64decode(data.terraform_remote_state.infrastructure.outputs.cluster_certificate_authority_data)

}


}
