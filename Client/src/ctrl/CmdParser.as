package ctrl
{
	import data.RoomDataMng;
	import data.SocketMng;
	
	import flash.geom.Point;
	
	import view.GameView;

	public class CmdParser
	{
		private static var inst:CmdParser;
		
		private const CMD_FUNC_MAP:Object = 
			{
				"hi" : initPlayer,
				"updateRoomList" : updateRoomList,
				"createRoom" : createRoom,
				"updateAllPos" : updateAllPos
			};
		public function CmdParser()
		{
		}
		
		public static function getInstance():CmdParser
		{
			if( !inst )
			{
				inst = new CmdParser;
			}
			return inst;
		}
		
		public function parse( data:Object ):void
		{
			if( CMD_FUNC_MAP.hasOwnProperty(data["cmd"]) )
			{
				CMD_FUNC_MAP[data["cmd"]]( data["param"] );
			}
		}
		
		public function initPlayer( data:Object ):void
		{
			SocketMng.getInstance().id = data["id"];
			trace( "init player, player id:", data["id"] );
		}
		
		public function updateRoomList( data:Object ):void
		{
			RoomDataMng.getInstance().updateRoomList( data );
			GameView.getInstance().updateRoomList();
		}
		
		public function createRoom( data:Object ):void
		{
			GameView.getInstance().doCreateRoom( data['width'], data['height'],
				new Point(data['doorX'], data['doorY1']), new Point(data['doorX'], data['doorY2']) );
		}
		
		public function updateAllPos( data:Object ):void
		{
			GameView.getInstance().room.updateAllPlayerPos( data );
		}
		
	}
}