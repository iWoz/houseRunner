package view
{
	import ctrl.CmdSender;
	
	import data.SocketMng;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	public class Room extends Sprite
	{
		private var frame:Sprite;
		private var players:Object;
		
		public function Room( width:uint, height:uint, doorPos1:Point, doorPos2:Point )
		{
			super();
			frame = new Sprite;
			frame.graphics.lineStyle( 1, 0xff0000 );
			frame.graphics.beginFill( 0xcccccc );
			frame.graphics.drawRect( 0, 0, width, height );
			frame.graphics.endFill();
			addChild( frame );
			
			var door:Shape = new Shape;
			door.graphics.lineStyle( 2, 0x00ff00 );
			door.graphics.moveTo( doorPos1.x, doorPos1.y );
			door.graphics.lineTo( doorPos2.x, doorPos2.y );
			door.graphics.endFill();
			frame.addChild( door );
			
			players = {};
			
			GameView.getInstance().stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyBoard, true, 999 );
		}
		
		private function handleKeyBoard( e:KeyboardEvent ):void
		{
			var self:Shape = players[SocketMng.getInstance().id];
			if( !self )
			{
				return;
			}
			var delta:uint = 3;
			trace( e.keyCode, e.type );
			switch( e.keyCode )
			{
				case Keyboard.ESCAPE:
					trace( "on esc" );
					break;
				case Keyboard.UP:
					CmdSender.getInstance().move( self.x, self.y - delta );
					trace( "go up" );
					break;
				case Keyboard.DOWN:
					CmdSender.getInstance().move( self.x, self.y + delta );
					trace( "go down" );
					break;
				case Keyboard.LEFT:
					CmdSender.getInstance().move( self.x - delta, self.y );
					trace( "go left" );
					break;
				case Keyboard.RIGHT:
					CmdSender.getInstance().move( self.x + delta, self.y );
					trace( "go right" );
					break;
			}
		}
		
		public function updateAllPlayerPos( data:Object ):void
		{
			var pid:uint = 0;
			for ( var id:String in data )
			{
				pid = uint(id);
				if( !players[pid] )
				{
					players[pid] = createRole( pid );
				}
				frame.addChild( players[pid] );
				players[pid].x = data[id]['x'];
				players[pid].y = data[id]['y'];
			}
		}
		
		private function createRole( id:uint ):Shape
		{
			var r:Shape = new Shape;
			if( id == SocketMng.getInstance().id )
			{
				r.graphics.beginFill( 0x00ff00 );
			}
			else
			{
				r.graphics.beginFill( 0x0000ff );
			}
			r.graphics.drawCircle( 0, 0, 3 );
			r.graphics.endFill();
			return r;
		}
		
	}
}