# Socket concurrency benchmark

This is a simple benchmark of three different socket concurrency implementations: thread, socket select loop and fiber.

## Install

You can clone the repo and build project using `dub` following three simple commands:
```
$ git clone https://github.com/nexor/socket-concurrency-benchmark.git
$ cd socket-concurrency-benchmark
$ dub build
```

Run program without any options to see help text:
```
$ ./socket-concurrency-benchmark
Concurrent sockets reading/writing benchmark version 0.0.1.

Usage: socket-concurrency-benchmark [OPTIONS]
   --address [IP address] Address to connect to for data receiving (127.0.0.1 by default).
      --port [1..65535] Port number to connect to (1085 by default).
      --type [thread|fiber|select] socket handling concurrency type.
   --backlog [uint] Server socket backlog size (10 by default).
-V --version Print version and exit.
-v --verbose [0..3] Use verbose output level. Available levels: 0(default, least verbose), 1, 2, 3(most verbose).
-h    --help This help information.
```


## Benchmark result example

All benchmarks was performed by following line:
`ab -n 5000 -c 20 http://127.0.0.1:1085/`

### Thread
`$ ./socket-concurrency-benchmark --type=thread`

```
Concurrency Level:      20
Time taken for tests:   1.661 seconds
Complete requests:      5000
Failed requests:        0
Total transferred:      315000 bytes
HTML transferred:       0 bytes
Requests per second:    3010.96 [#/sec] (mean)
Time per request:       6.642 [ms] (mean)
Time per request:       0.332 [ms] (mean, across all concurrent requests)
Transfer rate:          185.24 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    3  37.3      1     999
Processing:     0    3   9.6      2     250
Waiting:        0    2   9.6      1     249
Total:          0    6  38.5      3    1002

```

### Select
`$ ./socket-concurrency-benchmark --type=select`

```
Concurrency Level:      20
Time taken for tests:   1.157 seconds
Complete requests:      5000
Failed requests:        0
Total transferred:      315000 bytes
HTML transferred:       0 bytes
Requests per second:    4320.93 [#/sec] (mean)
Time per request:       4.629 [ms] (mean)
Time per request:       0.231 [ms] (mean, across all concurrent requests)
Transfer rate:          265.84 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    2   0.6      2       6
Processing:     1    2   4.1      2     204
Waiting:        0    2   4.1      2     204
Total:          2    4   4.2      4     205
```

### Fiber
`$ ./socket-concurrency-benchmark --type=fiber`

```
Concurrency Level:      20
Time taken for tests:   1.219 seconds
Complete requests:      5000
Failed requests:        0
Total transferred:      315000 bytes
HTML transferred:       0 bytes
Requests per second:    4103.31 [#/sec] (mean)
Time per request:       4.874 [ms] (mean)
Time per request:       0.244 [ms] (mean, across all concurrent requests)
Transfer rate:          252.45 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    3  34.6      1    1000
Processing:     1    2   5.2      2     208
Waiting:        0    2   5.1      2     206
Total:          1    5  35.0      3    1005
```

### Summary

|type|requests/sec|
|----|------------|
|thread|3010|
|select|4320|
|fiber|4103|