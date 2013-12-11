import socket, select
import json
import random

s = socket.socket()

host = '192.168.3.104'
port = 1201
s.bind( (host, port) )

s.listen( 5 )
inputs = [s]
idx = 0
men = {}

def updateAll():
    allPos = {}
    for id in men:
        allPos[str(id)] = men[id]
    data = {"cmd":"update","param":allPos}
    for cs in inputs:
        if cs is s:
            pass
        else:
            try:
                cs.send(json.dumps(data))
            except socket.error:
                print c.getpeername(), 'Got Problem.'

while True:
    rs, ws, es = select.select( inputs, [], [] )
    for r in rs:
        if r is s:
            c, addr = s.accept()
            print 'Got connection from', addr
            inputs.append( c )
            print 'New socket', c.getpeername()
            men[c.getpeername()] = {'id':idx, 'x':random.randint(100,300), 'y':random.randint(100,300)}
            idx += 1
        else:
            try:
                data = r.recv( 1024 )
                disconnected = not data
            except socket.error:
                disconnected = True

            if disconnected:
                print r.getpeername(), 'disconnected'
                inputs.remove( r )
                men.pop(r.getpeername())
            else:
                data = json.loads( data )
                print( data )
                if data['cmd'] == 'init':
                    pass
                elif data['cmd'] == 'move':
                    men[r.getpeername()]['x'] = data['param']['x']
                    men[r.getpeername()]['y'] = data['param']['y']
                updateAll()
s.close()
