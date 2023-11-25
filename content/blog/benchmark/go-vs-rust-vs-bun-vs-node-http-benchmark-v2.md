---
title: "Go vs Rust vs Bun vs Node, Simple Http Benchmark V2"
date: 2023-09-18T22:15:13+02:00
draft: false
description: "This post compares the performance of Bun, Rust, Go, and Node for handling HTTP requests. The author benchmarks each language using a simple benchmark test and tests returning a simple string and a JSON string. The post also discusses the author's reasons for conducting the test and provides a summary of the results."
type: "blog"
tags: ["Benchmark", "GO", "Rust", "Bun", "Node"]
best: true
images:
  - /og-images/star-trek.jpg
series:
  - Benchmark
toc: true
---

A while ago, I published an article titled ["**Go vs Rust vs Bun vs Node, Simple Http Benchmark**"](https://www.priver.dev/blog/benchmark/go-vs-rust-vs-bun-vs-node-http-benchmark/) and I have been thrilled with the response and the valuable feedback I received. I truly appreciate all the input. Based on the feedback, I understand that there is room for improvement in this test. Here are some of the key points that were highlighted:

- It would be really helpful to enhance the presentation of the results by incorporating graphs or other visual aids.
- Testing on a local machine can sometimes lead to CPU context switching between demanding processes, resulting in cache misses and uneven distribution of workloads. [Twitter Comment](https://x.com/tusharmath/status/1703057561627603072?s=20)
- It would be more effective to conduct the test when the server's CPU usage is at maximum capacity.
- Including a visualization of memory usage would be highly beneficial.
- Node and bun do not utilize any routing, which can potentially improve performance since any path will yield the same outcome.

I have made some improvements to the test based on your suggestions. To ensure a seamless experience, I have redesigned the test to be conducted entirely in the Linode cloud environment. I used a Linode server with 4 dedicated CPU cores and 8GB of RAM, and the clients are also running on Linode, totaling 8 clients. Additionally, I have increased the test duration to 400 seconds for each run.

To make the benchmarking process for my Sunday hobby project simpler and better, I created my own HTTP benchmarking tool called [Elton](https://github.com/emilpriver/elton). Elton has a user-friendly HTTP interface that makes it easy for me to start tests on each client from my local computer and get the results. The tool works by creating a specified number of [Tokio](https://tokio.rs/) tasks that send requests to a single endpoint built in Rust. While there are still areas that can be improved, it still works fine to be used for this tests. One improvement I plan to make is creating a connection pool within Hyper to send requests more efficiently. Additionally, I developed a [GO client](https://github.com/emilpriver/go-rust-bun-node/tree/v2/client) that starts the tests on each node in my client cluster, waits for the results, and writes them to a CSV file. This file can later be converted to CSVs, which I can use to generate graphs using Google Sheets.  

In addition to the tests performed in each programming language, I also ensure that each language/runtime is utilizing 100% of the CPU.

By the way, Bun has released [v1.0.2](https://bun.sh/blog/bun-v1.0.2) with some improvements. Therefore, the Bun version used for this test has been updated.

I am also using TSX, which is a TypeScript Execute (`tsx`): Node.js enhanced with **[esbuild](https://esbuild.github.io/)** to run TypeScript & ESM files.

Below are the build commands used for each test:

- Bun: `bun build --minify ./index.ts --outfile benchmark.js && bun run ./benchmark.js`
- Rust: `cargo build -r && ./taget/release/rust`
- GO: `go build -o benchmark ./cmd && ./benchmark`
- Node: `tsx src/index.ts`

The tests were performed using the following runtime versions:

- Rust: `rustc 1.72.0 (5680fa18f 2023-08-23)`
- GO: `go version go1.21.0 darwin/arm64`
- Bun: `1.0.2`
- Node: `v20.6.1`

Each of the test was started using this settings:
```json
{
  "method": "GET",
  "tasks": 100,
  "seconds": 400,
  "start_at": "2023-09-17T10:16:34.675Z",
  "url": "http://172.232.156.13:3000/json", 
  "content_type": "application/json",
  "body": ""
}
```

## Quick: What is Elton and how does it work

The problem I faced was the manual entry of each client, starting the benchmark utility, reading the results on each client, and then inputting them into a Google Sheet. While this approach may have taken less time than creating Elton and conducting the test, it wouldn't have been as enjoyable. Therefore, I developed [Elton](https://github.com/emilpriver/elton), a simple benchmark utility that is still in development but has been used for this test. Elton has an HTTP API that allows me to initiate a test, check its status, and retrieve the results. Later, I can combine and write these results to a CSV file using a custom [client](https://github.com/emilpriver/go-rust-bun-node/tree/v2/client) specifically designed for this test.

Elton works by defining the number of `tasks`, which represents the number of Tokio tasks created to repeatedly send requests for a specified duration. Elton considers a request as a complete round-trip request. If Elton encounters any issues while sending the request, such as a socket hang-up, it treats it as an error. Once Elton finishes the test, it reports the results and stores them in a SQLite file created during its execution. These results are then displayed in the API.

The future plans for Elton include:

- Supporting a `start_time` parameter to ensure that each test starts at the same second
- Initiating multiple TCP connections to the server
- Implementing optimizations
- Storing response time
- Developing a command-line interface (CLI)
- Visualizing the results through graphs, CSV files, and other methods

Elton's source code can be found here: https://github.com/emilpriver/elton. If you want to be a part of Elton, it would be lovely!

## Results: Requests per Second

This result can also be found on [this link to my Google Sheet](https://docs.google.com/spreadsheets/d/1LmQFoFOp_ECgz5BWNMZQBdxHEkJaNbEeT0_0jdNwiO4/edit?usp=sharing).

![Bun vs Node Vs Go Vs Rust HTTP Benchmark](/images/benchmark/node-vs-bun-vs-rust-vs-go.png)

Here, we clearly see that Rust is performing really well compared to the others. Go and Bun are not far from each other, while Node is significantly behind.

Why is Node falling behind? There can be multiple reasons, but two of them are that Node is single-threaded and has a garbage collector. We might notice this when the number of requests per second slightly decreases for Node.


## How important are this type of tests?

This was a question I received, and the answer is that it's not really important, or well, it depends on what you are building. In the real world, you have many more dependencies in your application, such as a database or another service that you need to communicate with. However, in some cases, the language or the runtime can be the bottleneck. A simple URL shortener can be one such case.

Let's imagine you are using Redis as your key-value storage system, where the shortened URLs are stored as keys and the corresponding real URLs are stored as values. If Redis is deployed alongside your application, such as in the same cluster or server, the latency between the app and Redis will be very low. Additionally, Redis is capable of handling a high volume of requests per second, potentially reaching thousands.

In such a scenario, if you need to serve 50,000 requests per second, using a runtime/language like Bun or Go may require significantly more resources, such as horizontally scaled servers, compared to using Node.js. This is illustrated in the graph above. However, it's important to note that for many other scenarios, the choice of runtime/language may not have a significant impact. This is just my perspective on when the runtime/language choice matters.

However, the purpose of the test is primarily to test the runtime/language, mostly out of curiosity, but also to keep in mind when building your system. The capacity of your runtime/language may impose different requirements on how you run your service.

For example, with Node, we need a lot of servers to handle the same amount of requests per second as Rust. However, this is mostly solved with Serverless. But it still doesn’t change the fact that we need more resources to run a Node service compared to Rust, Go, or Bun. On the other hand, Bun seems to be one of these alternatives that might be a runtime we can use to serve more clients without requiring significantly more resources.

## Summary

I'm pleased to observe that bun still performs well, even when multiple clients are running against a single server. My initial impression of the comparison between different languages and runtimes remains unchanged: NodeJS lags behind, while the others are relatively similar in performance. I hope that this test will help in determining which language/runtime developers will choose for new services.

I would love to receive feedback, and the easiest way to contact me is via Twitter: **https://twitter.com/emil_priver**
