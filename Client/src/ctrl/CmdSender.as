package ctrl
{
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
			
		}
		
		public function changeServer( ip:String, port:uint ):void
		{
			
		}

	}
}