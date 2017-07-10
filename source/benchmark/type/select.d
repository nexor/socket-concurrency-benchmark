module benchmark.type.select;

import benchmark.benchmark, benchmark.client, benchmark.server;
import core.thread;
import std.experimental.logger, std.socket;

class SelectBenchmark : AbstractBenchmark
{
    protected:
        Client[Socket] socketMap;
        Server server;

    public:
        /// constructor
        this(InternetAddress address)
        {
            super(address);
        }

        override void doBenchmark()
        {
            server = new Server(address);
            auto serverSocket = server.start();
            auto socketSet = new SocketSet;

            for (;; socketSet.reset()) {
                if (delay > 0) {
                    Thread.sleep(delay.msecs);
                }
                socketSet.add(serverSocket);
                foreach (Socket key, Client client; socketMap) {
                    socketSet.add(key);
                }

                if (Socket.select(socketSet, null, null) <= 0) {
                    infof("End of data transfer");
                    break;
                }

                foreach (Socket key, Client client; socketMap) {
                    if (socketSet.isSet(key)) {
                        processClientSocket(client);
                        client.close();
                        socketMap.remove(key);
                    }
                }
                if (socketSet.isSet(serverSocket)) {
                    processServerSocket(server);
                }
            }
        }

        override void shutdown(int value)
        {
            server.stop();
        }

    protected:

        void processServerSocket(Server s)
        {
            auto client = s.acceptClient();
            socketMap[client.getSocket()] = client;
            benchmarkPrinter.onClientAccept(client);
        }

        void processClientSocket(Client c)
        {
            c.readRequest();
            c.writeAnswer();
        }
}
