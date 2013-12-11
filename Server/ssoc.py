import socket, select

s = socket.socket()

host = '10.253.58.61'
port = 1234
s.bind( (host, port) )

s.listen( 5 )
inputs = [s]

while True:
    rs, ws, es = select.select( inputs, [], [] )
    for r in rs:
        if r is s:
            c, addr = s.accept()
            print 'Got connection from', addr
            inputs.append( c )
        else:
            try:
                data = r.recv( 1024 )
                disconnected = not data
            except socket.error:
                disconnected = True

            if disconnected:
                print r.getpeername(), 'disconnected'
                inputs.remove( r )
            else:
                r.send( data )
                print data
s.close()
