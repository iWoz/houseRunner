package data
{
	public class RoomDataMng
	{
		private static var inst:RoomDataMng;
		
		public var roomList:Vector.<RoomData>;
		
		public function RoomDataMng()
		{
			roomList = new Vector.<RoomData>;
		}
		
		public static function getInstance():RoomDataMng
		{
			if( !inst )
			{
				inst = new RoomDataMng;
			}
			return inst;
		}
		
		public function updateRoomList( list:Object ):void
		{
			roomList.splice( 0, roomList.length );
			var room:RoomData;
			for each( var r:Object in list )
			{
				room = new RoomData( r['id'], r['name'], r['num'] );
				roomList.push( room );
			}
		}
		
	}
}