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
Compilation options:
`dub build --build=release-nobounds`

### Thread
`$ ./socket-concurrency-benchmark --type=thread`

```
Concurrency Level:      20
Time taken for tests:   1.580 seconds
Complete requests:      5000
Failed requests:        0
Total transferred:      315000 bytes
HTML transferred:       0 bytes
Requests per second:    3165.25 [#/sec] (mean)
Time per request:       6.319 [ms] (mean)
Time per request:       0.316 [ms] (mean, across all concurrent requests)
Transfer rate:          194.74 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    3  37.3      1    1001
Processing:     0    3  10.3      2     408
Waiting:        0    3  10.2      1     407
Total:          0    6  38.7      3    1003
```

### Select
`$ ./socket-concurrency-benchmark --type=select`

```
Concurrency Level:      20
Time taken for tests:   1.244 seconds
Complete requests:      5000
Failed requests:        0
Total transferred:      315000 bytes
HTML transferred:       0 bytes
Requests per second:    4020.43 [#/sec] (mean)
Time per request:       4.975 [ms] (mean)
Time per request:       0.249 [ms] (mean, across all concurrent requests)
Transfer rate:          247.35 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    2   0.6      2       6
Processing:     0    3   4.1      2     203
Waiting:        0    2   4.1      2     203
Total:          1    5   4.1      5     204
```

### Fiber
`$ ./socket-concurrency-benchmark --type=fiber`

```
Concurrency Level:      20
Time taken for tests:   1.265 seconds
Complete requests:      5000
Failed requests:        0
Total transferred:      315000 bytes
HTML transferred:       0 bytes
Requests per second:    3953.72 [#/sec] (mean)
Time per request:       5.059 [ms] (mean)
Time per request:       0.253 [ms] (mean, across all concurrent requests)
Transfer rate:          243.25 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    3  34.6      1    1001
Processing:     0    2   8.3      2     207
Waiting:        0    2   8.2      2     206
Total:          1    5  35.6      3    1005
```

### Summary

|type|requests/sec|
|----|------------|
|thread|3165|
|select|4020|
|fiber|3953|