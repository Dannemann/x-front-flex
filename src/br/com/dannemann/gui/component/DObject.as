package br.com.dannemann.gui.component
{
	public dynamic final class DObject
	{
		public const _keys:Vector.<String> = new Vector.<String>();
		public const _values:Vector.<Object> = new Vector.<Object>();

		public function put(key:String, value:Object=null):void
		{
			_keys.push(key);
			_values.push(value);
			this[key] = value;
		}

		public function get length():int
		{
			if (_keys.length == _values.length)
				return _keys.length;
			else	
				return -1; 
		}
	}
}
