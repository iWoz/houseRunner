package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import data.SocketMng;
	
	import view.GameView;
	
	public class HouseRunner extends Sprite
	{
		public function HouseRunner()
		{
			if( stage )
			{
				init();
			}
			else
			{
				addEventListener( Event.ADDED_TO_STAGE, init );
			}
		}
		
		private function init( e:Event = null ):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, init );
			GameView.getInstance().init( this.stage );
			SocketMng.getInstance().connect();
		}
	
	}
}