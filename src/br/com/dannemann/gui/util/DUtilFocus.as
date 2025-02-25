package br.com.dannemann.gui.util
{
	import mx.core.UIComponent;
	import mx.managers.IFocusManager;
	
	import br.com.dannemann.gui.component.container.mdi.containers.MDIWindow;
	import br.com.dannemann.gui.component.input.complex.DCRUDForm;

	public final class DUtilFocus
	{
		/**
		 * <p>If we disable validations programatically but the focus is still on this component 
		 * the red focus retangle will not disappear. This workaround will fix it.</p>
		 */
		public static function updateFocusRetangle(component:UIComponent):void
		{
			// If the focus rectangle is on this component we redraw it.
			if ((component.focusManager ? component.focusManager.getFocus() : null) == component)
				component.drawFocus(true);
		}
		
		public static function setFocusOnNextComponent(focusManager:IFocusManager):void
		{
			focusManager.setFocus(focusManager.getNextFocusManagerComponent());
		}

		public static function setFocusForcingIndicator(component:UIComponent):void
		{
			component.setFocus();
			component.focusManager.showFocus();
		}

		public static function setFocusOnFirstDIGUIInputInMDIWindow(mdiWindow:MDIWindow):void
		{
			const mdiWindowChildrenArray:Array = mdiWindow.getChildren();

			if ((mdiWindowChildrenArray.length == 1) && (mdiWindowChildrenArray[0] is DCRUDForm))
				(mdiWindowChildrenArray[0] as DCRUDForm).setFocus();
			// TODO: Unfinished method. Work on this.
			//else
		}
	}
}
