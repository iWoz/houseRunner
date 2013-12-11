import socket

srvsock = socket.socket( socket.AF_INET, socket.SOCK_STREAM )
srvsock.bind( ('localhost', 1991) )
srvsock.listen( 10 )

while 1:
    print("Connected one.")
    clisock, (remhost, remport) = srvsock.accept()
    print( remhost, remport )
    str = clisock.recv( 10 )
    print( "Recieved: " + str )
    clisock.send( str )
    print( "Sent: " + str )
    print( srvsock.gettimeout() )
    print( clisock.gettimeout() )

srvsock.close()
print( "Closed!!!" )
