module benchmark.client;

import std.socket;
import std.experimental.logger;

class Client
{
    protected:
        Socket       socket;

    public:
        this(Socket clientSocket)
        {
            socket = clientSocket;
        }

        Socket getSocket()
        {
            return socket;
        }

        final void run()
        {
            readRequest();
            writeAnswer();
            socket.close();
        }

        /// read initial request headers
        ptrdiff_t readRequest()
        {
            char[256] buffer;
            ptrdiff_t received = socket.receive(buffer);

            if (received == Socket.ERROR) {
                warningf("Connection error on clientSocket.");
            } else if (received == 0) {
                infof("Client connection closed.");
            }

            return received;
        }

        void writeAnswer()
        {
            string answer = "HTTP/1.1 200 OK\r\n" ~
                            "Server: dlang-benchmark\r\n" ~
                            "Content-Length: 0\r\n\r\n";

            socket.send(answer);
        }

        void close()
        {
            socket.close();
        }
}
