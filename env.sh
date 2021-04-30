#!/bin/bash

export IMAGE_REPO=YOUR-PREFIX/mindalpha-serving-centos
export RELEASE=example
export CPU_RELEASE=examplecpu
export PREDICT_NAMESPACE=mindalpha-serving
export MINDALPHA_ROLE_ARN=arn:aws:iam::YOUR-ACCOUNT-NUMBER:role/YOUR-ROLE-NAME
export AWS=true
export SERVICE_ACCOUNT_CREATE=true
export SERVICEMONITOR_RELEASE=prometheus-stack
export PROMETHEUS_URL=""
#consul
export CONSUL_DC=dc-consul
export CONSUL_CLUSTER=dc-consul.cluster.com
export CONSUL_KEYPREFIX=data/example
export CONSUL_SERVICE=example.nps.svc.cluster

#oss
export OSS_ENDPOINT=""
export OSS_ID=""
export OSS_SECRET=""

#gpu env
export GPU_NODE_LABEL=nps-gpu-nodes
export GPU=true
export GPU_COUNT=1
export GPU_MIN_REPLICAS=1
export GPU_MAX_REPLICAS=2
export GPU_LIMITES_CPU=800m
export GPU_REQUESTS_CPU=500m
export GPU_LIMITES_MEM=16Gi
export GPU_REQUESTS_MEM=8Gi

#gpu auto scaling param
#if enabled, set it true, otherwise set it false
export AC_METRICS_CPU=true
export AC_METRICS_MEM=false
export AC_METRICS_GPU=true
export AC_METRICS_QPS=true
export AC_METRICS_LATENCY=false

export AC_METRICS_CPU_TARGET_TYPE=Utilization
export AC_METRICS_CPU_TARGET_VALUE=50

export AC_METRICS_MEM_TARGET_TYPE=AverageValue
export AC_METRICS_MEM_TARGET_VALUE=15Gi

export AC_METRICS_GPU_NAME=DCGM_FI_DEV_GPU_per_second
export AC_METRICS_GPU_TARGET_TYPE=AverageValue
export AC_METRICS_GPU_TARGET_VALUE=60

export AC_METRICS_QPS_NAME=nps_server_perfermance_curr_per_second
export AC_METRICS_QPS_TARGET_TYPE=AverageValue
export AC_METRICS_QPS_TARGET_VALUE=1600

export AC_METRICS_LATENCY_NAME=nps_server_perfermance_avg_latency
export AC_METRICS_LATENCY_TARGET_TYPE=AverageValue
export AC_METRICS_LATENCY_TARGET_VALUE=35

#cpu env
export CPU_MIN_REPLICAS=1
export CPU_MAX_REPLICAS=2
export CPU_LIMITES=800m
export CPU_REQUESTS=500m
export MEM_LIMITES=16Gi
export MEM_REQUESTS=8Gi

#cpu auto scaling
export AC_CPU_METRICS_CPU=true
export AC_CPU_METRICS_MEM=false
export AC_CPU_METRICS_QPS=false
export AC_CPU_METRICS_LATENCY=false

export AC_CPU_METRICS_CPU_TARGET_TYPE=Utilization
export AC_CPU_METRICS_CPU_TARGET_VALUE=50

export AC_CPU_METRICS_MEM_TARGET_TYPE=AverageValue
export AC_CPU_METRICS_MEM_TARGET_VALUE=16Gi

export AC_CPU_METRICS_QPS_NAME=""
export AC_CPU_METRICS_QPS_TARGET_TYPE=AverageValue
export AC_CPU_METRICS_QPS_TARGET_VALUE=1600

export AC_CPU_METRICS_LATENCY_NAME=""
export AC_CPU_METRICS_LATENCY_TARGET_TYPE=AverageValue
export AC_CPU_METRICS_LATENCY_TARGET_VALUE=40
