import socket, select
import json
import struct
import random

class Room:
	def __init__(self, id, name, width, height):
		self.id = id
		self.name = name
		self.width = width
		self.height = height
		self.doorX = width
		self.doorY1 = height / 2 - 5
		self.doorY2 = height / 2 + 5
		self.players = {}

	def broadcastAllPlayer( self, packet ):
		for pid in self.players:
			self.players[pid].sendPacket( packet )

	def broadcastAllPlayerPos( self ):
		param = {}
		for pid in self.players:
			p = self.players[pid]
			param[pid] = {'x':p.x, 'y':p.y}
		packet = Packet( 'updateAllPos', param )
		self.broadcastAllPlayer( packet )

	def handlerPlayerMove( self, playerid, x, y ):
		if self.canMove( playerid, x, y ):
			self.players[playerid].setPos( x, y )
			self.broadcastAllPlayerPos()

	def canMove( self, pid, x, y ):
		#out of bound
		if x <= 0 or y <= 0 or y >= self.height or (x >= self.width and (y > self.doorY2 or y < self.doorY1 ) ):
			return False
		#hit others
		for ppid in self.players:
			p = self.players[ppid]
			if pid != ppid and p.x == x and p.y == y:
				return False
		return True

	def getPlayerNum( self ):
		return len(self.players)

	def addPlayer( self, id, player ):
		self.players[id] = player
		player.room = self
		#set random pos for new player
		player.setPos( random.randint(0,self.width), random.randint(0,self.height) )

	def removePlayer( self, id ):
		p = self.players.pop( id, None )
		if p:
			p.room = None

class Player:
	def __init__( self, id, soc ):
		self.id = id
		self.soc = soc

	def setPos( self, x, y ):
		self.x = x
		self.y = y

	def sayHi( self ):
		self.sendPacket( Packet( 'hi', {"id":self.id} ) )

	def createRoom( self, room ):
		param = {}
		param['id'] = room.id
		param['name'] = room.name
		param['width'] = room.width
		param['height'] = room.height
		param['doorX'] = room.doorX
		param['doorY1'] = room.doorY1
		param['doorY2'] = room.doorY2
		packet = Packet( 'createRoom', param )
		self.sendPacket( packet )

	def sendPacket( self, packet ):
		msg = packet.getMsg()
		self.soc.send( struct.pack('!I', len(msg)) )
		self.soc.send( msg )
		print '>>>send: ', msg, " len:", len(msg), "to", self.soc.getpeername()


class Packet:
	def __init__(self, cmd, param):
		self.cmd = cmd
		self.param = param

	def getMsg( self ):
		return json.dumps( {"cmd":self.cmd,"param":self.param} )


###server start
server = socket.socket()

host = '192.168.3.104'
port = 3000
server.bind( (host, port) )

server.listen( 5 )
socs = [server]
rooms = {}
roomid = 1
players = {}
playerid = 1
pLen = {}

def sendPacketToAll( packet ):
	msg = packet.getMsg()
	msgLen = len(msg)
	print '>>>Send to All:', msg, " Len:", msgLen
	for soc in socs:
		if soc is server:
			pass
		else:
			soc.send( struct.pack('!I', msgLen) )
			soc.send( msg )

def removeClient( r ):
    print r.getpeername(), 'disconnected!!!'
    socs.remove(r)
    pLen.pop(r.getpeername(), None)

def handlePacket( cl, data ):
    print "==============\nrecieved data from", cl.getpeername(), data
    data = json.loads( data )
    if data['cmd'] == 'createRoom':
    	createRoom( data['param'] )
    elif data['cmd'] == 'joinRoom':
    	joinRoom( data['param'] )
    elif data['cmd'] == 'exitRoom':
    	exitRoom( data['param'] )
    elif data['cmd'] == 'move':
    	move( data['param'] )

def broadcastRoomList():
	if len(rooms) == 0:
		return
	param = {}
	for rid in rooms:
		r = rooms[rid]
		param[r.id] = { "id":r.id, "name":r.name, "num":r.getPlayerNum() }
	packet = Packet( "updateRoomList", param )
	sendPacketToAll( packet )

def createRoom( param ):
	global roomid
	r = Room( roomid, param['name'], param['width'], param['height'] )
	p = players[param['pid']]
	r.addPlayer( param['pid'], p )
	rooms[roomid] = r
	roomid = roomid + 1
	p.createRoom( r )
	r.broadcastAllPlayerPos()

def joinRoom( param ):
	r = rooms[param['rid']]
	if r:
		p = players[param['pid']]
		r.addPlayer( param['pid'], p )
		p.createRoom( r )
		r.broadcastAllPlayerPos()

def exitRoom( param ):
	pass

def move( param ):
	p = players[param['pid']]
	if p and p.room:
		r = p.room
		r.handlerPlayerMove( param['pid'], param['x'], param['y'] )



while True:
	rs, ws, es = select.select( socs, [], [] )
	for r in rs:
		if r is server:
			c, addr = server.accept()
			c.setblocking( 0 )
			socs.append( c )
			pLen[c.getpeername()] = 0
			p = Player(playerid, c)
			players[playerid] = p
			playerid += 1
			p.sayHi()
			broadcastRoomList()
		else:
			while True:
				rn = r.getpeername()
				if 0 == pLen[rn]:
					try:
						data = r.recv(4)
						if not data:
							removeClient( r )
							break
						else:
							pLen[rn] = int(struct.unpack("!I",data)[0])
					except socket.error:
						break
				else:
					try:
						data = r.recv(pLen[rn])
						if not data:
							break
						else:
							handlePacket( r, data )
							pLen[rn] = 0
					except socket.error:
						break

server.close()