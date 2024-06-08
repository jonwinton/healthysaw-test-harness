# healthysaw-test-harness

An example test harness for running [Chainsaw](https://github.com/kyverno/chainsaw) in [Kuberhealthy](https://github.com/kuberhealthy/kuberhealthy) 
for easier testing of Kubernetes clusters.

## Usage

This repo uses [Hermit](https://github.com/cashapp/hermit) for managing tools. Activate your Hermit environment _or_ ensure
you have the following tools installed:

- `helm`
- `k3d`
- `kubectl`

There is a [`justfile`](https://github.com/casey/just) for making some commands easy to run. You can install `just` or just
pull the commands from the `justfile`.

## Demo Steps

Run `just demo` (or run the commands in the order found under the `demo` command in the `justfile`).

Once the `k3d` cluster has come up and is ready, Kuberhealthy will begin launching checks in the `kuberhealthy` namespace. One of 
these checks is called `test-chainsaw` and it will run the `chainsaw` tool against the cluster. The tests are specifically
designed to fail, so you can see what a failing test looks like in Kuberhealthy.

## Next Steps

There are many things to improve with this, some ideas include:

- Add more demo examples
- Improved error messaging
- Replace the `chainsaw-runner.sh` script with a [Go binary using the Kuberhealthy packages](https://github.com/kuberhealthy/kuberhealthy/blob/master/docs/CHECK_CREATION.md) for better flow control