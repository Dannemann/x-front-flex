package br.com.dannemann.gui.component.input
{
	import flash.events.KeyboardEvent;

	import spark.components.List;

	public final class DTextInputAutoCompleteList extends List
	{
		// keyDownHandler is overridden so that the list can handle keyboard events for navigation.
		override protected function keyDownHandler(event:KeyboardEvent):void
		{
			super.keyDownHandler(event);

			if (!dataProvider || !layout || event.isDefaultPrevented())
				return;

			adjustSelectionAndCaretUponNavigation(event); 
		}
	}
}
