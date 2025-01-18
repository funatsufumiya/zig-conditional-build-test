# zig_conditional_build_test

Conditional build test with zig.

This shows conditionally include file or not. (In this case, embed file in compile time or not.)

## Run

```bash
$ zig build run # means: -Denable_embed=false
# or
$ zig build run -Denable_embed=true
```