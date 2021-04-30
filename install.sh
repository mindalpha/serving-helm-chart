#!/bin/bash
set -e

source env.sh

function init() {
    set +e
    exist=$(kubectl get namespace | grep -w "${PREDICT_NAMESPACE}")
    if [[ -z $exist ]]; then
        kubectl create namespace ${PREDICT_NAMESPACE}
        if [[ $? -ne 0 ]]; then
            echo "create namespace ${PREDICT_NAMESPACE} failed"
            exit 255
        fi
    fi
    set -e
}

function dcgm_install() {
    #install dcgm-exporter, set the namespace and nodestype
    #if we deploy at gpu machine, this step is necessary.
    helm upgrade --install dcgm-exporter ./dcgm-exporter  \
        --namespace monitoring  \
        --set nodeSelector.nodestype=${GPU_NODE_LABEL}
}

function adapter_install() {
    #add prometheus-community repo
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    helm repo update
    #install prometheus-adapter for auto scaling by custom metrics
    helm upgrade --install prometheus-adapter prometheus-community/prometheus-adapter \
        --set prometheus.url=${PROMETHEUS_URL}  \
        -f prometheus-adapter/prometheus_adapter.yaml
}

function gpu_install() {
    #install predict at gpus
    helm upgrade --install ${RELEASE} --namespace=${PREDICT_NAMESPACE} ./predict \
	--set image.repository=${IMAGE_REPO} \
        --set gpu.enabled=$GPU \
        --set gpu.count=${GPU_COUNT} \
        --set consul.dc=${CONSUL_DC} \
        --set consul.cluster=${CONSUL_CLUSTER} \
        --set consul.keyprefix=${CONSUL_KEYPREFIX} \
        --set consul.service=${CONSUL_SERVICE} \
        --set serviceAccount.create=${SERVICE_ACCOUNT_CREATE} \
        --set aws.enabled=${AWS} \
        --set aws.role=${MINDALPHA_ROLE_ARN} \
        --set oss.endpoint=${OSS_ENDPOINT} \
        --set oss.id=${OSS_ID} \
        --set oss.secret=${OSS_SECRET} \
        --set autoscaling.minReplicas=${GPU_MIN_REPLICAS} \
        --set autoscaling.maxReplicas=${GPU_MAX_REPLICAS} \
        --set autoscaling.metrics.cpu.enabled=${AC_METRICS_CPU} \
        --set autoscaling.metrics.mem.enabled=${AC_METRICS_MEM} \
        --set autoscaling.metrics.gpu.enabled=${AC_METRICS_GPU} \
        --set autoscaling.metrics.qps.enabled=${AC_METRICS_QPS} \
        --set autoscaling.metrics.latency.enabled=${AC_METRICS_LATENCY} \
        --set autoscaling.metrics.cpu.target.type=${AC_METRICS_CPU_TARGET_TYPE} \
        --set autoscaling.metrics.cpu.target.value=${AC_METRICS_CPU_TARGET_VALUE} \
        --set autoscaling.metrics.mem.target.type=${AC_METRICS_MEM_TARGET_TYPE} \
        --set autoscaling.metrics.mem.target.value=${AC_METRICS_MEM_TARGET_VALUE} \
        --set autoscaling.metrics.gpu.target.name=${AC_METRICS_GPU_TARGET_NAME} \
        --set autoscaling.metrics.gpu.target.type=${AC_METRICS_GPU_TARGET_TYPE} \
        --set autoscaling.metrics.gpu.target.value=${AC_METRICS_GPU_TARGET_VALUE} \
        --set autoscaling.metrics.qps.target.name=${AC_METRICS_QPS_TARGET_NAME} \
        --set autoscaling.metrics.qps.target.type=${AC_METRICS_QPS_TARGET_TYPE} \
        --set autoscaling.metrics.qps.target.value=${AC_METRICS_QPS_TARGET_VALUE} \
        --set autoscaling.metrics.latency.target.name=${AC_METRICS_LATENCY_TARGET_NAME} \
        --set autoscaling.metrics.latency.target.type=${AC_METRICS_LATENCY_TARGET_TYPE} \
        --set autoscaling.metrics.latency.target.value=${AC_METRICS_LATENCY_TARGET_VALUE} \
        --set resources.limits.cpu=${GPU_LIMITES_CPU} \
        --set resources.limits.memory=${GPU_LIMITES_MEM} \
        --set resources.requests.cpu=${GPU_REQUESTS_CPU} \
        --set resources.requests.memory=${GPU_REQUESTS_MEM} \
        --set serviceMonitor.release=${SERVICEMONITOR_RELEASE}
}

function cpu_install() {
    #install predict at cpu, if you need. Commented below if you only deploy it at gpu
    helm upgrade --install ${CPU_RELEASE} --namespace=${PREDICT_NAMESPACE} ./predict \
	--set image.repository=${IMAGE_REPO} \
        --set consul.dc=${CONSUL_DC} \
        --set consul.cluster=${CONSUL_CLUSTER} \
        --set consul.keyprefix=${CONSUL_KEYPREFIX} \
        --set consul.service=${CONSUL_SERVICE} \
        --set serviceAccount.create=${SERVICE_ACCOUNT_CREATE} \
        --set aws.enabled=${AWS} \
        --set aws.role=${MINDALPHA_ROLE_ARN} \
        --set oss.endpoint=${OSS_ENDPOINT} \
        --set oss.id=${OSS_ID} \
        --set oss.secret=${OSS_SECRET} \
        --set autoscaling.minReplicas=${CPU_MIN_REPLICAS} \
        --set autoscaling.maxReplicas=${CPU_MAX_REPLICAS} \
        --set autoscaling.metrics.cpu.enabled=${AC_CPU_METRICS_CPU} \
        --set autoscaling.metrics.mem.enabled=${AC_CPU_METRICS_MEM} \
        --set autoscaling.metrics.qps.enabled=${AC_CPU_METRICS_QPS} \
        --set autoscaling.metrics.latency.enabled=${AC_CPU_METRICS_LATENCY} \
        --set autoscaling.metrics.cpu.target.type=${AC_CPU_METRICS_CPU_TARGET_TYPE} \
        --set autoscaling.metrics.cpu.target.value=${AC_CPU_METRICS_CPU_TARGET_VALUE} \
        --set autoscaling.metrics.mem.target.type=${AC_CPU_METRICS_MEM_TARGET_TYPE} \
        --set autoscaling.metrics.mem.target.value=${AC_CPU_METRICS_MEM_TARGET_VALUE} \
        --set autoscaling.metrics.qps.target.name=${AC_CPU_METRICS_QPS_TARGET_NAME} \
        --set autoscaling.metrics.qps.target.type=${AC_CPU_METRICS_QPS_TARGET_TYPE} \
        --set autoscaling.metrics.qps.target.value=${AC_CPU_METRICS_QPS_TARGET_VALUE} \
        --set autoscaling.metrics.latency.target.name=${AC_CPU_METRICS_LATENCY_TARGET_NAME} \
        --set autoscaling.metrics.latency.target.type=${AC_CPU_METRICS_LATENCY_TARGET_TYPE} \
        --set autoscaling.metrics.latency.target.value=${AC_CPU_METRICS_LATENCY_TARGET_VALUE} \
        --set resources.limits.cpu=${CPU_LIMITES} \
        --set resources.limits.memory=${MEM_LIMITES} \
        --set resources.requests.cpu=${CPU_REQUESTS} \
        --set resources.requests.memory=${MEM_REQUESTS} \
        --set serviceMonitor.release=${SERVICEMONITOR_RELEASE} \
        -f ./predict/values_cpu.yaml
}
function uninstall() {
    set +e
    helm uninstall ${CPU_RELEASE} --namespace=${PREDICT_NAMESPACE}
    code=$?
    helm uninstall ${RELEASE} --namespace=${PREDICT_NAMESPACE}
    ((code+=$?))

    #helm uninstall prometheus-adapter
    #helm uninstall dcgm-exporter --namespace monitoring

    if [ $code -ne 0 ];then
        echo "uninstall() failed"
    fi

    exit $code
}
function usage() {
    echo "usage: sh $0               to install, if no params, install all"
    echo "options:"
    echo "  -h      help"
    echo "  -e      install dcgm exporter"
    echo "  -g      install gpu"
    echo "  -c      install cpu"
    echo "  -u      uninstall all"
}

function main() {
    exporter=0
    gpu=0
    cpu=0
    uninstall=0
    while getopts "heagcsu" opt; do
        case "$opt" in
        h)
            usage
            exit 0
            ;;
        e)  exporter=1
            ;;
        g)  gpu=1
            ;;
        c)  cpu=1
            ;;
        u)  uninstall=1
            ;;
        esac
    done

    if [ $uninstall -eq 1 ];then
        echo 'uninstall all'
        uninstall
        exit $?
    fi

    init
    if [ $# -eq 0 ];then
        echo 'install all components'
        dcgm_install
        gpu_install
        cpu_install
        exit 0
    fi

    if [ $exporter -eq 1 ];then
        echo 'install dcgm-exporter'
        dcgm_install
    fi
    if [ $gpu -eq 1 ];then
        echo 'install gpu'
        gpu_install
    fi
    if [ $cpu -eq 1 ];then
        echo 'install cpu'
        cpu_install
    fi
}

main $@
