# Cartographer Blueprints

<a href="https://slsa.dev/spec/v0.1/levels"><img src="https://slsa.dev/images/gh-badge-level3.svg" alt="The SLSA Level 3 badge"></a>

This project provides a [Carvel package](https://carvel.dev/kapp-controller/docs/latest/packaging) with a set of reusable blueprints for [Cartographer](https://cartographer.sh), a Kubernetes-native framework to build paved paths to production.

It includes blueprints to deal with several activities like source code watching, testing, building, scanning, configuring, delivering, and deploying.

## Description

The package provides Cartographer blueprints to design paths to production on Kubernetes.

### Source (Flux)

* `supplychain-source-template`: it uses Flux to keep track of _application_ changes to a Git or OCI repository and make the source available internally in the cluster.
* `delivery-source-template`: it uses Flux to keep track of _configuration_ changes to a Git or OCI repository and make the source available internally in the cluster.

### Image (kpack)

* `kpack-template`: it uses kpack, Cloud Native Buildpacks, and Paketo to transform application
source code into a production-ready container image.

### Test (Tekton)

* `tekton-test-source-template`: it runs an instance of a Tekton pipeline to test
the application source code.

### Scan (Grype and Trivy)

* `tekton-scan-image-template`: it provides a template to scan container images with Tekton and the configured vulnerability scanner.
* `tekton-scan-source-template`: it provides a template to scan application source code with Tekton and the configured vulnerability scanner.

* `grype-image-scanner-tekton-task`: a Tekton task using Grype to scan container images.
* `grype-source-scanner-tekton-task`: a Tekton task using Grype to scan application source code.

* `trivy-image-scanner-tekton-task`: a Tekton task using Trivy to scan container images.
* `trivy-source-scanner-tekton-task`: a Tekton task using Trivy to scan application source code.

### Conventions (Cartographer)

* `convention-template`: it applies configuration and best-practices to workloads at runtime by understanding the developer's intent, using Cartographer Conventions.

### Configuration (Carvel)

* `knative-config-template`: it uses Carvel `kapp` to package and configure the application as a Knative Service.

### Promotion (Tekton)

* `tekton-config-writer-template`: it provides a template to publish deployment configuration to a container registry or Git repository for promotion to a specific environment.
* `tekton-config-writer-and-pull-request-template`: it provides a template to publish deployment configuration to a Git repository for promotion to a specific environment via a pull request.

* `git-writer-tekton-task`: a Tekton task pushing deployment configuration to a Git repository.
* `image-writer-tekton-task`: a Tekton task pushing deployment configuration to a container registry (OCI bundle).
* `commit-and-pr-tekton-task`: a Tekton task pushing deployment configuration to a Git repository and opening a pull request for merging the changes to the main branch.

### Delivery (Cartographer)

* `deliverable-template`: it generates a Deliverable object used by Cartographer to trigger the deployment phase of the path to production.

### Deploy (Carvel)

* `app-deployment-template`: it runs an application packaged as a Carvel `App`.

## Prerequisites

* Kubernetes 1.24+
* Carvel [`kctrl`](https://carvel.dev/kapp-controller/docs/latest/install/#installing-kapp-controller-cli-kctrl) CLI.
* Carvel [kapp-controller](https://carvel.dev/kapp-controller) deployed in your Kubernetes cluster. You can install it with Carvel [`kapp`](https://carvel.dev/kapp/docs/latest/install) (recommended choice) or `kubectl`.

  ```shell
  kapp deploy -a kapp-controller -y \
    -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/latest/download/release.yml
  ```

## Dependencies

Cartographer Blueprints requires the Cartographer package to be already installed in the cluster. You can install it from the [Kadras package repository](https://github.com/arktonix/kadras-packages).

## Installation

First, add the [Kadras package repository](https://github.com/arktonix/kadras-packages) to your Kubernetes cluster.

  ```shell
  kubectl create namespace kadras-packages
  kctrl package repository add -r kadras-repo \
    --url ghcr.io/arktonix/kadras-packages \
    -n kadras-packages
  ```

Then, install the Cartographer Blueprints package.

  ```shell
  kctrl package install -i cartographer-blueprints \
    -p cartographer-blueprints.packages.kadras.io \
    -v 0.3.0 \
    -n kadras-packages
  ```

### Verification

You can verify the list of installed Carvel packages and their status.

  ```shell
  kctrl package installed list -n kadras-packages
  ```

### Version

You can get the list of Cartographer Blueprints versions available in the Kadras package repository.

  ```shell
  kctrl package available list -p cartographer-blueprints.packages.kadras.io -n kadras-packages
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
    -v 0.3.0 \
    -n kadras-packages \
    --values-file values.yml
  ```

## Upgrading

You can upgrade an existing package to a newer version using `kctrl`.

  ```shell
  kctrl package installed update -i cartographer-blueprints \
    -v <new-version> \
    -n kadras-packages
  ```

You can also update an existing package with a newer `values.yml` file.

  ```shell
  kctrl package installed update -i cartographer-blueprints \
    -n kadras-packages \
    --values-file values.yml
  ```

## Other

The recommended way of installing the Cartographer Blueprints package is via the [Kadras package repository](https://github.com/arktonix/kadras-packages). If you prefer not using the repository, you can install the package by creating the necessary Carvel `PackageMetadata` and `Package` resources directly using [`kapp`](https://carvel.dev/kapp/docs/latest/install) or `kubectl`.

  ```shell
  kubectl create namespace kadras-packages
  kapp deploy -a cartographer-blueprints-package -n kadras-packages -y \
    -f https://github.com/arktonix/cartographer-blueprints/releases/latest/download/metadata.yml \
    -f https://github.com/arktonix/cartographer-blueprints/releases/latest/download/package.yml
  ```

## Support and Documentation

For support and documentation specific to Cartographer, check out [cartographer.sh](https://cartographer.sh).

## References

This package is inspired by:

* the [examples](https://github.com/vmware-tanzu/cartographer/tree/main/examples) in the Cartographer project;
* the original cartographer-catalog package used in [Tanzu Community Edition](https://github.com/vmware-tanzu/community-edition) before its retirement;
* the [set of blueprints](https://github.com/vrabbi/tap-oss/tree/main/packages/ootb-supply-chains) included in an example of Tanzu Application Platform OSS stack.

## Supply Chain Security

This project is compliant with level 3 of the [SLSA Framework](https://slsa.dev).

<img src="https://slsa.dev/images/SLSA-Badge-full-level3.svg" alt="The SLSA Level 3 badge" width=200>
