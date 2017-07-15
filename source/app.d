import std.stdio, std.getopt;
import std.experimental.logger;

immutable string versionString = "0.0.1";
immutable string defaultAddress = "127.0.0.1";
immutable ushort defaultPort = 1085;
immutable uint   defaultBacklog = 10;

enum ProcessType {
    thread,
    fiber,
    select
}

ushort port = defaultPort;
string address = defaultAddress;
uint   backlog = defaultBacklog;
ProcessType type;

byte   verbosity; // log verbosity level
bool   ver;

/**
 * Benchmark for socket reading and writing.
 *   - concurrency
 *   - select loop
 *   - threads
 */
int main(string[] args)
{
    if (processHelpInformation(args)) {
        return 0;
    }

    switch (verbosity) {
        case 0:
            sharedLog.logLevel = LogLevel.critical;
            break;
        case 1:
            sharedLog.logLevel = LogLevel.warning;
            break;
        case 2:
            sharedLog.logLevel = LogLevel.info;
            break;
        case 3:
            sharedLog.logLevel = LogLevel.trace;
            break;
        default:
            sharedLog.logLevel = LogLevel.critical;
            warningf("Unknown verbosity level: %d", verbosity);
    }

    startBenchmark(address, port, type);

    return 0;
}

void startBenchmark(string addr, ushort port, ProcessType type)
{
    import std.socket;
    import benchmark.benchmark;
    import benchmark.type.fiber;
    import benchmark.type.select;
    import benchmark.type.thread;

    InternetAddress address = new InternetAddress(addr, port);
    AbstractBenchmark tester;

    final switch (type) {
        case ProcessType.thread:
            tester = new ThreadBenchmark(address);
            break;
        case ProcessType.fiber:
            tester = new FiberBenchmark(address);
            break;
        case ProcessType.select:
            tester = new SelectBenchmark(address);
            break;
    }

    writefln("Benchmark type: %s", type);

    tester.doBenchmark();
}


bool processHelpInformation(string[] args)
{
    import std.conv, std.file, std.path;
    const string helpString = "Concurrent sockets reading/writing benchmark version " ~ versionString ~ ".\n\n" ~
        "Usage: " ~ thisExePath().relativePath() ~ " [OPTIONS]";

    auto helpInformation = getopt(args,
        std.getopt.config.caseSensitive,
        "address", "[IP address] Address to connect to for data receiving (" ~ defaultAddress ~ " by default).",   &address,
        "port",    "[1..65535] Port number to connect to (" ~ to!string(defaultPort) ~ " by default).", &port,
        "type",    "[thread|fiber|select] socket handling concurrency type.",  &type,
        "backlog", "[uint] Server socket backlog size (" ~ defaultBacklog.to!string ~ " by default).", &backlog,

        "version|V",  "Print version and exit.",     &ver,
        "verbose|v",  "[0..3] Use verbose output level. Available levels: " ~
            "0(default, least verbose), 1, 2, 3(most verbose).",         &verbosity
    );

    if (ver) {
        writefln("Benchmark version %s", versionString);

        return true;
    }

    if (helpInformation.helpWanted || type == ProcessType.init) {
        defaultGetoptPrinter(helpString, helpInformation.options);
        return true;
    }

    return false;
}
