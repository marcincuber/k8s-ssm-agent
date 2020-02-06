# k8s-ssm-agent
SSM agent docker image to provide secure, access-controlled, and audited terminal sessions to EKS worker nodes

## Getting started

Deploy daemonset to your Kubernetes cluster:

```console

$ kubectl apply -f deploy/daemonset.yaml

# Accessing ec2 instance 
$ aws --region eu-west-1 ssm start-session --target i-123456asdmasdasdasd
```

## Rational

EKS optimized AMI doesn't include aws-ssm-agent. Since we are using Kubernetes, we are also deploying SSM agents Kubernetes way. This is an alternative way of installing aws-ssm-agent binary.

aws-ssm-agent with AWS SSM Sessions Manager allows you to opening audited interactive terminal sessions to nodes, without maintaining SSH infrastructure.

## Building

Image is built with latest versions of aws-ssm-agent, aws-iam-authenticator and kubectl.

```
# Build new version
$ make build_version
```

Each image is tagged based on kubectl version. In our case, we have following naming:
```
umotif/k8s-ssm-agent:1.17.2
umotif/k8s-ssm-agent:1.17.1
```

Images are tagged bace

## Troubleshooting

Start-session fails:

```
$ aws --region eu-west-1 ssm start-session --target i-123456asdmasdasdasd

An error occurred (TargetNotConnected) when calling the StartSession operation: i-123456asdmasdasdasd is not connected.

SessionManagerPlugin is not found. Please refer to SessionManager Documentation here: http://docs.aws.amazon.com/console/systems-manager/session-manager-plugin-not-found
```

Install the plugin according to the guidance

https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html