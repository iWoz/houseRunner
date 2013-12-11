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
	
	public class HouseRunner extends Sprite
	{
		public function HouseRunner()
		{
			var soc:Socket = new Socket();
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
					trace( a, a.length );					
				}
			});
			
			soc.connect( "localhost", 1234 );
			soc.writeMultiByte( "Hello, Python.", "utf-8" );
			soc.flush();
			
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
			
			var man:Shape = new Shape;
			man.graphics.beginFill(0);
			man.graphics.drawCircle(0,0,5);
			man.graphics.endFill();
			
			addChild( man );
			man.x = man.y = 200;
			
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, function onKeyBoard( evt:KeyboardEvent ):void
			{
				trace( soc.bytesAvailable, soc.connected, soc.remoteAddress, soc.remotePort, soc.localAddress, soc.localPort );
				if( evt.keyCode == Keyboard.DOWN )
				{
					++man.y;
					soc.writeMultiByte( "Down.", "utf-8" );
					soc.flush();
				}
				else if( evt.keyCode == Keyboard.UP )
				{
					--man.y;
					soc.writeMultiByte( "Up.", "utf-8" );
					soc.flush();
				}
				else if( evt.keyCode == Keyboard.LEFT )
				{
					--man.x;
					soc.writeMultiByte( "Left", "utf-8" );
					soc.flush();
				}
				else if( evt.keyCode == Keyboard.RIGHT )
				{
					++man.x;
					soc.writeMultiByte( "Right", "utf-8" );
					soc.flush();
				}
				else if( evt.keyCode == Keyboard.ESCAPE )
				{
					soc.writeUTF("Esc.")
					soc.close();
				}
			});
			
			/**
			 * 1.包的发放和解析规则
			 * 2.获取所有人的位置
			 * 3.在本机器上移动，在另一台机器上看到同步移动
			 * */
			
			
		}
	}
}