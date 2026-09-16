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
    aws-ebs-csi-driver = {}

  }


  // use terraform kubernetes provider to deploy java manifest fils
  // use terraform helm provider to deploy phpmyadmin

  name = "company-cluster"
  kubernetes_version = 1.36

  subnet_ids = module.company-vpc.private_subnets
  vpc_id = module.company-vpc.vpc_id

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
        application = "company-app"
    }

  }

  fargate_profiles = {
    company-fargate = {
        selectors = [
            {
            namespace = "fargate"
        }
        ]

       // subnet_ids = module.company-vpc.private_subnets // test and see what subnets will be used 

    }

  }



}


  module "aws_ebs_csi_pod_identity" {
    source = "terraform-aws-modules/eks-pod-identity/aws"

    name = "aws-ebs-csi"

    attach_aws_ebs_csi_policy = true

    associations = {
      this = {
        cluster_name = module.eks.cluster_name
        namespace = "kube-system"
        service_account = "ebs-csi-controller-sa"
      }
    }
  }