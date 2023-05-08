---
title: "Initial Commit: Zig"
date: 2023-05-05T22:29:13+02:00
draft: true
toc: true
description: "Article about the programming language Zig." 
type: "blog"
tags: ["zig"]
series:
- Zig
- Initial Commit
images:
  - /og-images/zig-og.jpg
cover: "images/zig/zig-og.jpg"
---
"Initial Commit" is a series of posts where I explore different topics that interest me. In this post, we will look at Zig.

Recently, I overheard a conversation at work about the programming languages Rust and Zig. Later that evening, I stumbled across the Twitch streamer [kristoff_it](https://www.twitch.tv/kristoff_it). Loris, the VP of Community in the Zig language, was working on auto-documentation for the Zig language, which caught my interest. So, I decided to look into it further.

Zig is a programming language that has been around for a while, and I thought it would be a good idea to check it out. Although still in development, [Zig](https://ziglang.org/) has some interesting features. However, there is still a lot of work to be done before its first stable release, but progress is being made. Although there is still work to be done before the 1.0 release, there are some companies that have started to adopt Zig, such as Uber. Uber recently released an article about using Zig for its infrastructure, indicating an interest in the language.

Since Zig is in its early stages, it lacks some features that would be beneficial to have, such as documentation for everything to explain how things work. I feel that this is something that is currently missing and would greatly appreciate seeing more of it. However, this is currently under development.

## Zig: The programming language

Zig is a relatively new programming language, designed by Andrew Kelly, that first appeared on February 8, 2016, according to [Wikipedia](https://en.wikipedia.org/wiki/Zig_(programming_language)). This is a general-purpose language that aims to provide a balance between performance, safety, and ease of use. One of its main goals is to be a better alternative to C, compared to Rust which aims for the C++ world. Zig also aims to prevent hidden control flows that may cause your code to run unintended functions. 

Zig has four different modes for compiling code: Debug, ReleaseFast, ReleaseSafe, and ReleaseSmall. You can read more about them [here](https://ziglang.org/documentation/master/#Debug). These modes can be applied to different scopes with various combinations, allowing you to modify the settings in your code and apply them to different functionalities.

```
test "@setRuntimeSafety" {
    // The builtin applies to the scope that it is called in. So here, integer overflow    // will not be caught in ReleaseFast and ReleaseSmall modes:    // var x: u8 = 255;    // x += 1; // undefined behavior in ReleaseFast/ReleaseSmall modes.    {
        // However this block has safety enabled, so safety checks happen here,        // even in ReleaseFast and ReleaseSmall modes.        @setRuntimeSafety(true);
        var x: u8 = 255;
        x += 1;

        {
            // The value can be overridden at any scope. So here integer overflow            // would not be caught in any build mode.            @setRuntimeSafety(false);
            // var x: u8 = 255;            // x += 1; // undefined behavior in all build modes.        }
    }
}
```

### Zig's Unique Approach to Building Applications

Zig has a different way of handling builds than what I've seen before. To create a new project, you first create a new folder, enter that folder, and run `zig init-exe`. This creates a `src` folder and a file named `build.zig`, which is used to tell Zig how to build your application.

And the output from the above command in the `build.zig` file mostly looks like this (Zig is still in development, so the output may differ in different versions of Zig.):

```
const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("fresh", "src/main.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}

```

Defining how to build your code this way is not something I’ve experienced earlier. I believe it is not essential to elaborate on every aspect of this code. However, if you wish to acquire more knowledge regarding the build step, I highly recommend referring to this guide on [zig.news](https://zig.news/xq/zig-build-explained-part-1-59lf). In brief, we specify the target operating system and build mode. Then, we instruct Zig to register and compile a new executable called `fresh`, which is located at `src/main.zig`. We also tell Zig to install all code dependencies we need.

Finally, we register a run command with the description "Run the app", which we can use when building our code.

After registering the "run" command, we can verify whether we are running "zig build XXX", where XXX is not a registered word and would cause an error. This command can also be run directly by executing `zig build run`.

![Terminal](images/zig/terminal.png)

This means that we can register different commands that suit each application. While this functionality may not be uncommon, it's nice to have the ability to customize the build depending on logic in the code and handle it through code.

### Integrating C code in Zig applications

A useful feature of Zig is the ability to import C code directly using the `@cImport()` and `@cInclude()` annotations. This allows us to include libraries such as `curl/curl.h` in our Zig applications.

```
const std = @import("std");
const cURL = @cImport({
    @cInclude("curl/curl.h");
});

pub fn main() !void {
    // setup curl options
    if (cURL.curl_easy_setopt(handle, cURL.CURLOPT_URL, "https://ziglang.org") != cURL.CURLE_OK)
        return error.CouldNotSetURL;
}
```

*Running the code above won't work. It's a stripped-down example from the [code-examples](https://ziglang.org/learn/samples/#using-curl-from-zig)*

## Zig Syntax

## Recommended Articles

This area contains some articles that I recommend reading, which might help you on your Zig journey.

### **What is Zig's Comptime? by Loris Cro**

[https://kristoff.it/blog/what-is-zig-comptime/](https://kristoff.it/blog/what-is-zig-comptime/)

This article discusses `comptime`, which refers to code that runs only during compile time. It works kind of like macros in Rust.
