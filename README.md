# ZigGameKit

A game framework in Zig for the [WASM-4](https://wasm4.org) fantasy console. 
Requires a fork of WASM-4 that supports unix timestamp such as: https://github.com/Tewesday/wasm4.

## Building

Build the cart by running:

```shell
zig build -Doptimize=ReleaseSmall
```

Then run it with:

```shell
w4 run zig-out/bin/cart.wasm
```

For more info about setting up WASM-4, see the [quickstart guide](https://wasm4.org/docs/getting-started/setup?code-lang=zig#quickstart).

