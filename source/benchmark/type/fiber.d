module benchmark.type.fiber;

import benchmark.benchmark;
import benchmark.server, benchmark.client;
import std.socket, std.stdio, std.concurrency;
import core.thread;

class FiberBenchmark : AbstractBenchmark
{
    public:
        this(InternetAddress address)
        {
            super(address);
        }

        override void doBenchmark()
        {
            auto scheduler = new FiberScheduler;

            scheduler.start({
                auto server = new Server(address);
                auto serverSocket = server.start();
                auto sset = new SocketSet;

                for (;;sset.reset()) {
                    sset.add(serverSocket);
                    Fiber.yield;

                    if (Socket.select(sset, null, null) <= 0) {
                        writeln("End of server socket");
                        break;
                    }

                    if (sset.isSet(serverSocket)) {
                        auto clientSocket = serverSocket.accept();

                        Fiber.yield;
                        scheduler.spawn({
                            auto client = new Client(clientSocket);
                            Fiber.yield;
                            client.readRequest();
                            Fiber.yield;
                            client.writeAnswer();
                            Fiber.yield;
                            client.close();
                        });
                    }
                    Fiber.yield;
                }
            });
        }
}
