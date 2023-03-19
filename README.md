# Cartographer Blueprints

![Test Workflow](https://github.com/kadras-io/cartographer-blueprints/actions/workflows/test.yml/badge.svg)
![Release Workflow](https://github.com/kadras-io/cartographer-blueprints/actions/workflows/release.yml/badge.svg)
[![The SLSA Level 3 badge](https://slsa.dev/images/gh-badge-level3.svg)](https://slsa.dev/spec/v0.1/levels)
[![The Apache 2.0 license badge](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Follow us on Twitter](https://img.shields.io/static/v1?label=Twitter&message=Follow&color=1DA1F2)](https://twitter.com/kadrasIO)

A Carvel package providing a set of reusable blueprints to build Kubernetes-native paved paths to production using [Cartographer](https://cartographer.sh).

It includes blueprints to deal with several activities like source code watching, testing, building, scanning, configuring, delivering, and deploying.

## 🚀&nbsp; Getting Started

### Prerequisites

* Kubernetes 1.24+
* Carvel [`kctrl`](https://carvel.dev/kapp-controller/docs/latest/install/#installing-kapp-controller-cli-kctrl) CLI.
* Carvel [kapp-controller](https://carvel.dev/kapp-controller) deployed in your Kubernetes cluster. You can install it with Carvel [`kapp`](https://carvel.dev/kapp/docs/latest/install) (recommended choice) or `kubectl`.

  ```shell
  kapp deploy -a kapp-controller -y \
    -f https://github.com/carvel-dev/kapp-controller/releases/latest/download/release.yml
  ```

### Dependencies

Cartographer Blueprints requires the [Cartographer](https://github.com/vmware-tanzu/package-for-cartographer) package. You can install it from the [Kadras package repository](https://github.com/kadras-io/kadras-packages).

### Installation

Add the Kadras [package repository](https://github.com/kadras-io/kadras-packages) to your Kubernetes cluster:

  ```shell
  kubectl create namespace kadras-packages
  kctrl package repository add -r kadras-packages \
    --url ghcr.io/kadras-io/kadras-packages \
    -n kadras-packages
  ```

<details><summary>Installation without package repository</summary>
The recommended way of installing the Cartographer Blueprints package is via the Kadras <a href="https://github.com/kadras-io/kadras-packages">package repository</a>. If you prefer not using the repository, you can add the package definition directly using <a href="https://carvel.dev/kapp/docs/latest/install"><code>kapp</code></a> or <code>kubectl</code>.

  ```shell
  kubectl create namespace kadras-packages
  kapp deploy -a cartographer-blueprints-package -n kadras-packages -y \
    -f https://github.com/kadras-io/cartographer-blueprints/releases/latest/download/metadata.yml \
    -f https://github.com/kadras-io/cartographer-blueprints/releases/latest/download/package.yml
  ```
</details>

Install the Cartographer Blueprints package:

  ```shell
  kctrl package install -i cartographer-blueprints \
    -p cartographer-blueprints.packages.kadras.io \
    -v ${VERSION} \
    -n kadras-packages
  ```

> **Note**
> You can find the `${VERSION}` value by retrieving the list of package versions available in the Kadras package repository installed on your cluster.
> 
>   ```shell
>   kctrl package available list -p cartographer-blueprints.packages.kadras.io -n kadras-packages
>   ```

Verify the installed packages and their status:

  ```shell
  kctrl package installed list -n kadras-packages
  ```

## 📙&nbsp; Documentation

Documentation, tutorials and examples for this package are available in the [docs](docs) folder.
For documentation specific to Cartographer, check out [cartographer.sh](https://cartographer.sh).

The package provides several blueprints to design paths to production on Kubernetes using Cartographer.

### Source (Flux)

* `supplychain-source-template`: it uses Flux to keep track of _application_ changes to a Git or OCI repository and make the source available internally in the cluster.
* `delivery-source-template`: it uses Flux to keep track of _configuration_ changes to a Git or OCI repository and make the source available internally in the cluster.

### Image (kpack)

* `kpack-template`: it uses kpack, Cloud Native Buildpacks, and Paketo to transform application source code into a production-ready container image.

### Test (Tekton)

* `tekton-test-source-template`: it runs an instance of a Tekton pipeline to test the application source code.

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

* `app-local-deployment-template`: it runs an application packaged as a Carvel `App` as part of a local workflow.
* `app-remote-deployment-template`: it runs an application packaged as a Carvel `App` as part of a remote workflow.

## 🎯&nbsp; Configuration

The Cartographer Blueprints package can be customized via a `values.yml` file.

  ```yaml
  excluded_blueprints:
    - "config-template"
  ```

Reference the `values.yml` file from the `kctrl` command when installing or upgrading the package.

  ```shell
  kctrl package install -i cartographer-blueprints \
    -p cartographer-blueprints.packages.kadras.io \
    -v ${VERSION} \
    -n kadras-packages \
    --values-file values.yml
  ```

### Values

The Cartographer Blueprints package has the following configurable properties.

<details><summary>Configurable properties</summary>

| Config | Default | Description |
|-------|-------------------|-------------|
| `excluded_blueprints` | `[]` | A list of blueprints and manifests to esclude from being created in the cluster. |

</details>

## 🛡️&nbsp; Security

The security process for reporting vulnerabilities is described in [SECURITY.md](SECURITY.md).

## 🖊️&nbsp; License

This project is licensed under the **Apache License 2.0**. See [LICENSE](LICENSE) for more information.

## 🙏&nbsp; Acknowledgments

This package is inspired by:

* the [examples](https://github.com/vmware-tanzu/cartographer/tree/main/examples) in the Cartographer project;
* the original cartographer-catalog package used in [Tanzu Community Edition](https://github.com/vmware-tanzu/community-edition) before its retirement;
* the [set of blueprints](https://github.com/vrabbi/tap-oss/tree/main/packages/ootb-supply-chains) included in an example of Tanzu Application Platform OSS stack.
* the out-of-the-box blueprints provided by [Tanzu Application Platform](https://tanzu.vmware.com/application-platform).
