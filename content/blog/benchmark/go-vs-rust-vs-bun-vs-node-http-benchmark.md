---
title: "Go vs Rust vs Bun vs Node, Simple Http Benchmark"
date: 2023-09-12T10:49:57+02:00
draft: false
description: "This post compares the performance of Bun, Rust, Go, and Node for handling HTTP requests. The author benchmarks each language using a simple benchmark test and tests returning a simple string and a JSON string. The post also discusses the author's reasons for conducting the test and provides a summary of the results."
type: "blog"
tags: ["Benchmark", "GO", "Rust", "Bun", "Node"]
best: true
images:
  - /og-images/star-trek.jpg
series:
  - Data Warehouse
cover: "images/general/star-trek.jpg"
toc: true
---
Recently, Bun v1.0 was [released](https://bun.sh/blog/bun-v1.0), which shows promise as a tool for serving many users without using too many resources. To evaluate its performance, a simple benchmark test was created to measure the number of HTTP calls the server can handle per second. The benchmark also compares Bun with GO, Rust, and Node, as these languages are frequently compared in other benchmarks and are used for similar purposes.

The benchmark test was run both locally and on a Linode server with 2 dedicated CPU cores and 4GB of RAM, running Debian 11 on Linode. All four tests were compiled and run using the following commands:

- Bun: `bun build --minify ./index.ts --outfile benchmark.js && bun run ./benchmark.js`
- Rust: `cargo build -r && ./taget/release/rust`
- GO: `go build -o benchmark ./cmd && ./benchmark`
- Node: `node benchmark.js`

The tests were run on the following runtime versions:

- Rust: `rustc 1.74.0-nightly (b4e54c6e3 2023-09-11)`
- GO: `go version go1.21.0 darwin/arm64`
- Bun: `1.0.0`
- Node: `v20.6.1`

To benchmark test each runtime, Rust, GO, Node, and Bun were built for production usage, and the same test was run for each language. The test was conducted with 100 concurrent connections running for 1 minute, and all of the runtimes utilized multithreading. The HTTP tests were run using https://github.com/wg/wrk. All languages use a built-in HTTP server, except for Rust, which uses Axum and Tokio because Rust doesn't come with a built-in HTTP server.

The source code for this test can be found at: https://github.com/emilpriver/go-rust-bun

## Why?

Before I show you the results, I'd like to explain why I conducted this test. Mainly out of curiosity, I wanted to see if there is a JS runtime that can perform almost as fast as Rust and Go. I am not a huge fan of JS in general, mainly because I don't enjoy writing the language, but I also felt that there hasn't been a JS runtime that is "good enough". The JS world got Deno a while ago, which seems to be a bit faster, but still not "good enough".

In the real world, the bottleneck in your system would probably not be the runtime; it would probably be something else such as your database or ingress etc. We can see this if we look at the results of running the tests in the cloud.

This type of test may not be the best, but it still provides a good indication of Bun's performance compared to others. With this, we now have a runtime that could be a good choice when building businesses.

There is probably a better way to conduct this type of test, possibly by running a WebSocket with numerous clients listening to the socket to determine which runtime performs the best. However, that is a test for another time.

## Running the tests locally

First of, rust

```yaml
➜  ~ wrk -t16 -c100 -d30 http://localhost:3000/        [23/09/11|18:17am]
Running 30s test @ http://localhost:3000/
  16 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   646.00us  257.18us  23.35ms   82.65%
    Req/Sec     8.87k     1.94k  131.74k    96.33%
  4236013 requests in 30.10s, 533.25MB read
Requests/sec: 140734.62
Transfer/sec:     17.72MB
```

Then, Go:

```yaml
➜  ~ wrk -t16 -c100 -d30 http://localhost:3000/        [23/09/11|18:18am]
Running 30s test @ http://localhost:3000/
  16 threads and 100 connections
	  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     1.38ms    2.30ms  47.02ms   90.18%
    Req/Sec     8.05k     3.41k   38.96k    81.04%
  3852621 requests in 30.10s, 484.99MB read
Requests/sec: 128013.26
Transfer/sec:     16.11MB
```

Then, bun:

```yaml
➜  ~ wrk -t16 -c100 -d30 http://localhost:3000/        [23/09/11|18:20am]
Running 30s test @ http://localhost:3000/
  16 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     0.87ms  293.87us   9.17ms   69.47%
    Req/Sec     6.90k     1.21k   36.01k    76.35%
  3297480 requests in 30.10s, 411.96MB read
Requests/sec: 109544.95
Transfer/sec:     13.69MB
```

And finally, Node:

```yaml
➜  ~ wrk -t16 -c100 -d30 http://localhost:3000/        [23/09/11|18:20am]
Running 30s test @ http://localhost:3000/
  16 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     1.31ms  360.42us  21.84ms   97.00%
    Req/Sec     4.61k   715.68    36.23k    96.36%
  2203924 requests in 30.10s, 344.70MB read
Requests/sec:  73214.63
Transfer/sec:     11.45MB
```

When running tests locally, we quickly see that Rust serves more requests per second compared to the other options.

### Testing JSON Locally

It is time to test the speed of each runtime in serializing and returning a simple JSON string. The task is to serialize a simple JSON struct and return it:

```json
{
	"message": "Hello from X"
}
```

Let's begin with Rust:

```yaml
➜  ~ wrk -t16 -c100 -d30 http://localhost:3000/json    [23/09/11|18:21am]
Running 30s test @ http://localhost:3000/json
  16 threads and 100 connections

  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   647.61us  317.36us  57.77ms   88.61%
    Req/Sec     8.85k     1.10k   26.06k    89.97%
  4233542 requests in 30.10s, 553.13MB read
Requests/sec: 140649.25
Transfer/sec:     18.38MB
```

Then, Go:

```yaml
➜  ~ wrk -t16 -c100 -d30 http://localhost:3000/json    [23/09/11|18:22am]
Running 30s test @ http://localhost:3000/json
  16 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     1.28ms    1.94ms  39.28ms   89.29%
    Req/Sec     8.05k     3.03k   50.58k    83.15%
  3851061 requests in 30.05s, 499.48MB read
Requests/sec: 128139.64
Transfer/sec:     16.62MB
```

Then Bun:

```yaml
➜  ~ wrk -t16 -c100 -d30 http://localhost:3000/json    [23/09/11|18:23am]
Running 30s test @ http://localhost:3000/json
  16 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     0.96ms  292.66us   8.02ms   69.03%
    Req/Sec     6.25k   823.58    13.79k    67.41%
  2987952 requests in 30.10s, 387.54MB read
Requests/sec:  99252.20
Transfer/sec:     12.87MB
```

Then Node

```yaml
➜  ~ wrk -t16 -c100 -d30 http://localhost:3000/json    [23/09/11|18:24am]
Running 30s test @ http://localhost:3000/json
  16 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     1.32ms  371.17us  26.89ms   97.63%
    Req/Sec     4.59k   520.59    22.74k    95.40%
  2192330 requests in 30.10s, 384.70MB read
Requests/sec:  72826.92
Transfer/sec:     12.78MB
```

Here, we see that Rust still performs the best, followed by Go, then Bun, and finally Node. There were no significant changes.

## Running the tests in the cloud

It is time to run the same tests in the cloud. This time, I have spun up a server with a dedicated CPU in Stockholm to perform the tests. To avoid limitations, I am running the benchmark from my local computer to the server. If I were to run a client server within Linode, I would be limited to choosing only dedicated 2 CPUs without creating a support ticket. Additionally, my local computer has more cores and an internet connection that is “good enough for this test.” I have also increased the number of connections to the server in order to achieve better results.

### Testing returning only a simple string

First, Rust:

```yaml
➜  ~ wrk -t16 -c1000 -d30 http://IP_ADDRESS:3000                                         [23/09/11|18:17am]
Running 30s test @ http://IP_ADDRESS:3000
  16 threads and 1000 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    42.33ms   18.99ms 955.01ms   96.59%
    Req/Sec     1.50k   149.92     1.98k    76.34%
  718755 requests in 30.06s, 90.48MB read
Requests/sec:  23908.99
Transfer/sec:      3.01MB
```

Then, GO:

```yaml
➜  ~ wrk -t16 -c1000 -d30 http://IP_ADDRESS:3000                                         [23/09/11|18:18am]
Running 30s test @ http://IP_ADDRESS:3000
  16 threads and 1000 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    43.38ms   17.01ms 909.10ms   95.44%
    Req/Sec     1.46k   193.88     2.10k    81.69%
  698266 requests in 30.10s, 87.90MB read
Requests/sec:  23200.34
Transfer/sec:      2.92MB

```

Then, Bun:

```yaml
➜  ~ wrk -t16 -c1000 -d30 http://IP_ADDRESS:3000                                         [23/09/11|18:20am]
Running 30s test @ http://IP_ADDRESS:3000
  16 threads and 1000 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    42.61ms   15.20ms 647.53ms   95.99%
    Req/Sec     1.48k   173.54     2.17k    80.20%
  707302 requests in 30.10s, 88.36MB read
  Socket errors: connect 0, read 83, write 0, timeout 0
Requests/sec:  23497.18
Transfer/sec:      2.94MB

```

Finally, Node:

```yaml
➜  ~ wrk -t16 -c1000 -d30 http://IP_ADDRESS:3000                                         [23/09/11|18:21am]
Running 30s test @ http://IP_ADDRESS:3000
  16 threads and 1000 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    52.50ms   77.15ms   2.00s    98.27%
    Req/Sec     1.23k   235.30     2.54k    78.12%
  587719 requests in 30.10s, 91.92MB read
  Socket errors: connect 0, read 0, write 0, timeout 434
Requests/sec:  19524.73
Transfer/sec:      3.05MB

```

### Testing json

First of, rust:

```json
➜  ~ wrk -t16 -c1000 -d30 http://IP_ADDRESS:3000/json                                    [23/09/11|18:22am]
Running 30s test @ http://IP_ADDRESS/json
  16 threads and 1000 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    42.41ms   16.37ms 675.49ms   94.41%
    Req/Sec     1.49k   179.27     2.31k    76.62%
  713684 requests in 30.09s, 93.25MB read
Requests/sec:  23715.51
Transfer/sec:      3.10MB
```

Then GO:

```json
➜  ~ wrk -t16 -c1000 -d30 http://IP_ADDRESS:3000/json                                    [23/09/11|18:23am]
Running 30s test @ http://IP_ADDRESS:3000/json
  16 threads and 1000 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    42.79ms   16.54ms 911.38ms   92.91%
    Req/Sec     1.48k   159.48     2.05k    80.35%
  705947 requests in 30.06s, 91.56MB read
Requests/sec:  23487.51
Transfer/sec:      3.05MB
```

Then, Bun:

```json
➜  ~ wrk -t16 -c1000 -d30 http://IP_ADDRESS:3000/json                                    [23/09/11|18:25am]
Running 30s test @ http://IP_ADDRESS:3000/json
  16 threads and 1000 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    42.05ms   14.06ms 612.82ms   94.12%
    Req/Sec     1.49k   177.55     2.08k    73.49%
  713417 requests in 30.10s, 92.53MB read
Requests/sec:  23705.30
Transfer/sec:      3.07MB
```

Finally Node:

```json
➜  ~ wrk -t16 -c1000 -d30 http://IP_ADDRESS:3000/json                                    [23/09/11|18:27am]
Running 30s test @ http://IP_ADDRESS:3000/json
  16 threads and 1000 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    54.68ms   71.56ms   2.00s    98.99%
    Req/Sec     1.12k   219.26     2.03k    71.92%
  536148 requests in 30.10s, 94.08MB read
  Socket errors: connect 0, read 0, write 0, timeout 458
Requests/sec:  17815.15
Transfer/sec:      3.13MB
```

## Summary

It's exciting to see that Bun performs well, and seems to be a runtime that can compete with Rust and Go for HTTP. I'm also thrilled that there's now a runtime that "does it all." Unlike languages such as Rust and Go, which provide package managers, Bun provides one as well. Node, on the other hand, has various package managers (even though NPM is the one that comes with Node), and many different ways of achieving the same thing, where each method is faster than the others.

Although I am not a big fan of writing JavaScript in general, I am looking forward to building something with Bun.

I would love to receive feedback, and the easiest way to contact me is via Twitter: https://twitter.com/emil_priver

