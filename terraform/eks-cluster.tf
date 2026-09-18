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

  name = "company-cluster"
  kubernetes_version = 1.36

  subnet_ids = module.company-vpc.private_subnets
  vpc_id = module.company-vpc.vpc_id

  endpoint_public_access = true // to run kubectl locally
  enable_cluster_creator_admin_permissions = true // cluster creator is admin

  eks_managed_node_groups = {
    company-nodegroup = { # name of the node group
    ami_type = "AL2023_x86_64_STANDARD"
    instance_types = ["t3.medium"]

    min_size = 3
    max_size = 3
    desired_size = 3

    }

    

  }

  tags = {
        environment = "testing"
        application = "company-app"
    }


  fargate_profiles = {
    company-fargate = {
        selectors = [
            {
            namespace = "fargate"
        }
        ]


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


  resource "kubernetes_namespace_v1" "fargate_namespace" {
    metadata {
      name = "fargate"
    }
  }

  resource "aws_vpc_security_group_ingress_rule" "fargate_to_mysql" { # allows fargate pods to access MySQL
  security_group_id            = module.eks.node_security_group_id # node security group
  referenced_security_group_id = module.eks.cluster_primary_security_group_id # cluster security group

  ip_protocol = "tcp"
  from_port   = 3306
  to_port     = 3306

   
}


resource "aws_vpc_security_group_ingress_rule" "fargate_to_node_dns_tcp" { #  allows fargate pods to access DNS over TCP
  security_group_id            = module.eks.node_security_group_id
  referenced_security_group_id = module.eks.cluster_primary_security_group_id

  ip_protocol = "tcp"
  from_port   = 53
  to_port     = 53

 
}

resource "aws_vpc_security_group_ingress_rule" "fargate_to_node_dns_udp" { #  allows fargate pods to access DNS over UDP
  security_group_id            = module.eks.node_security_group_id
  referenced_security_group_id = module.eks.cluster_primary_security_group_id

  ip_protocol = "udp"
  from_port   = 53
  to_port     = 53

  
}
