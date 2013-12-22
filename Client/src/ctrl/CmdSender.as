package ctrl
{
	import data.Packet;
	import data.SocketMng;

	public class CmdSender
	{
		private static var inst:CmdSender;
		public function CmdSender()
		{
		}
		
		public static function getInstance():CmdSender
		{
			if( !inst )
			{
				inst = new CmdSender;
			}
			return inst;
		}
		
		public function createRoom( roomName:String, width:uint, height:uint ):void
		{
			var param:Object = {};
			param["name"] = roomName;
			param["width"] = width;
			param["height"] = height;
			param["pid"] = SocketMng.getInstance().id;
			
			var packet:Packet = new Packet( "createRoom", param );
			SocketMng.getInstance().sendPacket( packet );
		}
		
		public function joinRoom( roomId:uint ):void
		{
			var param:Object = {};
			param["rid"] = roomId;
			param["pid"] = SocketMng.getInstance().id;
			
			var packet:Packet = new Packet( "joinRoom", param );
			SocketMng.getInstance().sendPacket( packet );
		}
		
		public function move( x:uint, y:uint ):void
		{
			var param:Object = {};
			param["x"] = x;
			param["y"] = y;
			param["pid"] = SocketMng.getInstance().id;
			
			var packet:Packet = new Packet( "move", param );
			SocketMng.getInstance().sendPacket( packet );

		}
		
		public function changeServer( ip:String, port:uint ):void
		{
			
		}

	}
}