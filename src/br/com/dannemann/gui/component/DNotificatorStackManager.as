package br.com.dannemann.gui.component
{
	import br.com.dannemann.gui.domain.StrConsts;

	internal final class DNotificatorStackManager implements DComponent
	{
		//----------------------------------------------------------------------
		// Singleton:
		
		private static var _instance:DNotificatorStackManager;
		
		public static function getInstance():DNotificatorStackManager
		{
			if (_instance == null)
				_instance = new DNotificatorStackManager(new PrivateStackManager());
			
			return _instance;
		}
		
		//----------------------------------------------------------------------
		// Fields:
		
		private var _count:int = 0;
		private var _stackTop:int = 0;
		
		//----------------------------------------------------------------------
		// Constructor:
		
		public function DNotificatorStackManager(type:PrivateStackManager)
		{
			if (type == null)
				throw new Error(StrConsts.getRMString(13));
		}
		
		//----------------------------------------------------------------------
		// Stack behavior:
		
		public function add(notificator:DNotificator):void 
		{
			_count++;
			_stackTop++;
		}
		
		public function remove():void 
		{
			_count--;
			
			if (_count <= 0)
				resetStack();
		}
		
		public function resetStack():void
		{
			_count = 0;
			_stackTop = 0;
		}
		
		//----------------------------------------------------------------------
		// Getters and setters:
		
		public function get count():int
		{
			return _count;
		}
		
		public function get stackTop():int
		{
			return _stackTop;
		}
		
		//----------------------------------------------------------------------
	}
}

internal class PrivateStackManager
{
}
