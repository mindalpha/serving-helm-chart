# aws-eks-nodegroups

1. Get `eksctl` from [weaveworks/eksctl](https://github.com/weaveworks/eksctl) and follow the installation guide to get correct permissions.
1. Create a cluster or use an existing cluster with Kubenetes version at 1.18.
2. Modify [values.yaml](values.yaml)
    1. Change cluster name, region, etc according to your EKS cluster
    2. Change VPCs, subnets you would like to use for gpu node groups
    3. Change the IAM Roles to create the nodes
    4. Config SSH Key

    > Note that in this example config, we choose to use AWS EC2 g4dn.4xlarge which provides one Tesla T4 card. You can choose other EC2 instance types according to your needs.

3. Execute `eksctl` to create the two node groups:
    ```shell
    eksctl create nodegroup --config-file values.yaml
    ```