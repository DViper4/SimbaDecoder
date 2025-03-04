## Environment setup

### Manual
```bash
$ pip3 install meson ninja conan==1.53.0
$ conan profile new default --detect && \
  conan profile update settings.compiler.libcxx=libstdc++17 default
```
### Python setup (for PnL calculation)
```bash
$ pip3 install pandas
$ pip3 install matplotlib
```

## Building
```console
$ cd src && mkdir build && cd build && cmake .. && make -j

$ ./bin/simba_decoder_test
```
