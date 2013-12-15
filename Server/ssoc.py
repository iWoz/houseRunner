import socket, select
import json
import random
import struct

s = socket.socket()

host = '192.168.3.100'
port = 1201
s.bind( (host, port) )

s.listen( 5 )
inputs = [s]
idx = 0
men = {}
pLen = {}

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
                smsg = json.dumps(data)
                cs.send(struct.pack('!I',len(smsg)))
                cs.send(smsg)
                print '\nsend: ', smsg, "len:", len(smsg), "to", c.getpeername()
            except socket.error:
                print c.getpeername(), 'Got Problem.'

def removeClient( r ):
    print r.getpeername(), 'disconnected!!!'
    inputs.remove(r)
    men.pop(r.getpeername())
    pLen.pop(r.getpeername())

def handlePacket( cl, data ):
    print "==============\nrecieved data from", cl.getpeername(), data
    data = json.loads( data )
    if data['cmd'] == 'init':
        pass
    elif data['cmd'] == 'move':
        men[cl.getpeername()]['x'] = data['param']['x']
        men[cl.getpeername()]['y'] = data['param']['y']
    updateAll()

while True:
    rs, ws, es = select.select( inputs, [], [] )
    for r in rs:
        if r is s:
            c, addr = s.accept()
            c.setblocking(0)
            print 'Got connection from', addr
            inputs.append( c )
            print 'New socket', c.getpeername()
            men[c.getpeername()] = {'id':idx, 'x':random.randint(100,300), 'y':random.randint(100,300)}
            idx += 1
            pLen[c.getpeername()] = 0
        else:
            while True:
                print "Handling ", r.getpeername(), "pLen = ", pLen[r.getpeername()]
                if pLen[r.getpeername()] == 0:
                    try:
                        data = r.recv(4)
                        print "pLen = 0 data = ", data, "data len:", len(data)
                        if not data:
                            print "break in no data len."
                            removeClient( r )
                            break
                        else:
                            pLen[r.getpeername()] = int(struct.unpack("!I",data)[0])
                    except socket.error:
                        print "break in no data len."
                        break
                else:
                    try:
                        data = r.recv(pLen[r.getpeername()])
                        print "pLen = ", pLen[r.getpeername()], " data = ",data
                        if not data:
                            print "break in no data received."
                            break
                        else:
                            handlePacket( r, data )
                            pLen[r.getpeername()] = 0
                    except socket.error:
                        print "break in no data received."
                        break

s.close()
