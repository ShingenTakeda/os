const std = @import("std");

const targets: []const std.Target.Query = &.{
    .{ .cpu_arch = .riscv32, .os_tag = .freestanding, .abi = .none },
};

pub fn build(b: *std.Build) !void {
    for (targets) |t| {
        const exe = b.addExecutable(.{
            .name = "hello.bin",
            .root_source_file = .{ .path = "src/main.zig" },
            .target = b.resolveTargetQuery(t),
            .optimize = .ReleaseSafe,
        });

        exe.setLinkerScriptPath(.{ .path = "linker.ld" });

        const target_output = b.addInstallArtifact(exe, .{
            .dest_dir = .{
                .override = .{
                    .custom = try t.zigTriple(b.allocator),
                },
            },
        });

        b.getInstallStep().dependOn(&target_output.step);
    }
}
