# dcgm-exporter

dcgm-exporter

This helm chart cloned from https://nvidia.github.io/gpu-monitoring-tools/helm-charts
verison:2.3.1
We add configmap for metrics csv to expose DCGM_FI_DEV_GPU_UTIL metrics by default.

Quickstart:

    set the namespace and nodestype to install dcgm-exporter
  
    $ helm install dcgm-exporter -n mindalpha-serving --set nodeSelector.nodestype=nps-gpu-nodes dcgm-exporter
