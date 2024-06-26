resource "azurerm_resource_group_template_deployment" "arm_template_prometheus_default_alerts" { 
name= var.new_template_name
resource_group_name =var.template_rg_name
deployment_mode  = var.template_deployment_mode
parameters_content = jsonencode({
"clusterName"={
      value="${var.ClusterName}"
    },
    "actionGroupResourceId"={
      value="/subscriptions/${var.subscriptionId}/resourceGroups/${var.template_rg_name}/providers/microsoft.insights/actionGroups/${var.ActionGroupName}"
    },
    "macResourceId"={
      value="/subscriptions/${var.subscriptionId}/resourceGroups/${var.template_rg_name}/providers/microsoft.monitor/accounts/${var.PrometheusName}"
    },
    "location"={
      value="${var.template_location}"
    }
    })
template_content = <<TEMPLATE
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "clusterName": {
            "type": "string",
            "metadata": {
                "description": "Cluster name"
            }
        },
        "actionGroupResourceId": {
            "type": "string",
            "metadata": {
                "description": "Action Group ResourceId"
            }
        },
        "macResourceId": {
            "type": "string",
            "metadata": {
                "description": "ResourceId of Monitoring Account (MAC) to associate to"
            }
        },
        "location": {
            "type": "string",
            "defaultValue": "[resourceGroup().location]"
        }
    },
    "variables": {
        "kubernetesAlertRuleGroup": "KubernetesAlert-DefaultAlerts",
        "kubernetesAlertRuleGroupName": "[concat(variables('kubernetesAlertRuleGroup'), parameters('clusterName'))]",
        "kubernetesAlertRuleGroupDescription": "Kubernetes Alert RuleGroup-DefaultAlerts",
        "version": " - 0.1"
    },
    "resources": [
        {
            "name": "[variables('kubernetesAlertRuleGroupName')]",
            "type": "Microsoft.AlertsManagement/prometheusRuleGroups",
            "apiVersion": "2021-07-22-preview",
            "location": "[parameters('location')]",
            "properties": {
                "description": "[concat(variables('kubernetesAlertRuleGroupDescription'), variables('version'))]",
                "scopes": [
                    "[parameters('macResourceId')]"
                ],
                "clusterName": "[parameters('clusterName')]",
                "interval": "PT1M",
                "rules": [
                    {
                        "alert": "NodeFilesystemSpaceFillingUp",
                        "expression": "avg by (namespace,cluster,job,device,instance,mountpoint)(node_filesystem_avail_bytes{job=\"node\",fstype!=\"\"}) / avg by (namespace,cluster,job,device,instance,mountpoint)(node_filesystem_size_bytes{job=\"node\",fstype!=\"\"}) * 100 < 40 and avg by (namespace,cluster,job,device,instance,mountpoint)(predict_linear(node_filesystem_avail_bytes{job=\"node\",fstype!=\"\"}[6h], 24*60*60)) < 0 and avg by (namespace,cluster,job,device,instance,mountpoint)(node_filesystem_readonly{job=\"node\",fstype!=\"\"}) == 0",
                        "for": "PT15M",
                        "annotations": {
                            "description": "An extrapolation algorithm predicts that disk space usage for node {{ $labels.instance }} on device {{ $labels.device }} in {{ $labels.cluster}} will run out of space within the upcoming 24 hours. For more information on this alert, please refer to this [link](https://github.com/prometheus-operator/runbooks/blob/main/content/runbooks/node/NodeFilesystemSpaceFillingUp.md)."
                        },
                        "labels": {
                          "severity": "warning"
                        },
                        "severity": 3,
                        "resolveConfiguration": {
                            "autoResolved": true,
                            "timeToResolve": "PT10M"
                        },
                        "actions": [
                            {
                                "actionGroupId": "[parameters('actionGroupResourceId')]"
                            }
                        ]
                    },
                    {
                        "alert": "NodeFilesystemSpaceUsageFull85Pct",
                        "expression": "1 - avg by (namespace,cluster,job,device,instance,mountpoint)(node_filesystem_avail_bytes{job=\"node\"}) / avg by (namespace,cluster,job,device,instance,mountpoint)(node_filesystem_size_bytes{job=\"node\"}) > .85",
                        "for": "PT15M",
                        "annotations": {
                            "description": "Disk space usage for node {{ $labels.instance }} on device {{ $labels.device }} in {{ $labels.cluster}} is greater than 85%. For more information on this alert, please refer to this [link](https://github.com/prometheus-operator/runbooks/blob/main/content/runbooks/node/NodeFilesystemAlmostOutOfSpace.md)."
                        },
                        "labels": {
                          "severity": "warning"
                        },
                        "severity": 3,
                        "resolveConfiguration": {
                            "autoResolved": true,
                            "timeToResolve": "PT10M"
                        },
                        "actions": [
                            {
                                "actionGroupId": "[parameters('actionGroupResourceId')]"
                            }
                        ]
                    },
                    {
                        "alert": "KubePodCrashLooping",
                        "expression": "max_over_time(kube_pod_container_status_waiting_reason{reason=\"CrashLoopBackOff\", job=\"kube-state-metrics\"}[5m]) >= 1",
                        "for": "PT15M",
                        "annotations": {
                            "description": "{{ $labels.namespace }}/{{ $labels.pod }} ({{ $labels.container }}) in {{ $labels.cluster}} is restarting {{ printf \"%.2f\" $value }} / second. For more information on this alert, please refer to this [link](https://github.com/prometheus-operator/runbooks/blob/main/content/runbooks/kubernetes/KubePodCrashLooping.md)."
                        },
                        "labels": {
                            "severity": "warning"
                        },
                        "severity": 3,
                        "resolveConfiguration": {
                            "autoResolved": true,
                            "timeToResolve": "PT10M"
                        },
                        "actions": [
                            {
                                "actionGroupId": "[parameters('actionGroupResourceId')]"
                            }
                        ]
                    },
                    {
                        "alert": "KubePodNotReady",
                        "expression": "sum by (namespace, pod, cluster) (  max by(namespace, pod, cluster) (    kube_pod_status_phase{job=\"kube-state-metrics\", phase=~\"Pending|Unknown\"}  ) * on(namespace, pod, cluster) group_left(owner_kind) topk by(namespace, pod, cluster) (    1, max by(namespace, pod, owner_kind, cluster) (kube_pod_owner{owner_kind!=\"Job\"})  )) > 0",
                        "for": "PT15M",
                        "annotations": {
                            "description": "{{ $labels.namespace }}/{{ $labels.pod }} in {{ $labels.cluster}} is not ready. For more information on this alert, please refer to this [link](https://github.com/prometheus-operator/runbooks/blob/main/content/runbooks/kubernetes/KubePodNotReady.md)."
                        },
                        "labels": {
                            "severity": "warning"
                        },
                        "severity": 3,
                        "resolveConfiguration": {
                            "autoResolved": true,
                            "timeToResolve": "PT10M"
                        },
                        "actions": [
                            {
                                "actionGroupId": "[parameters('actionGroupResourceId')]"
                            }
                        ]
                    },
                    {
                        "alert": "KubeDeploymentReplicasMismatch",
                        "expression": "(  kube_deployment_spec_replicas{job=\"kube-state-metrics\"}    >  kube_deployment_status_replicas_available{job=\"kube-state-metrics\"}) and (  changes(kube_deployment_status_replicas_updated{job=\"kube-state-metrics\"}[10m])    ==  0)",
                        "for": "PT15M",
                        "annotations": {
                            "description": "Deployment {{ $labels.namespace }}/{{ $labels.deployment }} in {{ $labels.cluster}} replica mismatch. For more information on this alert, please refer to this [link](https://github.com/prometheus-operator/runbooks/blob/main/content/runbooks/kubernetes/KubeDeploymentReplicasMismatch.md)."
                        },
                        "labels": {
                            "severity": "warning"
                        },
                        "severity": 3,
                        "resolveConfiguration": {
                            "autoResolved": true,
                            "timeToResolve": "PT10M"
                        },
                        "actions": [
                            {
                                "actionGroupId": "[parameters('actionGroupResourceId')]"
                            }
                        ]
                    },
                    {
                        "alert": "KubeStatefulSetReplicasMismatch",
                        "expression": "(  kube_statefulset_status_replicas_ready{job=\"kube-state-metrics\"}    !=  kube_statefulset_status_replicas{job=\"kube-state-metrics\"}) and (  changes(kube_statefulset_status_replicas_updated{job=\"kube-state-metrics\"}[10m])    ==  0)",
                        "for": "PT15M",
                        "annotations": {
                            "description": "StatefulSet {{ $labels.namespace }}/{{ $labels.statefulset }} in {{ $labels.cluster}} replica mismatch. For more information on this alert, please refer to this [link](https://github.com/prometheus-operator/runbooks/blob/main/content/runbooks/kubernetes/KubeStatefulSetReplicasMismatch.md)."
                        },
                        "labels": {
                            "severity": "warning"
                        },
                        "severity": 3,
                        "resolveConfiguration": {
                            "autoResolved": true,
                            "timeToResolve": "PT10M"
                        },
                        "actions": [
                            {
                                "actionGroupId": "[parameters('actionGroupResourceId')]"
                            }
                        ]
                    },
                    {
                        "alert": "KubeJobNotCompleted",
                        "expression": "time() - max by(namespace, job_name, cluster) (kube_job_status_start_time{job=\"kube-state-metrics\"}  and kube_job_status_active{job=\"kube-state-metrics\"} > 0) > 43200",
                        "annotations": {
                            "description": "Job {{ $labels.namespace }}/{{ $labels.job_name }} in {{ $labels.cluster}} is taking more than 12 hours to complete. For more information on this alert, please refer to this [link](https://github.com/prometheus-operator/runbooks/blob/main/content/runbooks/kubernetes/KubeJobCompletion.md)."
                        },
                        "labels": {
                            "severity": "warning"
                        },
                        "severity": 3,
                        "resolveConfiguration": {
                            "autoResolved": true,
                            "timeToResolve": "PT10M"
                        },
                        "actions": [
                            {
                                "actionGroupId": "[parameters('actionGroupResourceId')]"
                            }
                        ]
                    },
                    {
                        "alert": "KubeJobFailed",
                        "expression": "kube_job_failed{job=\"kube-state-metrics\"}  > 0",
                        "for": "PT15M",
                        "annotations": {
                            "description": "Job {{ $labels.namespace }}/{{ $labels.job_name }} in {{ $labels.cluster}} failed to complete. For more information on this alert, please refer to this [link](https://github.com/prometheus-operator/runbooks/blob/main/content/runbooks/kubernetes/KubeJobFailed.md)."
                        },
                        "labels": {
                            "severity": "warning"
                        },
                        "severity": 3,
                        "resolveConfiguration": {
                            "autoResolved": true,
                            "timeToResolve": "PT10M"
                        },
                        "actions": [
                            {
                                "actionGroupId": "[parameters('actionGroupResourceId')]"
                            }
                        ]
                    },
                    {
                        "alert": "KubeHpaReplicasMismatch",
                        "expression": "(kube_horizontalpodautoscaler_status_desired_replicas{job=\"kube-state-metrics\"}  !=kube_horizontalpodautoscaler_status_current_replicas{job=\"kube-state-metrics\"})  and(kube_horizontalpodautoscaler_status_current_replicas{job=\"kube-state-metrics\"}  >kube_horizontalpodautoscaler_spec_min_replicas{job=\"kube-state-metrics\"})  and(kube_horizontalpodautoscaler_status_current_replicas{job=\"kube-state-metrics\"}  <kube_horizontalpodautoscaler_spec_max_replicas{job=\"kube-state-metrics\"})  and changes(kube_horizontalpodautoscaler_status_current_replicas{job=\"kube-state-metrics\"}[15m]) == 0",
                        "for": "PT15M",
                        "annotations": {
                            "description": "Horizontal Pod Autoscaler in {{ $labels.cluster}} has not matched the desired number of replicas for longer than 15 minutes. For more information on this alert, please refer to this [link](https://github.com/prometheus-operator/runbooks/blob/main/content/runbooks/kubernetes/KubeHpaReplicasMismatch.md)."
                        },
                        "labels": {
                            "severity": "warning"
                        },
                        "severity": 3,
                        "resolveConfiguration": {
                            "autoResolved": true,
                            "timeToResolve": "PT10M"
                        },
                        "actions": [
                            {
                                "actionGroupId": "[parameters('actionGroupResourceId')]"
                            }
                        ]
                    },
                    {
                        "alert": "KubeHpaMaxedOut",
                        "expression": "kube_horizontalpodautoscaler_status_current_replicas{job=\"kube-state-metrics\"}  ==kube_horizontalpodautoscaler_spec_max_replicas{job=\"kube-state-metrics\"}",
                        "for": "PT15M",
                        "annotations": {
                            "description": "Horizontal Pod Autoscaler in {{ $labels.cluster}} has been running at max replicas for longer than 15 minutes. For more information on this alert, please refer to this [link](https://github.com/prometheus-operator/runbooks/blob/main/content/runbooks/kubernetes/KubeHpaMaxedOut.md)."
                        },
                        "labels": {
                            "severity": "warning"
                        },
                        "severity": 3,
                        "resolveConfiguration": {
                            "autoResolved": true,
                            "timeToResolve": "PT10M"
                        },
                        "actions": [
                            {
                                "actionGroupId": "[parameters('actionGroupResourceId')]"
                            }
                        ]
                    },
                    {
                        "alert": "KubeCPUQuotaOvercommit",
                        "expression": "sum(min without(resource) (kube_resourcequota{job=\"kube-state-metrics\", type=\"hard\", resource=~\"(cpu|requests.cpu)\"}))  /sum(kube_node_status_allocatable{resource=\"cpu\", job=\"kube-state-metrics\"})  > 1.5",
                        "for": "PT5M",
                        "annotations": {
                            "description": "Cluster {{ $labels.cluster}} has overcommitted CPU resource requests for Namespaces. For more information on this alert, please refer to this [link](https://github.com/prometheus-operator/runbooks/blob/main/content/runbooks/kubernetes/KubeCPUQuotaOvercommit.md)."
                        },
                        "labels": {
                            "severity": "warning"
                        },
                        "severity": 3,
                        "resolveConfiguration": {
                            "autoResolved": true,
                            "timeToResolve": "PT10M"
                        },
                        "actions": [
                            {
                                "actionGroupId": "[parameters('actionGroupResourceId')]"
                            }
                        ]
                    },
                    {
                        "alert": "KubeMemoryQuotaOvercommit",
                        "expression": "sum(min without(resource) (kube_resourcequota{job=\"kube-state-metrics\", type=\"hard\", resource=~\"(memory|requests.memory)\"}))  /sum(kube_node_status_allocatable{resource=\"memory\", job=\"kube-state-metrics\"})  > 1.5",
                        "for": "PT5M",
                        "annotations": {
                            "description": "Cluster {{ $labels.cluster}} has overcommitted memory resource requests for Namespaces. For more information on this alert, please refer to this [link](https://github.com/prometheus-operator/runbooks/blob/main/content/runbooks/kubernetes/KubeMemoryQuotaOvercommit.md)."
                        },
                        "labels": {
                            "severity": "warning"
                        },
                        "severity": 3,
                        "resolveConfiguration": {
                            "autoResolved": true,
                            "timeToResolve": "PT10M"
                        },
                        "actions": [
                            {
                                "actionGroupId": "[parameters('actionGroupResourceId')]"
                            }
                        ]
                    },
                    {
                        "alert": "KubeQuotaAlmostFull",
                        "expression": "kube_resourcequota{job=\"kube-state-metrics\", type=\"used\"}  / ignoring(instance, job, type)(kube_resourcequota{job=\"kube-state-metrics\", type=\"hard\"} > 0)  > 0.9 < 1",
                        "for": "PT15M",
                        "annotations": {
                            "description": "{{ $value | humanizePercentage }} usage of {{ $labels.resource }} in namespace {{ $labels.namespace }} in {{ $labels.cluster}}. For more information on this alert, please refer to this [link](https://github.com/prometheus-operator/runbooks/blob/main/content/runbooks/kubernetes/KubeQuotaAlmostFull.md)."
                        },
                        "labels": {
                            "severity": "info"
                        },
                        "severity": 3,
                        "resolveConfiguration": {
                            "autoResolved": true,
                            "timeToResolve": "PT10M"
                        },
                        "actions": [
                            {
                                "actionGroupId": "[parameters('actionGroupResourceId')]"
                            }
                        ]
                    },
                    {
                        "alert": "KubeVersionMismatch",
                        "expression": "count by (cluster) (count by (git_version, cluster) (label_replace(kubernetes_build_info{job!~\"kube-dns|coredns\"},\"git_version\",\"$1\",\"git_version\",\"(v[0-9]*.[0-9]*).*\"))) > 1",
                        "for": "PT15M",
                        "annotations": {
                            "description": "There are {{ $value }} different versions of Kubernetes components running in {{ $labels.cluster}}. For more information on this alert, please refer to this [link](https://github.com/prometheus-operator/runbooks/blob/main/content/runbooks/kubernetes/KubeVersionMismatch.md)."
                        },
                        "labels": {
                            "severity": "warning"
                        },
                        "severity": 3,
                        "resolveConfiguration": {
                            "autoResolved": true,
                            "timeToResolve": "PT10M"
                        },
                        "actions": [
                            {
                                "actionGroupId": "[parameters('actionGroupResourceId')]"
                            }
                        ]
                    },
                    {
                        "alert": "KubeNodeNotReady",
                        "expression": "kube_node_status_condition{job=\"kube-state-metrics\",condition=\"Ready\",status=\"true\"} == 0",
                        "for": "PT15M",
                        "annotations": {
                            "description": "{{ $labels.node }} in {{ $labels.cluster}} has been unready for more than 15 minutes. For more information on this alert, please refer to this [link](https://github.com/prometheus-operator/runbooks/blob/main/content/runbooks/kubernetes/KubeNodeNotReady.md)."
                        },
                        "labels": {
                            "severity": "warning"
                        },
                        "severity": 3,
                        "resolveConfiguration": {
                            "autoResolved": true,
                            "timeToResolve": "PT10M"
                        },
                        "actions": [
                            {
                                "actionGroupId": "[parameters('actionGroupResourceId')]"
                            }
                        ]
                    },
                    {
                        "alert": "KubeNodeUnreachable",
                        "expression": "(kube_node_spec_taint{job=\"kube-state-metrics\",key=\"node.kubernetes.io/unreachable\",effect=\"NoSchedule\"} unless ignoring(key,value) kube_node_spec_taint{job=\"kube-state-metrics\",key=~\"ToBeDeletedByClusterAutoscaler|cloud.google.com/impending-node-termination|aws-node-termination-handler/spot-itn\"}) == 1",
                        "for": "PT15M",
                        "annotations": {
                            "description": "{{ $labels.node }} in {{ $labels.cluster}} is unreachable and some workloads may be rescheduled. For more information on this alert, please refer to this [link](https://github.com/prometheus-operator/runbooks/blob/main/content/runbooks/kubernetes/KubeNodeUnreachable.md)."
                        },
                        "labels": {
                            "severity": "warning"
                        },
                        "severity": 3,
                        "resolveConfiguration": {
                            "autoResolved": true,
                            "timeToResolve": "PT10M"
                        },
                        "actions": [
                            {
                                "actionGroupId": "[parameters('actionGroupResourceId')]"
                            }
                        ]
                    },
                    {
                        "alert": "KubeletTooManyPods",
                        "expression": "count by(cluster, node) (  (kube_pod_status_phase{job=\"kube-state-metrics\",phase=\"Running\"} == 1) * on(instance,pod,namespace,cluster) group_left(node) topk by(instance,pod,namespace,cluster) (1, kube_pod_info{job=\"kube-state-metrics\"}))/max by(cluster, node) (  kube_node_status_capacity{job=\"kube-state-metrics\",resource=\"pods\"} != 1) > 0.95",
                        "for": "PT15M",
                        "annotations": {
                            "description": "Kubelet '{{ $labels.node }}' in {{ $labels.cluster}} is running at {{ $value | humanizePercentage }} of its Pod capacity. For more information on this alert, please refer to this [link](https://github.com/prometheus-operator/runbooks/blob/main/content/runbooks/kubernetes/KubeletTooManyPods.md)."
                        },
                        "labels": {
                            "severity": "info"
                        },
                        "severity": 3,
                        "resolveConfiguration": {
                            "autoResolved": true,
                            "timeToResolve": "PT10M"
                        },
                        "actions": [
                            {
                                "actionGroupId": "[parameters('actionGroupResourceId')]"
                            }
                        ]
                    },
                    {
                        "alert": "KubeNodeReadinessFlapping",
                        "expression": "sum(changes(kube_node_status_condition{status=\"true\",condition=\"Ready\"}[15m])) by (cluster, node) > 2",
                        "for": "PT15M",
                        "annotations": {
                            "description": "The readiness status of node {{ $labels.node }} in {{ $labels.cluster}} has changed more than 2 times in the last 15 minutes. For more information on this alert, please refer to this [link](https://github.com/prometheus-operator/runbooks/blob/main/content/runbooks/kubernetes/KubeNodeReadinessFlapping.md)."
                        },
                        "labels": {
                            "severity": "warning"
                        },
                        "severity": 3,
                        "resolveConfiguration": {
                            "autoResolved": true,
                            "timeToResolve": "PT10M"
                        },
                        "actions": [
                            {
                                "actionGroupId": "[parameters('actionGroupResourceId')]"
                            }
                        ]
                    }
                ]


            }
        }
    ]
}


TEMPLATE
}