# Cartographer Blueprints

This project provides a [Carvel package](https://carvel.dev/kapp-controller/docs/latest/packaging) with a set of reusable blueprints for [Cartographer](https://cartographer.sh), a Kubernetes-native framework to build paved paths to production. 

It includes blueprints to deal with several activities like source code watching, testing, building, scanning, configuring, delivering, and deploying. 

## Components

* cartographer-blueprints

## Description

The package provides Cartographer blueprints to design paths to production on Kubernetes.

### Source (Flux)

* `source-template`: it uses Flux to keep track of _application_ changes to a Git or OCI repository
and make the source available internally in the cluster.
* `delivery-source-template`: it uses Flux to keep track of _configuration_ changes to a Git or OCI
repository and make the source available internally in the cluster.

### Image (kpack)

* `kpack-template`: it uses kpack, Cloud Native Buildpacks, and Paketo to transform application
source code into a production-ready container image.

### Test (Tekton)

* `tekton-source-test-template`: it provides a template to test application source code with Tekton.
* `tekton-source-test-pipelinerun`: it runs an instance of a Tekton pipeline to test
the application source code.

### Scan (Grype)

* `grype-image-scan-task`: a Tekton task using Grype to scan container images.
* `grype-image-scan-taskrun`: it runs an instance of a Tekton task to scan
an application container image for security vulnerabilities.
* `grype-image-scan-template`: it provides a template to scan container images with Tekton.
* `grype-source-scan-task`: a Tekton task using Grype to scan application source code.
* `grype-source-scan-taskrun`: it runs an instance of a Tekton task to scan
the application source code for security vulnerabilities.
* `grype-source-scan-template`: it provides a template to scan application source code with Tekton.

### Config (Conventions)

* `config-template`: it uses Carvel `kapp` to package and configure the application manifests.
* `convention-template`: it applies config and best-practices to workloads at runtime by understanding the developer's intent, using Cartographer Conventions.

### Delivery (Cartographer)

* `deliverable-template`: it generates a Deliverable object used by Cartographer to trigger the deployment
phase of the path to production.

### Deploy (kapp)

* `app-deployment-template`: it runs an application packaged as a Carvel App on Manifest.

## Prerequisites

* Install the [`kctrl`](https://carvel.dev/kapp-controller/docs/latest/install/#installing-kapp-controller-cli-kctrl) CLI to manage Carvel packages in a convenient way.
* Ensure [kapp-controller](https://carvel.dev/kapp-controller) is deployed in your Kubernetes cluster. You can do that with Carvel
[`kapp`](https://carvel.dev/kapp/docs/latest/install) (recommended choice) or `kubectl`.

```shell
kapp deploy -a kapp-controller -y \
  -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/latest/download/release.yml
```

## Dependencies

Cartographer Blueprints requires the Cartographer package to be already installed in the cluster. You can install it from the [Kadras package repository](https://github.com/arktonix/kadras-packages).

## Installation

You can install the Cartographer Blueprints package directly or rely on the [Kadras package repository](https://github.com/arktonix/kadras-packages)
(recommended choice).

Follow the [instructions](https://github.com/arktonix/kadras-packages) to add the Kadras package repository to your Kubernetes cluster.

If you don't want to use the Kadras package repository, you can create the necessary `PackageMetadata` and
`Package` resources for the Cartographer Blueprints package directly.

```shell
kubectl create namespace carvel-packages
kapp deploy -a cartographer-blueprints-package -n carvel-packages -y \
    -f https://github.com/arktonix/cartographer-blueprints/releases/latest/download/metadata.yml \
    -f https://github.com/arktonix/cartographer-blueprints/releases/latest/download/package.yml
```

Either way, you can then install the Cartographer Blueprints package using [`kctrl`](https://carvel.dev/kapp-controller/docs/latest/install/#installing-kapp-controller-cli-kctrl).

```shell
kctrl package install -i cartographer-blueprints \
    -p cartographer-blueprints.packages.kadras.io \
    -v 0.1.0 \
    -n carvel-packages
```

You can retrieve the list of available versions with the following command.

```shell
kctrl package available list -p cartographer-blueprints.packages.kadras.io
```

You can check the list of installed packages and their status as follows.

```shell
kctrl package installed list -n carvel-packages
```

## Configuration

The Cartographer Blueprints package has the following configurable properties.

| Config | Default | Description |
|-------|-------------------|-------------|
| `excluded_blueprints` | `[]` | A list of blueprints and manifests to esclude from being applied. |

You can define your configuration in a `values.yml` file.

```yaml
excluded_blueprints:
  - "config-template"
```

Then, reference it from the `kctrl` command when installing or upgrading the package.

```shell
kctrl package install -i cartographer-blueprints \
    -p cartographer-blueprints.packages.kadras.io \
    -v 0.1.0 \
    -n carvel-packages \
    --values-file values.yml
```

## Documentation

For documentation specific to Cartographer, check out [cartographer.sh](https://cartographer.sh).

## References

This package is inspired by:
* the [examples](https://github.com/vmware-tanzu/cartographer/tree/main/examples) in the Cartographer project;
* the [Cartographer Catalog](https://github.com/vmware-tanzu/cartographer-catalog) package used in Tanzu Community Edition;
* the [set of blueprints](https://github.com/vrabbi/tap-oss/tree/main/packages/ootb-supply-chains) included in an example of Tanzu Application Platform OSS stack.

## Supply Chain Security

This project is compliant with level 2 of the [SLSA Framework](https://slsa.dev).

<img src="https://slsa.dev/images/SLSA-Badge-full-level2.svg" alt="The SLSA Level 2 badge" width=200>
