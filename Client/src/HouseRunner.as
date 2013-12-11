package
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.OutputProgressEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	public class HouseRunner extends Sprite
	{
		private var soc:Socket;
		private var list:Dictionary = new Dictionary;
		private var ownIdx:int = -1;
		
		public function HouseRunner()
		{
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
			soc.addEventListener(ProgressEvent.SOCKET_DATA, function( evt:ProgressEvent ):void
			{
				trace( "Data Recieved!!!", soc.bytesAvailable );
				while( soc.bytesAvailable )
				{
					var a:String = soc.readUTFBytes( soc.bytesAvailable );
					var data:Object = JSON.parse( a );
					trace( a, data )
					if( data.hasOwnProperty("cmd") && data.cmd == "update" )
					{
						onUpdate( data.param );
					}
				}
			});
			
			soc.connect( "192.168.3.104", 1201 );
			
			var house:Shape = new Shape();
			house.graphics.lineStyle( 1 );
			house.graphics.moveTo(0,0);
			house.graphics.lineTo(200,0);
			house.graphics.lineTo(200,200);
			house.graphics.lineTo(0,200);
			house.graphics.lineTo(0,0);
			house.graphics.endFill();
			
			addChild( house );
			house.x = house.y = 100;
			
			init();
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, function onKeyBoard( evt:KeyboardEvent ):void
			{
				trace( soc.bytesAvailable, soc.connected, soc.remoteAddress, soc.remotePort, soc.localAddress, soc.localPort );
				var self:Shape = list[ownIdx];
				if( evt.keyCode == Keyboard.DOWN )
				{
					sendPacket( new Packet( "move", {x:self.x, y:++self.y} ) )
				}
				else if( evt.keyCode == Keyboard.UP )
				{
					sendPacket( new Packet( "move", {x:self.x, y:--self.y} ) )
				}
				else if( evt.keyCode == Keyboard.LEFT )
				{
					sendPacket( new Packet( "move", {x:--self.x, y:self.y} ) )
				}
				else if( evt.keyCode == Keyboard.RIGHT )
				{
					sendPacket( new Packet( "move", {x:++self.x, y:self.y} ) )
				}
				else if( evt.keyCode == Keyboard.ESCAPE )
				{
					soc.close();
				}
			});
			
			var a:Function = str;
			trace( a( "This works!!!" ) );
			
			/**
			 * 1.包的发放和解析规则
			 * 2.获取所有人的位置
			 * 3.在本机器上移动，在另一台机器上看到同步移动
			 * */
		}
		
		private function str( a:String ):void
		{
			trace( a );
		}
		
		private function createMan():Shape
		{
			var man:Shape = new Shape;
			man.graphics.beginFill(0);
			man.graphics.drawCircle(0,0,5);
			man.graphics.endFill();
			return man;
		}
		
		private function onUpdate( data:Object ):void
		{
			trace(">>>onUpdate")
			var man:Object;
			for ( var manKey:String in data )
			{
				man = data[manKey];
				if( ownIdx == -1 && "('"+soc.localAddress+"', "+soc.localPort+")" == manKey )
				{
					ownIdx = man.id;
				}
				if( !list[man.id] )
				{
					list[man.id] = createMan();
					addChild( list[man.id] as Shape );
				}
				list[man.id].x = man.x;
				list[man.id].y = man.y;
				trace( man.id, man.x, man.y );
			}
		}
		
		private function getStringLengthInByte(str: String, bytecode: String): uint
		{
			var ba: ByteArray = new ByteArray();
			ba.writeMultiByte(str, bytecode);
			return ba.length;
		}
		
		private function sendPacket( p:Packet ):void
		{
			var msg:String = p.toJson();
			var msgLen:uint = getStringLengthInByte( msg, "utf-8" );
			//soc.writeUnsignedInt( msgLen );
			soc.writeMultiByte( msg, "utf-8" );
			soc.flush();
		}
		
		private function init():void
		{
			sendPacket( new Packet("init", {} ) );
		}
	}
}

class Packet
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