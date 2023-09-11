# Notes

First the clusters need to be provisioned, see `clusters` subfolder.

Execute the `deployments` terraform after the clusters are available.

The two cannot be provisioned at the same time since the kubernetes provider depends on a successful cluster deployment.
