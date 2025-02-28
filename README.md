## Environment setup

### Devcontainer
```bash
$ docker compose up -d
# attach to the container
```

### Manual
```bash
$ pip3 install meson ninja conan==1.53.0
$ conan profile new default --detect && \
  conan profile update settings.compiler.libcxx=libstdc++17 default
```

## Building
```console
$ cd src && mkdir build && cd build && cmake .. && make -j

$ ./bin/simba_decoder_test
```