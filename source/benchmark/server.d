module benchmark.server;

import std.socket, std.stdio;
import benchmark.client;

class Server
{
    protected:
        InternetAddress listenAddress;
        Socket          serverSocket;
        uint            backlog;

    public:

        this(InternetAddress listenAddress, uint backlog = 10)
        {
            this.listenAddress = listenAddress;
            this.backlog = backlog;
        }

        /// start server
        Socket start()
        {
            serverSocket = new TcpSocket;
            assert(serverSocket.isAlive);
            serverSocket.bind(listenAddress);
            serverSocket.listen(backlog);
            writeln("Listening on " ~ listenAddress.toString());

            return serverSocket;
        }

        void stop()
        {
            serverSocket.close();
        }

        Client acceptClient()
        {
            auto clientSocket = serverSocket.accept();
            assert(clientSocket.isAlive);
            auto client = new Client(clientSocket);

            return client;
        }
}