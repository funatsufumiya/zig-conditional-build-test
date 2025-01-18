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
    if (enable_embed) {
        try stdout.print("Content: {s}\n", .{embedded_content.?});
    }else{
        try stdout.print("Embedding is disabled by build option. If you want to enable it, set the build option `-Denable_embed=true`\n", .{});
    }
}