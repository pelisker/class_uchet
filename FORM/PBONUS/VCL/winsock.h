// -- general --
#DEFINE CRLF  CHR(13)+CHR(10)
#DEFINE DCRLF CRLF+CRLF

// -- winsock --
#DEFINE WINSOCK_VER 0x0202
#DEFINE AF_INET       2
#DEFINE SOCK_STREAM   1
#DEFINE IPPROTO_TCP   6
#DEFINE SOCKET_ERROR -1

#DEFINE WSAEWOULDBLOCK 10035
#DEFINE WSAENOTCONN 10057

#DEFINE FD_READ       1
#DEFINE FD_WRITE      2
#DEFINE FD_OOB        4
#DEFINE FD_ACCEPT     8
#DEFINE FD_CONNECT  0x10
#DEFINE FD_CLOSE    0x20

#DEFINE WSA_WAIT_FAILED -1
#DEFINE WSA_WAIT_TIMEOUT 0x0102
#DEFINE WSA_INFINITE 0xFFFFFFFF

#DEFINE SOCKET_ERROR    -1
#DEFINE SOL_SOCKET   0xFFFF  && Options for socket level

#DEFINE SO_DEBUG         1  && Turn on debugging info recording
#DEFINE SO_ACCEPTCONN    2  && Socket has had listen() - READ-ONLY
#DEFINE SO_REUSEADDR     4  && Allow local address reuse
#DEFINE SO_KEEPALIVE     8  && Keep connections alive
#DEFINE SO_DONTROUTE    16  && Just use interface addresses
#DEFINE SO_BROADCAST    32  && Permit sending of broadcast msgs
#DEFINE SO_USELOOPBACK  64  && Bypass hardware when possible
#DEFINE SO_LINGER      128  && Linger on close if data present
#DEFINE SO_OOBINLINE   256  && Leave received OOB data in line
#DEFINE SO_SNDBUF     4097  && send-buffer size
#DEFINE SO_RCVBUF     4098  && receive-buffer size
#DEFINE SO_ERROR      4103  && Get error status and clear
#DEFINE SO_TYPE       4104  && Get socket type - READ-ONLY
