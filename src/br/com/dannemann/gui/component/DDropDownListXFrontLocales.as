package br.com.dannemann.gui.component
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import spark.events.IndexChangeEvent;
	
	import br.com.dannemann.gui.component.input.DDropDownList;
	import br.com.dannemann.gui.domain.StrConsts;

	/**
	 * <p>A locale selector based on Dannemann framework's supported locales.</p>
	 */
	public class DDropDownListXFrontLocales extends DDropDownList
	{
		// -------------------------------------------------------------------------
		// Fields:
		
		public var _defaultLocaleSelected:Boolean;
		protected var updateLocaleChain:Boolean;
		
		// -------------------------------------------------------------------------
		// Component creation:
		
		// Constructor:
		
		public function DDropDownListXFrontLocales()
		{
			dataProvider = new ArrayCollection(StrConsts._SUPPORTED_LOCALES);
			_dataField = "tag";
		}
		
		// UIComponent:
		
		override protected function initializationComplete():void
		{
			super.initializationComplete();
			
			if (_defaultLocaleSelected)
				text = StrConsts.defaultLocale();
		}
		
		// -------------------------------------------------------------------------
		// Locale chain update:
		
		public function get _updateLocaleChain():Boolean
		{
			return updateLocaleChain;
		}
		
		public function set _updateLocaleChain(value:Boolean):void
		{
			updateLocaleChain = value;
			
			if (updateLocaleChain)
				addEventListener(Event.CHANGE, changeLocaleChain, false, 0, true);
			else
				removeEventListener(Event.CHANGE, changeLocaleChain);
		}
		
		protected function changeLocaleChain(event:IndexChangeEvent):void
		{
			resourceManager.localeChain = [ selectedItem.tag ];
		}
		
		// -------------------------------------------------------------------------
		// Overrides/Implementations:
		
		// DInput:
		
		override public function dispose():void
		{
			removeEventListener(Event.CHANGE, validateInput);
		}
		
		// -------------------------------------------------------------------------
	}
}
