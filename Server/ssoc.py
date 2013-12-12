import socket, select
import json
import random
import struct

s = socket.socket()

host = '192.168.3.104'
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
    print r.getpeername(), 'disconnected'
    inputs.remove(r)
    men.pop(r.getpeername())
    pLen.pop(r.getpeername())

def handlePacket( data ):
    print "==============\nrecieved data from", r.getpeername(), data
    data = json.loads( data )
    if data['cmd'] == 'init':
        pass
    elif data['cmd'] == 'move':
        men[r.getpeername()]['x'] = data['param']['x']
        men[r.getpeername()]['y'] = data['param']['y']
    updateAll()

while True:
    rs, ws, es = select.select( inputs, [], [] )
    for r in rs:
        if r is s:
            c, addr = s.accept()
            print 'Got connection from', addr
            inputs.append( c )
            print 'New socket', c.getpeername()
            men[c.getpeername()] = {'id':idx, 'x':random.randint(100,300), 'y':random.randint(100,300)}
            pLen[c.getpeername()] = 0
            idx += 1
        else:
            data = 1
            while data:
                if pLen[r.getpeername()] == 0:
                    data = r.recv(4)
                    if not data:
                        removeClient( r )
                        break
                    else:
                        pLen[r.getpeername()] = int(struct.unpack("!I",data)[0])
                else:
                    data = r.recv(pLen[r.getpeername()])
                    if not data:
                        break
                    else:
                        handlePacket( data )
                        pLen[r.getpeername()] = 0

s.close()
