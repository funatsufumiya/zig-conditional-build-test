# zig_conditional_build_test

Conditional build test with zig.

This shows conditionally include file or not. (In this case, embed file in compile time or not.)

## Run

```bash
$ zig build run # means: -Denable_embed=false
# or
$ zig build run -Denable_embed=true
```

## Code

### main.zig

```zig
const std = @import("std");
const options = @import("build_options");

const enable_embed = options.enable_embed;

// Conditionally embed the file based on build option
const embedded_content: ?[]const u8 = if (enable_embed) 
    @embedFile("embed.txt") 
else 
    null;

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Hello from main!\n", .{});
    if (enable_embed) {
        try stdout.print("Content: {s}\n", .{embedded_content.?});
    }else{
        try stdout.print("Embedding is disabled by build option. If you want to enable it, set the build option `-Denable_embed=true`\n", .{});
    }
}
```

### build.zig (partial)

```zig
const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Add a build option
    const embed_option = b.option(
        bool,
        "enable_embed",
        "Enable file embedding feature",
    ) orelse false;

    const options = b.addOptions();
    options.addOption(bool, "enable_embed", embed_option);

    const exe = b.addExecutable(.{
        .name = "zig_conditional_build_test",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    exe.root_module.addOptions("build_options", options);

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    run_step.dependOn(&run_cmd.step);
}
```
