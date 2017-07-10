module benchmark.type.thread;

import benchmark.benchmark, benchmark.client, benchmark.server;
import core.thread;
import std.socket, std.stdio;

class ThreadBenchmark : AbstractBenchmark
{
    public:
        this(InternetAddress address)
        {
            super(address);
        }

        override void doBenchmark()
        {
            auto server = new Server(address);

            server.start();
            
            int i = 1;

            while (true) {
                if (delay > 0) {
                    Thread.sleep(delay.msecs);
                }
                auto client = server.acceptClient();
                benchmarkPrinter.onClientAccept(client);

                new ClientThread(client).start();
            }
        }
}

class ClientThread : Thread
{
    protected:
        Client client;
        int num;

    public:
        this(Client client) 
        {
            this.client = client;
            super(&run);
        }

    private:
        void run()
        {
            client.run();
        }
}