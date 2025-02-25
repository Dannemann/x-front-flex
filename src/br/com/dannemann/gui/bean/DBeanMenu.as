package br.com.dannemann.gui.bean
{
	import br.com.dannemann.gui.controller.DSession;
	import br.com.dannemann.gui.controller.EntityDescriptor;

	public final class DBeanMenu implements DIBean
	{
		public var children:Array;
		public var enabled:Boolean = true;
		public var groupName:String;
		public var icon:Object;
		public var label:String;
		public var toggled:Boolean;
		public var type:String;

		public var _parent:DBeanMenu;
		public var _swf:String;
		public var _resizable:Boolean = true;
		private var entityBeanClassName:String;
		public function get _entityBeanClassName():String
		{
			return entityBeanClassName;
		}
		public function set _entityBeanClassName(entityBeanClassName:String):void
		{
			this.entityBeanClassName = entityBeanClassName;
			this._swf = entityBeanClassName;
		}
		public var _entityBeanDescriptorsHandler:EntityDescriptor;
		public var _execute:Function;

		public function DBeanMenu(object:Object=null)
		{
			if (object)
				fillMe(object);
		}

		public function fillMe(object:Object):void
		{
			if (object)
			{
				children = object.children;
				enabled = object.enabled;
				groupName = object.groupName;
				icon = object.icon;
				label = object.label;
				toggled = object.toggled;
				type = object.type;

				_parent = object.parent;
				_swf = object.swf;
				_resizable = object.resizable;
				_entityBeanClassName = object.entityBeanClassName;
				_execute = object.execute;

				if (!_entityBeanDescriptorsHandler)
					if (_entityBeanClassName)
						// TODO: Using DSession here.
						_entityBeanDescriptorsHandler = DSession._entitiesDescriptors[_entityBeanClassName];
			}
			else
				throw new Error(" ### DBeanMenu.fillMe: Objeto nulo.");
		}
	}
}
