---
title: "Goroutines: The Espresso Shots of Programming"
date: 2023-10-03T12:39:16+02:00
draft: false
description: "In this post, we dive deeper into Goroutines, a feature of the Go programming language that enables concurrent execution and convenient utilization of multiple threads. We discuss the simplicity and ease of understanding of Go, explore how Goroutines work, and examine the GMP model in Go. Additionally, we cover topics such as blocking, channels, and WaitGroups. Discover the power and benefits of using Goroutines in your Go applications. Don't miss out on this insightful exploration of Goroutines and their role in concurrent programming."
type: "blog"
tags: ["Go", "Concurrency"]
images:
  - /og-images/golang.jpeg
series:
  - Concurrency
  - GO
toc: true
---

Hey there! 👋 I wanted to dive deeper into Goroutines and share some insights I've gained from my readings. If you're familiar with the programming language Go, you probably already know what I'm referring to. If not, I recommend researching it on DuckDuckGo before continuing with this article. In this post, I will discuss Goroutines, a feature of the Go runtime that allows for convenient utilization of multiple threads and enables concurrent execution in Go. One of the remarkable aspects of Go is its simplicity and ease of understanding, which makes working with Goroutines a breeze. However, it's important to keep in mind Go's design philosophy, which imposes certain limitations on code structure and also influences how we use Goroutines.

A *goroutine* is a lightweight thread managed by the Go runtime and is executed using the `go` keyword before a function.

Let's take a look at a function called "say":

```go
func say(s string) {
	for i := 0; i < 5; i++ {
		time.Sleep(2 * time.Second)
		fmt.Println(s)
	}
}

```

If we want to run this function 10 times without waiting for 100 seconds for it to finish, using Go's goroutine would be an excellent choice. We can execute this function concurrently in different threads by doing the following:

```go
func main() {
	go say("world")
	go say("world")
	go say("world")
	go say("world")
	go say("world")
	go say("world")
	go say("world")
	go say("world")
	go say("world")
	say("hello")
}

```

The code above will initiate 9 goroutines and execute the say function 10 times.

### But what is happening when you add “go” before the function?

The Go runtime operates on a CPU, similar to how other computer tasks are handled. In addition to CPU cores, there is an abstraction layer that allows for thread scheduling. When a thread is scheduled, the kernel determines which core will be used. However, if the CPU has a long queue of tasks to execute before running your code, your code may not be executed immediately. This is where Go's concurrency comes into play.

By creating multiple tasks that we want to execute simultaneously, Go schedules them for the kernel to run on each core later using system calls. System calls serve as an interface between an application and the kernel, facilitating task scheduling.

There is 3 types of thread models that Go uses:

- Kernel Level Thread model
- User Level Thread model
- Hybrid  Thread model

### Kernel Level Thread Model

The Kernel Level Thread model follows a 1-to-1 relationship between user threads and kernel threads. In this model, the creation, destruction, and switching of threads are all managed by the kernel. When an application needs a new thread or wants to terminate an existing one, it makes a system call to the kernel.

One of the advantages of the Kernel Level Thread model is that if one process is blocked in a multiprocessor system, other threads within the same process can be switched to avoid being blocked. However, it is costly for the CPU to create and delete threads due to CPU involvement.

### User Level Thread Model

As you may have noticed in the content about the Kernel Level Thread Model, there wasn't much text, and that was intentional. Now, I would like to provide some information about the User Level Thread Model and then compare and discuss how these two models work together.

The User Level Thread Model has a many-to-one relationship with kernel threads, and the creation and destruction of threads are all handled by the application. A user thread is scheduled by the application and later associated with a kernel-level thread. The kernel is unaware of the scheduling of user-level threads since the application creates a task, associates a kernel thread with it, and executes them.

This means that running a user-level thread requires less work and is not as resource-intensive as creating a kernel thread. However, the kernel is not aware if a user-level thread is blocked or if there are other kernel threads running. This means that if a user-level thread is blocked, the remaining user-level threads scheduled on the same kernel thread will also be blocked.

### Hybrid thread model

In the two-level threading model, each user thread corresponds to one kernel thread in a one-to-one relationship (N: M). This threading model combines the benefits of both the Kernel Level Thread model and the User Level Thread model while minimizing their drawbacks. User thread creation takes place in user space, while thread scheduling and synchronization are handled by the application. Multiple user-level threads within an application are assigned to a limited number of kernel-level threads, which can be equal to or fewer than the number of user-level threads.

## GMP model

Let's discuss the GMP model in Go. GMP stands for:

- G: Goroutine, which is the smallest unit involved in scheduling and execution.
- M: Machine, representing system-level threads.
- P: Processor, which is the logical processor. P includes a local queue called LRQ, associated with P and capable of running G.

In the G-M-P model, goroutines (G), system-level threads (M), and logical processors (P) are involved in the scheduling process. This process includes obtaining a P, fetching G from the local queue (LRQ), and stealing from other P's local queues if necessary. The life cycle begins with the creation of M0 and G0, followed by scheduler initialization and the execution of the main function. The number of G and P is flexible, while the maximum number of M is set during program startup.

## Blocking

A term commonly used when discussing concurrency is "blocking". The concept is straightforward: thread A is blocked by thread B and cannot execute its function until thread B completes. In the GMP model, a thread can be blocked in various ways, such as I/O, blocking on a system call, channels, or waiting for a lock.

When a user-level thread is blocked due to a channel operation or I/O, it will be placed in a waiting queue. This allows the Goroutine to execute another thread and later resume with the first thread. If there are no more Goroutines to execute, the system-level thread will unbind itself.

When a system-level thread is blocked, the processor will pause it and switch to another thread. The first thread will continue once the second thread is finished and marked as ready. When the first thread is unblocked, the Goroutine will try to find another processor to continue executing on.

When a thread is switched to a blocked state and later continues to run, it is called context switching. The concept behind context switching is that the state of thread A is saved so that another processor can resume execution from the same point when the thread is unblocked. 

## Channels

The problem with running concurrency is that threads run in isolation and cannot communicate with each other unless they write to memory. However, if two threads try to write to the same memory slot simultaneously, a race condition error will occur in Go and result in a panic. 

A race condition occurs when multiple threads can access shared data and attempt to modify it simultaneously. The order in which the threads access the shared data is uncertain due to the thread scheduling algorithm. This uncertainty can result in different outcomes of the data modification, depending on the scheduling. Essentially, the threads are "racing" to access or modify the data.

In Go, channels are used to allow multiple goroutines to communicate with each other. A channel serves as a medium for goroutines to send and receive messages.

Creating a channel is straightforward:

```go
channel := make(chan string)

```

Sending a message to the channel is done using:

```go
channel <- "Hello World"

```

Reading data from the channel is done using:

```go
value := <-channel

```

A common use-case for channels is when each goroutine sends messages to the main goroutine (the one created when executing `main()`), which later replaces the data of a memory slot. This approach helps prevent race conditions. 

The content of a channel in GO don’t need to be only strings. it can be floats, bool, structs, int and so on. I just used string as a example.

## Waitgroups

If the main goroutine dies, the rest of the executing goroutines will also die. However, there is a way to prevent this from happening smoothly. Go's standard library `sync` provides "WaitGroups". The concept of WaitGroups is to block the goroutine that creates the WaitGroup until all goroutines have finished, thus preventing it from dying.

To use a WaitGroup, you need to create a WaitGroup using the following code:

```go
var wg sync.WaitGroup

```

For each goroutine you create, you add it to the WaitGroup using the following code:

```go
wg.Add(n)

```

where `n` represents the number of goroutines that are created.

When each goroutine is finished, you call `wg.Done()` to decrease the number of goroutines to wait for by 1.

For example, in the code below, we create a WaitGroup and then create 5 goroutines. We increment the number of goroutines to wait for by 1 for each goroutine. When a goroutine finishes, we decrement the number of goroutines to wait for by 1. When all goroutines are done, we print "finished".

```go
package main

import (
	"fmt"
	"sync"
	"time"
)

func worker(id int) {
	fmt.Printf("Worker %d starting\\n", id)

	time.Sleep(time.Second)
	fmt.Printf("Worker %d done\\n", id)
}

func main() {
	var wg sync.WaitGroup

	for i := 1; i <= 5; i++ {
		wg.Add(1)

		i := i

		go func() {
			defer wg.Done()
			worker(i)
		}()
	}

	wg.Wait()

	fmt.Println("Finished")
}

```

To prevent our goroutines from dying when the goroutine that creates them dies without using a WaitGroup, you would need to create a loop that waits for all goroutines to finish before continuing. This is necessary because the goroutine creating all the goroutines only creates the threads and does not wait for them to finish before executing the rest of the code. By waiting for all the threads to finish, we ensure that our code is running concurrently.

Waitgroup can be considered as an equivalent to JavaScript's [Promise.All()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/all). The purpose of both functions is to execute the code and then wait for all promises/goroutines to finish before continuing.

## Summary

Goroutines are a useful tool in Go applications. They allow us to handle increased traffic, execute jobs faster, and more efficiently. However, it is not necessary to use goroutines all the time. In some cases, they can introduce unnecessary complexity and overhead. Nevertheless, goroutines can be a valuable tool for executing multiple jobs. They can be particularly useful as an alternative to horizontal scaling. If you need to increase the power of your application and are considering horizontal scaling, goroutines can be a viable option. For instance, by spinning up 5 goroutines, you can execute 5 times more jobs.

Hope this article helped you and maybe taught you something. The purpose of the article for me was to learn more about what happens when a goroutine is created and how the CPU handles goroutines.

Also, regarding the title, I used ChatGPT to generate it. It sounded nice, so I decided to keep it.

Got any feedback? I would love to hear it. You can contact me via https://twitter.com/emil_priver or through this Reddit thread https://www.reddit.com/user/Privann/comments/16yoibp/goroutines_the_espresso_shots_of_programming/.
