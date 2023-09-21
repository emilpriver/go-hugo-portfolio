---
title: "Emulating Aws Services Locally With Localstack Sqs and Sns"
date: 2023-06-01T11:28:41+02:00
draft: false
summary: "Learn how to emulate AWS services like SNS, SQS, and S3 on your local machine using Localstack. This guide walks you through setting up Localstack and creating queues using AWS CLI. You'll also learn how to set up SQS and SNS client with GO, and get tips on using custom endpoints. Test your code locally against AWS services without worrying about AWS costs. Check out this guide for developers."
draft: false
images:
  - /og-images/localstack.png
tags: ["Localstack", "Tools", "Local development"]
keywords: ["AWS", "Localstack", "SQS", "SNS", "emulation", "development", "testing ", "AWS CLI ", "GO", "custom endpoints"," guide for developers"]
series:
  - tools
toc: true
---
Hey there!

At work recently, I ran into a bit of a challenge. I had to create an application using SQS and SNS to receive and send events, but I couldn't use any cloud-based SQS queue. On top of that, I wanted to make sure that the setup was easy to work with so that any new team member could jump right in without any trouble.

After doing some research, I stumbled upon a solution that I thought could be helpful to share.

## Localstack

Localstack is a fantastic open-source tool that lets you emulate most of AWS services like SNS, SQS, and S3 on your local machine. This is a great way to test your code without worrying about AWS costs.

The free plan offers core features like the ability to quickly spin up a mock environment. However, if you're looking for more advanced features, Localstack's pro plan has you covered. With the pro plan, you get a working Web UI that lets you easily monitor your mock environment. Unfortunately, this post's example doesn't showcase that feature as I'm using the free tier for development.

Overall, we highly recommend Localstack to anyone who wants to test their code locally against AWS services. Check out their website at https://localstack.cloud/.

## Local setup

My solution for this was to spin up Localstack using Docker with docker-compose:

```docker
version: "3.3"
services:
  localstack:
    image: localstack/localstack
    environment:
      - SERVICES=sns,sqs
      - DEBUG=1
      - PORT_WEB_UI=5000
      - HOSTNAME=localstack
      - EDGE_PORT=4566
    ports:
      - '4566-4597:4566-4597'
      - "8000:5000"

```

This starts a new container that includes Localstack and opens all required ports that I need. It also tells Localstack where to start my web UI (unfortunately, I don’t get a web UI due to using the free version) and which services I want to use. If I wanted to add S3 as a service, I would simply add S3 to `- SERVICES=sns,sqs` so it would be `- SERVICES=sns,sqs,s3`.

The next step was to create my queues. There are different approaches to this, but mine was to use the AWS CLI and create all the services I need using the CLI:

```docker
awscli:
    image: garland/aws-cli-docker
    container_name: awscli
    depends_on:
      - localstack
    environment:
      - AWS_DEFAULT_REGION=eu-central-1
      - AWS_ACCESS_KEY_ID=xxx
      - AWS_SECRET_ACCESS_KEY=xxx
    command:
      - /bin/sh
      - -c
      - |
          sleep 5
          aws configure set aws_access_key_id "dummy" --profile test-profile
          aws configure set aws_secret_access_key "dummy" --profile test-profile
          aws configure set region "eu-central-1" --profile test-profile
          aws configure set output "table" --profile test-profile
          aws --endpoint-url=http://localstack:4566 sns create-topic --name dummy-topic --region eu-central-1 --profile test-profile --output table | cat
          aws --endpoint-url=http://localstack:4566 sqs create-queue --queue-name dummy-queue --profile test-profile --region eu-central-1 --output table | cat
          aws --endpoint-url=http://localstack:4566 sns subscribe --topic-arn arn:aws:sns:eu-central-1:000000000000:dummy-topic --profile test-profile --region eu-central-1 --protocol sqs --notification-endpoint arn:aws:sqs:eu-central-1:000000000000:dummy-queue --output table | cat

```

In this example, we create a new configuration with some dummy data:

```docker
 aws configure set aws_access_key_id "dummy" --profile test-profile
 aws configure set aws_secret_access_key "dummy" --profile test-profile
 aws configure set region "eu-central-1" --profile test-profile
 aws configure set output "table" --profile test-profile

```

Then, we create the SNS topic:

```docker
aws --endpoint-url=http://localstack:4566 sns create-topic --name dummy-topic --region eu-central-1 --profile test-profile --output table | cat

```

This outputs:

```bash
awscli                     | -------------------------------------------------------------------
awscli                     | |                           CreateTopic                           |
awscli                     | +----------+------------------------------------------------------+
awscli                     | |  TopicArn|  arn:aws:sns:eu-central-1:000000000000:dummy-topic   |
awscli                     | +----------+------------------------------------------------------
```

Next, I create my SQS queue:

```docker
aws --endpoint-url=http://localstack:4566 sqs create-queue --queue-name dummy-queue --profile test-profile --region eu-central-1 --output table | cat
```

This outputs:

```bash
awscli                     | -----------------------------------------------------------------
awscli                     | |                          CreateQueue                          |
awscli                     | +----------+----------------------------------------------------+
awscli                     | |  QueueUrl|  <http://localstack:4566/000000000000/dummy-queue>   |
awscli                     | +----------+----------------------------------------------------+

```

To connect these two services to work together, I later run the subscribe command:

```docker
aws --endpoint-url=http://localstack:4566 sns subscribe --topic-arn arn:aws:sns:eu-central-1:000000000000:dummy-topic --profile test-profile --region eu-central-1 --protocol sqs --notification-endpoint arn:aws:sqs:eu-central-1:000000000000:dummy-queue --output table | cat

```

This outputs:

```bash
awscli                     | ---------------------------------------------------------------------------------------------------------------
awscli                     | |                                                  Subscribe                                                  |
awscli                     | +-----------------+-------------------------------------------------------------------------------------------+
awscli                     | |  SubscriptionArn|  arn:aws:sns:eu-central-1:000000000000:dummy-topic:3858d0d7-8fad-45b0-bf0a-63c5ac5f3618   |
awscli                     | +-----------------+-------------------------------------------------------------------------------------------+

```

## Setting up SQS & SNS Client with GO

Hey there! When we tell the AWS SDK that our queue is at localhost, it doesn't automatically know which endpoint to use. By default, it will make calls to AWS cloud directly if we don't specify the endpoint. But don't worry, we can easily fix this by using an EndpointResolver:

```go
endpointResolver := func(service, region string, optFns ...func(*endpoints.Options)) (endpoints.ResolvedEndpoint, error) {
		if cfg.AWSEndpoint != "" {
			return endpoints.ResolvedEndpoint{
				URL:           cfg.AWSEndpoint,
				SigningRegion: cfg.AWSRegion,
			}, nil
		}

		return endpoints.DefaultResolver().EndpointFor(service, region, optFns...)
	}

sessionOptions := session.Options{
		Config: aws.Config{
			EndpointResolver: endpoints.ResolverFunc(endpointResolver),
		},
	}
```

If you want to learn more about using custom endpoints, you can check out the AWS documentation here: https://docs.aws.amazon.com/sdk-for-go/api/aws/endpoints/#hdr-Using_Custom_Endpoints

Also, if you're interested, this API is also available in other languages:

- Rust (example implementation): https://docs.aws.amazon.com/sdk-for-rust/latest/dg/localstack.html
- JavaScript: https://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/Endpoint.html
- .NET: https://aws.amazon.com/blogs/developer/overriding-endpoints-in-the-aws-sdk-for-net/

## Ending

Currently, I am populating SQS with messages by running a command in my GO application that creates and sends the message to SNS. The reason behind this is that I don't want to restart my Docker containers every time I want to test my application. There are other ways of achieving this, such as running [init-hooks](https://docs.localstack.cloud/references/init-hooks/) or creating a bash file that posts messages to the SNS topic.

However, I will use init-hooks when developing integration tests for this application and running it inside a CI environment.

I hope this article has been helpful to you!
