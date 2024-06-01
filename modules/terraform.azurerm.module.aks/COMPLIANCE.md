# Status

IMG ID | Description | Status | Comment |
------ | ----------- | ------ | ------- |
MSA-AKS-01.02  | Container monitoring must be enabled in the portal   | ✅
MSA-AKS-01.03  | Container images must be pulled from trusted sources / registries    | ☝
MSA-AKS-01.04  | Container registries requirements must be followed    | ☝
MSA-AKS-01.05  | Set quota limits for your storage of a container      | ☝
MSA-AKS-01.06  | Worker nodes must be restarted after security patches are applied    | ☝ | cannot be properly done with terraform because unstable helm provider for terraform. kured has to be installed as a helm chart separately, see https://github.com/helm/charts/tree/master/stable/kured
MSA-AKS-01.07  | Storage account requirements must be followed     | ☝
MSA-AKS-01.09  | Containers must be deployed with unprivileged rights    | ☝
MSA-AKS-01.10  | Consider Kubernetes Security Best Practices     | ✅
MSA-AKS-01.12  | Managed disks must be used     | ✅
MSA-AKS-01.13  | Activate Policy Add-on for Kubernetes    | ✅ 

Legend:

✅ Implemented in this chart

❌ Not implemented yet

☝ Out of scope / cannot be (fully) solved with this template
