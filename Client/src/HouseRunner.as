package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.OutputProgressEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	
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
					soc.flush();
					var a:String = soc.readUTFBytes( soc.bytesAvailable );
					trace( a, a.length );					
				}
			});
			
			soc.connect( "127.0.0.1", 1991 );
			soc.writeUTF( "Hello, Python." );
			soc.writeUnsignedInt(1991);
			soc.flush();
		}
	}
}