# predict-helm

Predict is an inference service for neural network model, which exported by pytorch torch script. 
This helm chart used to deploy predict service on k8s.
You only need to specify the model path at aws s3 or oss, and some other model information, which stored in consul kv.

## Quickstart

Before installation, you need the following configuration chart, modify and save the contents of the values.yaml file according to your own environment configuration

### Installing

example is your release name.
```bash
    $ helm install example --namespace=mindalpha-serving ./predict
```

### Uninstall
```bash
    $ helm uninstall example -n mindalpha-serving
```

### Upgrade
```bash
    $ helm upgrade --install example --namespace=mindalpha-serving ./predict
```

### List
```bash
    $ helm list -n mindalpha-serving
```

### Manifest
```bash
    $ helm get manifest example -n mindalpha-serving
```

### GPU&CPU deployment

Default，value.yaml support deployment in GPU machines. If you want to deploy in cpu machines, you should use value_cpu.yaml.
You maybe want to specify request weight of every instance type by updating the Values.factor.instance map.

#### GPU
    
```bash
    $ helm install example --namespace=mindalpha-serving ./predict
```

#### CPU
    
```bash
    $ helm install examplecpu --namespace=mindalpha-serving -f ./predict/values_cpu.yaml ./predict
```

## Configuration

The following tables lists the configurable parameters of the predict service chart and their default values
If you have serviceaccount, you should set serviceAccount.create=false and specify actual serviceAccount.name.
You should specify oss config if using aliyun.

| Parameter                                | Required | Description                  |Example                                 |
| ---------------------------------------- | ---------|----------------------------- | -------------------------------------- |
| consul.dc                                | yes      | consul datacenter name       | dc-consul                              |
| consul.cluster                           | yes      | consul cluster address       | dc-consul.cluster.com                  |
| consul.keyprefix                         | yes      | model key predix in consul   | data/example                           |
| consul.service                           | yes      | predict service name         | example.nps.svc.cluster                |
| serviceAccount.create                    | yes      | service account              | false                                  |
| serviceAccount.name                      | yes      | service account name         | example                                |
| aws.enabled                              | no       | aws cloud                    | true                                   |
| oss.endpoint                             | no       | ossutil endpoint             |                                        |
| oss.id                                   | no       | ossutil access id            |                                        |
| oss.secret                               | no       | ossutil access secret        |                                        |
| image.repository                         | yes      |  image                       |                                        |
| autoscaling.minReplicas                  | yes      | min replicas                 | 1                                      |
| autoscaling.maxReplicas                  | yes      | max replicas                 | 2                                      |
| autoscaling.metrics.cpu.enabled          | no       | enabled cpu scaling          | true                                   |
| autoscaling.metrics.cpu.target.type      | no       | target type                  | Utilization                            |
| autoscaling.metrics.cpu.target.value     | no       | target value                 | 50                                     |
| autoscaling.metrics.mem.enabled          | no       | enabled mem scaling          | true                                   |
| autoscaling.metrics.mem.target.type      | no       | target type                  | AverageValue                           |
| autoscaling.metrics.mem.target.value     | no       | target value                 | 15Gi                                   |
| autoscaling.metrics.gpu.enabled          | no       | enabled gpu scaling          | true                                   |
| autoscaling.metrics.gpu.name             | no       | metrics gpu name             | DCGM_FI_DEV_GPU_per_second             |
| autoscaling.metrics.gpu.target.type      | no       | target type                  | AverageValue                           |
| autoscaling.metrics.gpu.target.value     | no       | target value                 | 60                                     |
| autoscaling.metrics.qps.enabled          | no       | enabled qps scaling          | true                                   |
| autoscaling.metrics.qps.name             | no       | metrics qps name             | nps_server_perfermance_curr_per_second |
| autoscaling.metrics.qps.target.type      | no       | target type                  | AverageValue                           |
| autoscaling.metrics.qps.target.value     | no       | target value                 | 600                                    |
| autoscaling.metrics.latency.enabled      | no       | enabled latency scaling      | true                                   |
| autoscaling.metrics.latency.name         | no       | metrics latency name         | nps_server_perfermance_avg_latency     |
| autoscaling.metrics.latency.target.type  | no       | target type                  | AverageValue                           |
| autoscaling.metrics.latency.target.value | no       | target value                 | 600                                    |
| resources.limits.cpu                     | no       | cpu limits                   | 800m                                   |
| resources.limits.memory                  | no       | memory limit                 | 16Gi                                   |
| resources.requests.cpu                   | no       | cpu request                  | 500m                                   |
| resources.requests.memory                | no       | memory request               | 8Gi                                    |
| serviceMonitor.release                   | yes      | prometheus release           | prometheus-stack                       |
| gpu.enabled                              | yes      | deploy in gpu machines       | true                                   |
| gpu.count                                | yes      | gpu count                    | 1                                      |
| factor.unknown                           | no       | default balance weight       | 400                                    |
| factor.instance.g4dn.4xlarge             | no       | g4dn.4xlarge balance weight  | 1600                                   |
| factor.instance.m5.4xlarge               | no       | m5.4xlarge balance weight    | 400                                    |
| factor.instance.r5.4xlarge               | no       | r5.4xlarge balance weight    | 400                                    |
| factor.instance.c5.4xlarge               | no       | c5.4xlarge balance weight    | 400                                    |
| strategy.rollingUpdate.maxSurge          | no       | max surge                    | 1                                      |
| strategy.rollingUpdate.maxUnavailable    | no       | max unavailable              | 0                                      |
