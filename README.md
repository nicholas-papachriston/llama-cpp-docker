# Llama.cpp in Docker

Run [llama.cpp](https://github.com/ggerganov/llama.cpp) in a GPU accelerated
Docker container.

## Minimum requirements

By default, the service requires a CUDA capable GPU with at least 8GB+ of VRAM.

If you don't have an Nvidia GPU with CUDA then the CPU version will be built and
used instead (this is fine for Apple Silicon).

## Quickstart

model_list:
    - DeepSeek-R1-Distill-Qwen-7B-Q5_K_M

```bash
# sets the model file name
export MODEL_FILE=DeepSeek-R1-Distill-Qwen-7B-Q5_K_M.gguf
# builds the base image
make build
# downloads the given .gguf model file to ./models dir
make {model_list_item}
# start the inference and chat server
make up
```

After starting up the chat server will be available at `http://localhost:8080`.

## Options

Options are specified as environment variables in the `docker-compose.yml` file.
By default, the following options are set:

* `GGML_CUDA_NO_PINNED`: Disable pinned memory for compatability (default is 1)
* `LLAMA_ARG_CTX_SIZE`: The context size to use (default is 2048)
* `LLAMA_ARG_MODEL`: The name of the model to use (default is `/models/Meta-Llama-3.1-8B-Instruct-Q5_K_M.gguf`)
* `LLAMA_ARG_N_GPU_LAYERS`: The number of layers to run on the GPU (default is 99)

See the [llama.cpp documentation](https://github.com/ggerganov/llama.cpp/tree/master/examples/server)
for the complete list of server options.

## Models

The [`docker-entrypoint.sh`](docker-entrypoint.sh) has targets for downloading
popular models. Run `./docker-entrypoint.sh --help` to list available models.
Download models by running `./docker-entrypoint.sh <model>` where `<model>` is
the name of the model. By default, these will download the `_Q5_K_M.gguf`
versions of the models. These models are quantized to 5 bits which provide a
good balance between speed and accuracy.
