package data
{
	public class RoomData
	{
		public var id:uint;
		public var name:String;
		public var playerNum:uint;
		
		public function RoomData( id:uint, name:String, playerNum:uint )
		{
			this.id = id;
			this.name = name;
			this.playerNum = playerNum;
		}
		
		public function toString():String
		{
			return "房间名："+this.name+"\t"+"人数："+this.playerNum;
		}
		
	}
}