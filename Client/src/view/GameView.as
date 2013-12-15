package view
{
	import fl.controls.Button;
	import fl.events.ComponentEvent;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.Socket;
	
	import data.SocketMng;

	public class GameView
	{
		private static var inst:GameView;
		
		private var window:runner;
		public function GameView()
		{
		}
		
		public static function getInstance():GameView
		{
			if( !inst )
			{
				inst = new GameView;
			}
			return inst;
		}
		
		public function init( stage:Stage ):void
		{
			window = new runner;
			stage.addChild( window );
			//stage.color = 0x333333;
			window.x = -25;
			window.y = -25;
			window.setPanel.visible = false;
			window.createPanel.visible = false;
			window.roomList.visible = false;
			window.verTf.selectable = false;
			initMenu();
			initPanels();
		}
		
		private function initMenu():void
		{
			(window.menu.createBtn as Button).addEventListener(MouseEvent.CLICK, function( e:MouseEvent ):void
			{
				window.setPanel.visible = false;
				window.createPanel.visible = true;
				window.roomList.visible = false;
			});
			(window.menu.joinBtn as Button).addEventListener(MouseEvent.CLICK, function( e:MouseEvent ):void
			{
				window.setPanel.visible = false;
				window.createPanel.visible = false;
				window.roomList.visible = true;
			});
			(window.menu.setBtn as Button).addEventListener(MouseEvent.CLICK, function( e:MouseEvent ):void
			{
				window.setPanel.visible = true;
				window.createPanel.visible = false;
				window.roomList.visible = false;
				window.setPanel.ipTf.text = SocketMng.getInstance().ip;
				window.setPanel.portTf.text = SocketMng.getInstance().port.toString();
			});
		}
		
		private function initPanels():void
		{
			window.createPanel.createBtn.addEventListener(MouseEvent.CLICK, onCreateRoom);
			window.createPanel.cancelBtn.addEventListener(MouseEvent.CLICK, function( e:MouseEvent ):void
			{
				window.createPanel.visible = false;
			});
			
			window.setPanel.saveBtn.addEventListener(MouseEvent.CLICK, onSaveSetting);
			window.setPanel.cancelBtn.addEventListener(MouseEvent.CLICK, function( e:MouseEvent ):void
			{
				window.setPanel.visible = false;
			});
			
			
		}
		
		private function onCreateRoom( e:MouseEvent ):void
		{
			trace("Create Room: ",window.createPanel.nameTf.text, 
				"Size: ", window.createPanel.wTf.text, "x", window.createPanel.hTf.text  );
		}
		
		private function onSaveSetting( e:MouseEvent ):void
		{
			trace("Set ip: ",window.setPanel.ipTf.text, "port: ", window.setPanel.portTf.text );
		}
	}
}