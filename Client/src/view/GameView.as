package view
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import ctrl.CmdSender;
	
	import data.RoomData;
	import data.RoomDataMng;
	import data.SocketMng;
	
	import fl.controls.Button;

	public class GameView
	{
		private static var inst:GameView;
		
		public var stage:Stage;
		
		private var window:runner;
		public var room:Room;
		private var roomLayer:Sprite;
		
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
			this.stage = stage;
			window = new runner;
			stage.addChild( window );
			window.x = window.y = -25;
			window.setPanel.visible = false;
			window.createPanel.visible = false;
			window.roomList.visible = false;
			window.verTf.selectable = false;
			initMenu();
			initPanels();
			roomLayer = new Sprite;
			roomLayer.x = roomLayer.y = -25;
			roomLayer.graphics.beginFill( 0x333333 );
			roomLayer.graphics.drawRect( 0, 0, 550, 400 );
			roomLayer.graphics.endFill();
			stage.addChild( roomLayer );
			roomLayer.visible = false;
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
				updateRoomList();
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
		
		private function updateRoomList():void
		{
			window.roomList.removeAll();
			for each( var r:RoomData in RoomDataMng.getInstance().roomList )
			{
				window.roomList.addItem( {"label":r.toString(), "data":r} );
			}
		}
		
		private function onCreateRoom( e:MouseEvent ):void
		{
			trace("Create Room: ",window.createPanel.nameTf.text, 
				"Size: ", window.createPanel.wTf.text, "x", window.createPanel.hTf.text  );
			CmdSender.getInstance().createRoom( window.createPanel.nameTf.text, uint(window.createPanel.wTf.text), uint(window.createPanel.hTf.text) )
		}
		
		public function doCreateRoom( width:uint, height:uint, doorPos1:Point, doorPos2:Point ):void
		{
			roomLayer.removeChildren();
			room = new Room( width, height, doorPos1, doorPos2 );
			room.x = (roomLayer.width - room.width) * 0.5
			room.y = (roomLayer.height - room.height) * 0.5
			roomLayer.addChild( room );
			roomLayer.visible = true;
		}
		
		private function onSaveSetting( e:MouseEvent ):void
		{
			trace("Set ip: ",window.setPanel.ipTf.text, "port: ", window.setPanel.portTf.text );
		}
		
	}
}