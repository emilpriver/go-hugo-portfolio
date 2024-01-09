---
title: "Initial Commit: Zig Build System"
date: 2023-05-15T09:07:13+02:00
draft: false
toc: true
description: "Article about build step in zig" 
type: "blog"
tags: ["zig"]
series:
- Zig
- Initial Commit
cover:
  image: "images/zig-og.png"
---

This is step 2 in my "Initial commit" series, which focuses on the Zig programming language. In this step, I will delve deeper into the Zig build process.

I have been thoroughly testing and experimenting with the build step in Zig to explore its functionality and the extent of its capabilities. One of the many aspects of Zig's build system that I find most intriguing is its ability to conditionally build a project, which allows for more flexibility in the development process. In addition, I also appreciate the fact that the entire build process can be included in the project and become an integral part of it. This is in stark contrast to other popular build tools such as NPM, PNPM, Yarn (for JavaScript) or Cargo (for Rust), which are fundamentally standalone tools that operate outside of your code and cannot be integrated as seamlessly into a project as Zig's build system can. Currently, Zig does not have any package manager, but it will get one in release `0.11.0`.

Integrating the build step into your code enables you to build the project differently depending on the environment. For example, you might want to print debug information in the staging environment but not in production, or use a different "main" file depending on the operating system you are using.

In contrast, Rust handles this type of logic using macros such as `cfg-if`, which is also effective. I believe there are pros and cons to both ways of handling this. 

## Build.zig

Before explaining how to import packages into Zig, let me first give a brief explanation of the `build.zig` file and how it works. The build system works by having the compiler read `build.zig`, which exports an entry point `pub fn build(b: *std.build.Builder) void`. Developers can create "steps" in `build.zig` that have a set of requirements that must be fulfilled before each step is built. These requirements can include specifying the target to build, the mode to build in, and adding packages to the executable.

Adding a new step to your `build.zig` file is quite easy. Simply define a new step using the `step` function exported from `std.build.Builder`. Here is an example:

```zig
const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const step = b.step("you-new-step", "This is what is shown in help");
}
```

We can use the new `step` variable to add dependencies that must be run before the step. To compile our code and make it executable, we need to add our code to the build step by using:

```zig
const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const exe = b.addExecutable("program", "src/main.zig");

    const step = b.step("you-new-step", "This is what is shown in help");
    step.dependOn(&exe.step);
}

```

Now we can easily compile and run our code. However, in most cases, we also want to include different requirements in our build. For example, we may want to specify which mode we want to use (Debug, ReleaseFast, ReleaseSafe, or ReleaseSmall), or we may want to specify a target platform (Windows, Unix, Linux, WASM, etc.).

If you want to run the new step `your-new-step`, you can do so by running: `zig build your-new-step`. 

### Running Step After Compilation

In Zig, you can register a run command that executes your code after compilation. You can accomplish this easily by using the `.run()` function that is exposed from the executable:

```zig
const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const exe = b.addExecutable("program", "src/main.zig");

    const step = b.step("you-new-step", "This is what is shown in help");
    step.dependOn(&exe.step);

	  // Register run command
	  const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

}
```

This code compiles your program and then executes it directly, which is very useful for development purposes.

### Explanation of Basic Common Build Functions in Zig

- The `b.Step(step, description)` function adds a new step that can be used in our code to compile our program. Later on, dependencies can be added for this step.
- `b.addExecutable(name, path)` tells the Zig compiler where the root folder for your application is located and gives a name to your executable that you can use to execute it later on. This step is used together with other functions, such as `.Step()`, to specify which executable to work with.
- Call `b.setBuildMode()` to enable different "settings" for your executable. This function takes four different values:
    - `Debug`: An unoptimized build used for debugging.
    - `ReleaseFast`: Optimized for speed, used for software where performance is the highest priority, such as in games.
    - `ReleaseSafe`: Optimized, but still with some safety checks, such as array out of bounds.
    - `ReleaseSmall`: Optimized for speed, but with the priority of being as small as possible. This could be good when building WASM applications.
- The `setTarget(target)` function is used to specify the target for building in Zig. This function can be used in conjunction with `b.standardTargetOptions(.{})`, which enables the use of native targets. In Zig, native build targets allow the user to build for any target.
- The `b.standardTargetOptions(.{});` function comes with default rules for the target. This function allows Zig to build for any target.
- The `b.standardReleaseOptions()` method returns a default value for releases that works in most cases.
- The `exe.addPackagePath(name, path)` method registers a Zig library located at a specified path. We can then call this library in our projects and make use of it.
- To install anything, use `b.installArtifacts(executable)`. This creates a new `InstallArtifactStep` that will be called when executing either `zig build` or `zig build install`. To remove the executed file, use `zig build uninstall`. This removes all files. The command also has a shorthand named `install()` that does the same thing. However, you need to call this function from the executable that you registered earlier. For example:

```zig
const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const exe = b.addExecutable("fresh", "src/main.zig");
    exe.install();
}
```

With this information, we can now create a new executable that can be installed and run using the following code:

```zig
const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();
    const exe = b.addExecutable("test", "src/main.zig");
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

### Building multiple executables from a single command.

You can build to multiple targets using a single command with `zig build`. This allows you to build for different targets and modes, while still utilizing the code and logic you have developed.

For example, the following `build.zig` file creates two executables, `test` and `test-2`, using different targets:

```zig
const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("test", "src/main.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.install();

    const exe_2 = b.addExecutable("test-2", "src/main.zig");
    exe_2.setTarget("add your other target here");
    exe_2.setBuildMode(mode);
    exe_2.install();
}

```

You can use `b.standardTargetOptions(.{})` and `b.standardReleaseOptions()` to specify CLI flags for building different targets and modes. However, importing a target into `build.zig` is currently a bit difficult, as the type `CrossTarget` needs to be located first.

## **How to Import Packages into Zig without a Package Manager until 0.11.0 is Released**

I created this blog post because currently there is no package manager for Zig, and I've been struggling to import an HTTP library that I wanted to try out. I've been testing different ways of handling imports and found a solution that works. The solution involves creating a `zig-packages` folder where each package is a submodule added via Git. Then, in my code, I add each package and refer to its main file. 

```zig
// zig-release: zig-macos-aarch64-0.11.0-dev.3097+7f7bd206d.tar.xz

const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    b.use_stage1 = true; // this is needed for ZHP to work.

    const target = b.standardTargetOptions(.{});

    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("test", "src/main.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.addPackagePath("zhp", "zig-packages/zhp/src/zhp.zig");
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

This is my `build.zig` file. If you look at line 21, you'll see that `exe.addPackagePath("zhp", "zig-packages/zhp/src/zhp.zig");` adds a package called `zhp`, which refers to the main file of ZHP.

This is my folder structure. As you can see from the example above, the main file for the `zhp` package exists at `zig-packages/zhp/src/zhp.zig`.

![Tree structure](images/zig/tree-structure.png)

This allows me to later require the package in my code and use it like this:

```zig
const web = @import("zhp");

pub fn main() anyerror!void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(!gpa.deinit());
    const allocator = gpa.allocator();

    var app = web.Application.init(allocator, .{ .debug = true });
    defer app.deinit();

    try app.listen("127.0.0.1", 9000);
    try app.start();
}
```

One difficulty I ran into with this method is that finding the right commit hash to use in your `.gitmodules` can be challenging to avoid using buggy versions. You may also end up with many duplicate packages, which can make your application unnecessarily large since we don't do any tree-shaking.

## Package manager in version 0.11.0

Zig is releasing a package manager for version 0.11.0, which will make managing dependencies easier. Dependencies can be tricky to manage because it's difficult to predict how things will work before they are released, and they may change along the way. However, I have done some research and found the following information:

- Always use MVS (Multiple Version Selection). This means that the package manager will only fetch dependencies that are explicitly listed (with their checksums), but it will pick the maximum version among those options.
- Packages with versions >= 1.0.0 may not depend on packages < 1.0.0. This creates extra security, as we should work with stable software. Packages with a version equal to or greater than 1.0.0 should not be allowed to import and use a package with a version lower than 1.0.0.
- Incompatible major versions between the same packages within a dependency tree will be an error by the package manager. Alternatively, it will just pick the latest version, even if it is incompatible, and rely on the package author to make any breaking changes during compilation rather than at runtime.

Source: [https://github.com/ziglang/zig/issues/8284#issuecomment-1000565560](https://github.com/ziglang/zig/issues/8284#issuecomment-1000565560)

Some of the goals for Zig's package manager are:

- Robust and maintainable software
- Code reuse
- Friendly to distro maintainers

I appreciate the approach of making everything more strict and secure. Other package managers, such as Cargo or NPM, allow you to import any version, which may not be stable. Having an extra check while compiling our project can help us write much safer code. I don't think developers always know whether the package is stable or not when they import it into their packages/applications. They may assume it works, but that's not always the case.

**Disclaimer: This post will be updated with more information about the package manager, such as its release date and other details, when available.**

## Conclusion

As far as I know, the package manager "system" in C/C++ is quite bad, and Zig is attempting to solve this issue. One problem with package managers is that they can import many packages that the package you want to use needs, which can be difficult to control. This is the current situation for the entire NPM world, where one "tiny" package can include 1000 other packages, making your project very heavy.

If you want to learn more advanced build steps in Zig, I recommend reading this blog post series: [https://zig.news/xq/zig-build-explained-part-1-59lf](https://zig.news/xq/zig-build-explained-part-1-59lf). It explains things more deeply and also tells you how to compile and work with C and C++ libraries. I used this post to learn and find information about some functions that Zig provides.
