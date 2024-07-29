---
title: "Designing a Platform for a Startup"
date: 2024-07-06T01:37:06+02:00
draft: true
description: "This post discusses how I designed a system architecture for a startup."
type: "blog"
tags: ["startup", "system architecture"]
cover:
  image: "images/nasa-rocket.jpg"
series:
- architecture
---
I am currently assisting an individual in building a startup, helping them design the architecture and establish a plan to get it up and running. The goal of this article is to explain the ideas I had and the reasoning behind them.

Before delving into the architecture, I will provide an overview of the startup and its purpose. This company functions as a service where customers can create content that is distributed across various platforms, including videos and images. Additionally, it offers a public API for customers to access data and can receive data from different sources through an API.

The system operates on the Google Cloud Platform, which I prefer over other major platforms like AWS and Azure because of its superior services and simplicity. Simplicity is also a key factor in the way we designed the system. Our approach is to create a straightforward architecture and system that efficiently accomplishes the task at hand. We avoid adding unnecessary features that we may think we need in the future, opting instead to incorporate them only when necessary.

The purpose of this post is to elucidate the rationale behind my design choices. Hopefully, this can serve as inspiration or guidance for future projects. Building such systems can be complex, with numerous ways to solve the same problem.

Now, let's examine the architecture for step 1.

In the image below, we can see various components. For those unfamiliar with the terminology, I will provide a brief explanation.

![system architecture step 1](images/startup/step-1-architecture.png)

- Service A: This is the main service in the system, serving as the backend for admin interfaces and user-provided data.
- Ingress & Egress: Ingress refers to incoming traffic, while egress pertains to outgoing traffic.
- Cloud Run: Google's managed container running system, where you provide a container image and Google handles the rest, including scaling and HTTP ingress.
- Public API: Our public API that users can use to query data, which needs to be fast and connect to the database for Service A.
- Incoming Public API: Our API for incoming data, for example, if a user wants to push data to our system when there is a change in their system.

Within this system, PubSub stands for publishers and subscribers. This is a queue system where some services publish to a topic and other services subscribe to this topic. This is how we create a queue system.

## Using managed services

In the early stages of a startup, the focus is on building features, shipping products, and establishing your position in the market. This also means that the team prefer not to deal with servers and instead focus on building, especially when the team does not have much experience in running a platform. However, managed services are typically more expensive than having a fixed cost for servers and using tools like Kubernetes. Despite this, it is worth it initially because the cost will not be too high since the amount of traffic will be low, and when we no longer need the apps, we can simply scale down to have no containers running.

It would absolutely be possible to use a cheap VPS and spin up a VPS running Kubernetes, but it would be more difficult to scale. Additionally, if you want to run a successful Kubernetes cluster, you need a dedicated team to maintain it. Maintaining Kubernetes is a job in itself that requires time. 

There are some issues with using managed services as they require you to write your applications in a certain way. For example, instead of setting up a closed network and allowing apps to communicate freely using HTTP within the closed network, you are now required to have an open HTTP API and verify the token in every service. This creates unnecessary complexity that could be avoided by restricting where traffic can enter the closed network and then allowing all other apps to communicate freely. 

A managed Cloud Run app or Cloud Function works well when used in isolation, but in a microservices architecture, it may not be as effective.

## Time to scale up
With my 6 years of programming experience, I have learned that the most challenging aspect to scale is the SQL database, especially one with a high volume of writes. While a SQL database primarily used for reads can be scaled up with read replicas, scaling a SQL database with writes is difficult. The typical approach is to scale vertically, but this can become costly.

Just because we can scale up the service does not mean we can scale our budget accordingly.

So with this said do I try to prevent that a lot of services have direct connection to the database mainly as it increase workload for the database and this do we not want. For instance in the image above do we have some cloud functions, if I instead of sending all the data directly to the cloud function, send a ID to the specific content which the function would fetch would this mean a new connection and more workload for the database which is not needed in this case.

Another important factor in scaling up and preventing downtime for our services is the use of queues. When we design an architecture that relies on direct HTTP requests for services to communicate with each other, it becomes more critical for a service to handle high traffic. For example, if a sudden surge in traffic overwhelms the database, it could cause other systems to fail and the entire system to go offline. This is obviously something we want to avoid, which is where using queues can be a solution. When a system is based on queues, it will slow down rather than completely stop working when faced with high traffic. However, using queues can also introduce complexity, as you now need to manage asynchronous flows if you require a response. If you use queues and your system slows down, you also have more time to scale up compared to if you were using direct HTTP traffic between the apps.

Using Cloud Run and Cloud Functions also makes it easier to scale up. With Cloud Run, we can easily add more containers and set up automatic scaling based on CPU usage. Cloud Functions scale simply by providing the code, and GCP handles the rest. This is why we avoid having a Cloud Function connect directly to the SQL database, as spinning up multiple functions simultaneously could result in a large number of connections to the database.

Of course, one way to handle an "infinite" amount of traffic is by going fully serverless and using a NoSQL database instead of an SQL database. However, the cost of this at such a scale would be exorbitant.
 
## Queues

As you may have noticed, much of the architecture in this system is based on queues. The API for incoming content from other platforms uses queues, so it is acceptable if the content is added 2 seconds later than when it was received. The main purpose of `Service B` is to authenticate the user, validate the payload, and then send it to `Service A` for handling when it is ready. The more complex aspect is that now you must handle a response to the publisher asynchronously. In this context, this could mean that if we send an event to the "service a egress topic," each cloud function could send an event to the "service a ingress topic" and report back the result of the execution.

As we work with content and want to distribute it, there is a convenient way to do so called PubSub. The concept of PubSub involves having one or more apps publishing data to a queue, while one or many apps listen for events. Google's PubSub offers two different types: pull (subscribers request data) and push (data is pushed to subscribers, functioning like a webhook). In this system, we use pull because we want to request jobs that may take several minutes to process.

In this system, when a user makes a change, we create an 'event' and send it to the topic. Subscribers can then receive the 'event' and process it. Each subscriber can choose which events to receive by filtering based on message attributes. This allows us to have multiple integrations receiving data and executing it in parallel without interruption to each other. 

To ensure that producers do not send data that other services cannot understand, we have created something called `event contracts`. The purpose of `event contracts` is to validate all events and data sent in the queue against a GO struct. Since all our backend services are developed in GO, if we were to add a new language, we would likely migrate to something like JSONSchema for data validation.

Here is the GO struct for our events:

```go
type EventType string

type Event[T any] struct {
	ID            uuid.UUID `json:"id" validate:"required"`
	CorrelationID uuid.UUID `json:"correlation_id" validate:"required"`
	CreatedAt     time.Time `json:"created_at" validate:"required"`
	EventType     EventType `json:"event_type" validate:"required"`
	Payload       T         `json:"payload" validate:"required"`
}
```
In this contract, we have some cool features. For example, `EventType` is the field that tells us the type of event we are receiving, such as `blog_post.new`. The `CorrelationID` is an ID used for logging and tracing, which is common in a microservices architecture. `CreatedAt` indicates when the event was created, and `ID` is the unique ID for the event.

This `Event` struct also includes a function to validate and publish the message.

```go
/**
* Validate the Event created and send it to the pubsub queue
* if the payload is not valid will this functions return errors
 */
func (event Event[T]) ValidateAndPublish(ctx context.Context, topic *pubsub.Topic) error {
	err := event.Validate()
	if err != nil {
		return err
	}

	payload, err := json.Marshal(event)
	if err != nil {
		return err
	}

	res := topic.Publish(ctx, &pubsub.Message{
		ID:   event.ID.String(),
		Data: payload,
		Attributes: map[string]string{
			"event_type": string(event.EventType),
		},
	})

	_, err = res.Get(ctx)
	if err != nil {
		return err
	}

	return nil
}
```

The `Payload` field contains the actual data, including the actual values rather than reference IDs that need to be looked up. If I want to create a "contract" for a `blog`, it could look like this:

```go
package contracts

import "github.com/google/uuid"

type BlogPayload struct {
    AppID   uuid.UUID `json:"app_id" validate:"required"`
    Title   string    `json:"title"`
    Content string    `json:"content"`
}

type Blog Event[BlogPayload]
```
And when we later want to send it, it could look like this:

```go
func TestSendBlog(t *testing.T) {
    event := Blog{
        ID:            uuid.New(),
        CorrelationID: uuid.New(),
        CreatedAt:     time.Now(),
        EventType:     "blog.new",
        Payload: BlogPayload{
            AppID:   uuid.New(),
            Title:   "hello world",
            Content: "lorem ipsum",
        },
    }

    err := event.ValidateAndPublish(context.Background(), &pubsub.Topic{})

    assert.NoError(t, err)
}
```

The benefit of this is that it increases the safety in our queues and prevents many more issues. However, it is not completely foolproof, as a new change could be released and some services may not have updated their version yet. Nevertheless, it significantly improves security compared to having no validation.

## The future
It's time to talk about the funniest part: the future. I discussed the drawbacks of using managed cloud run and cloud functions for running containers and code, such as the need for public APIs and higher costs. However, with the amount of traffic we currently have, it may be time to consider transitioning to Kubernetes for its flexibility and security benefits. 

For example, in Kubernetes, we can easily scale down a container when there are no events in the queues, and scale up when needed. We can also spin up sidecars to handle tasks that were previously done within the cloud run apps. 

I previously mentioned my desire to create a closed network for all apps to communicate with each other without passing tokens, and with a closed network, this is now possible. This means that our architecture may now look something like this.
Another reason to use Kubernetes is that, at this time, the company may have many more features and integrations. Continuing to use Cloud Run creates unnecessary complexity that no one wants.

![system architecture step 2](images/startup/step-2-architecture.png)

Everything inside the bubble is within the closed network, and we only expose a small number of ways into the system through apps.

The goal is to transfer all cloud functions and cloud run apps to Kubernetes in order to achieve the same results at a fixed or lower cost for our servers. Instead of creating a cloud function for each event, we can create a goroutine or start a new container for the task.

## The end
The purpose of this post was to share my ideas and explain my concept of this platform's architecture. It may have taught you something, or it may not have.

Some parts may not make sense, and you may wonder, "What on earth is he doing here?" However, I do not want to provide too much context so that people can understand which company it is.

Have a good day!
