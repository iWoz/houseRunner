package data
{
	public class Packet
	{
		public var cmd:String;
		public var param:Object;
		
		public function Packet( cmd:String, param:Object )
		{
			this.cmd = cmd;
			this.param = param;
		}
		
		public function toJson():String
		{
			var o:Object = {};
			o.cmd = cmd;
			o.param = param;
			return JSON.stringify( o );
		}
	}
}