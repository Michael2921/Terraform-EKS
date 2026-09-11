module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.25.0"

  addons = {
    coredns = {}
    eks-pod-identity-agent = {
        before_compute = true
    }
    kube-proxy = {}
    vpc-cni = {
        before_compute = true
    }

  }

  name = "company-cluster"
  kubernetes_version = 1.36

  subnet_ids = module.company-vpc.private_subnets
  vpc_id = module.myapp-vpc.vpc_id

  endpoint_public_access = true // to run kubectl locally
  enable_cluster_creator_admin_permissions = true // cluster creator is admin

  eks_managed_node_groups = {
    company-nodegroup = { # name of the node group
    ami_type = "AL2023_x86_64_STANDARD"
    instance_types = ["t2.small"]

    min_size = 1
    max_size = 3
    desired_size = 3

    }

    tags = {
        environment = "testing"
        application "company-app"
    }

  }











}