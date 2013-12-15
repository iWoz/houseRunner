package ctrl
{
	public class CmdParser
	{
		private static var inst:CmdParser;
		
		private const CMD_FUNC_MAP:Object = 
			{
				"updateRoomList" : updateRoomList,
				"updateAllPos" : updateRoomList
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
		
		public function updateRoomList( data:Object ):void
		{
			
		}
		
	}
}