package data
{
	import ctrl.CmdParser;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.OutputProgressEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;

	public class SocketMng
	{
		private static var inst:SocketMng;
		
		public var ip:String = "192.168.3.104";
		public var port:uint = 1234;
		
		private var soc:Socket;
		private var pLen:uint;
		
		public function SocketMng()
		{
			//init socket
			soc = new Socket();
			soc.addEventListener(Event.CONNECT, function( evt:Event ):void
			{
				trace( "Socket connected." );
			});
			soc.addEventListener(IOErrorEvent.IO_ERROR, function( evt:IOErrorEvent ):void
			{
				trace( evt.toString() );
			});
			soc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function( evt:SecurityErrorEvent ):void
			{
				trace( evt.toString() );
			});
			soc.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, function( evt:OutputProgressEvent ):void
			{
				trace( evt.bytesPending, "/", evt.bytesTotal );
			});
			soc.addEventListener(ProgressEvent.SOCKET_DATA, onParseData );
		}
		
		private function onParseData( evt:ProgressEvent ):void
		{
			trace( "Data Recieved! bytesAvailable:", soc.bytesAvailable, "pLen:", pLen );
			while( soc.bytesAvailable && soc.bytesAvailable >= pLen )
			{
				//若没有下一个包需要的长度，则从socket里面读取看是否有包存在，若满足，则读取并设置包长
				if( pLen == 0 )
				{
					if( soc.bytesAvailable > 4 )
					{
						pLen = soc.readUnsignedByte();
						trace("Got pLen:", pLen)
					}
					else
					{
						//此时退出循环，避免无限循环
						break;
					}
				}
				//若有下一个需要读取的包，则看socket缓存中是否满足这个包的长度，若满足则读取并解析包，若不满足则继续等待
				else
				{
					var newPacket:ByteArray = new ByteArray();
					soc.readBytes( newPacket, 0, pLen );
					var dataStr : String  = newPacket.readMultiByte( pLen, "utf-8" ) ;
					trace( ">>>Packet>>>: ", dataStr );
					newPacket.clear();
					var jsonData:Object = JSON.parse(dataStr);
					if (jsonData && jsonData.hasOwnProperty("cmd"))
					{
						CmdParser.getInstance().parse( jsonData );
					}
					pLen = 0;
				}
			}
		}
		
		private function getStringLengthInByte(str:String, bytecode:String): uint
		{
			var ba: ByteArray = new ByteArray();
			ba.writeMultiByte(str, bytecode);
			return ba.length;
		}
		
		private function sendPacket( p:Packet ):void
		{
			var msg:String = p.toJson();
			var msgLen:uint = getStringLengthInByte( msg, "utf-8" );
			trace(">>>Send to Server>>>: ", msg, "\nLen:", msgLen );
			soc.writeUnsignedInt( msgLen );
			soc.writeMultiByte( msg, "utf-8" );
			soc.flush();
		}
		
		public function closeSocket():void
		{
			soc.close();
		}
		
		public function connect( ip:String, port:uint ):void
		{
			soc.connect( ip, port );
		}
		
		public function get socket():Socket
		{
			return soc;
		}
		
		public function get localID():String
		{
			return "('"+soc.localAddress+"', "+soc.localPort+")";
		}
		
		public static function getInstance():SocketMng
		{
			if( !inst )
			{
				inst = new SocketMng;
			}
			return inst;
		}
		
	}
}