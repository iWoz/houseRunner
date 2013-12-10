import socket

srvsock = socket.socket( socket.AF_INET, socket.SOCK_STREAM )
srvsock.bind( ('127.0.0.1', 1991) )
srvsock.listen( 1 )

while True:
    print("Connected one.")
    clisock, (remhost, remport) = srvsock.accept()
    print( remhost, remport )
    str = clisock.recv( 100 )
    print( "Recieved: " + str )
    clisock.send( "Hi, Client.\nThis is your message: " + str )
    clisock.close()
