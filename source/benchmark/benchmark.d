module benchmark.benchmark;

import benchmark.client;
import std.socket, std.stdio;

abstract class AbstractBenchmark
{
    protected:
        InternetAddress address;
        BenchmarkPrinter benchmarkPrinter;
        uint delay = 0;

    public:
        this(InternetAddress address, BenchmarkPrinter benchmarkPrinter = null, uint delay = 0)
        {
            this.address = address;
            if (benchmarkPrinter is null) {
                benchmarkPrinter = new DefaultBenchmarkPrinter;
            }
            this.benchmarkPrinter = benchmarkPrinter;

            this.delay = delay;
        }

        abstract void doBenchmark();

        void shutdown(int value) {};
}

interface BenchmarkPrinter
{
    void onClientAccept(Client client);
}

class DefaultBenchmarkPrinter : BenchmarkPrinter
{
    protected:
        /// clients count threshold
        int threshold = 100;

        ulong clientAcceptCounter = 0;

    public:

        /// on client accept event counter
        void onClientAccept(Client client)
        {
            clientAcceptCounter++;
            if (clientAcceptCounter % threshold == 0) {
                write(".");
                stdout.flush();
            }
        }
}


