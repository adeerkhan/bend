# Building for the GPU

The lanes are described in the guide (a `!` call is the GPU's); this is
the build recipe that gets a binary there. Everything below is what
`cli_build` in `bend2/main.ts` does, spelled out.

## Finding a toolkit

On Linux a `!` program needs clang 19+ and CUDA 12 or 13. The compiler
takes the first of `$CUDA_HOME`, `$CUDA_PATH`, `/usr/local/cuda` and
`/opt/cuda` (Arch's) that holds **`include/nvrtc.h`** — that file is the
marker; a directory that exists is not enough. A user-unpacked toolkit
works: point `$CUDA_HOME` at the directory that holds `include/nvrtc.h`
and its libraries.

## What the build does

It compiles the C with `-DBEND_CUDA=1 -I <cuda>/include -L <cuda>/lib64
-L <cuda>/lib ... -lcuda -lnvrtc` (the libraries live in `lib64` in
normal installs and in `lib` as nix lays them), then runs the binary
once with `+RTS --gpu-build`, which writes the device program beside it
as `file.gpu`. That file must stay beside the binary.

## Running it

The loader needs `libcuda.so.1` (the driver's) and `libnvrtc.so.13` at
run time. With a system install they resolve; with a user-unpacked
toolkit set

```bash
LD_LIBRARY_PATH=$CUDA_HOME/lib64 ./file
```

or the binary dies with `libnvrtc.so.13: cannot open shared object
file`. `--gpu off` runs the `!` calls on the CPU cores at runtime, and
`--gpu 4GB` caps the GPU heap.

## Which lane ran

When no toolkit is found, **the build still succeeds** and every `!`
call runs on the CPU cores — silently, with no message. To tell which
lane a binary was built for, ask the loader:

```bash
ldd file | grep -E 'cuda|nvrtc'   # CPU-only build: no lines at all
```

A GPU build links both; a CPU build links neither.
