package br.com.dannemann.gui.component.autoComplete.impl.interfaces
{
	import flash.display.DisplayObject;
	
	public interface iComboItem
	{
		function setTextFocus():void
		function contains( x:DisplayObject ):Boolean
		function isCursorAtBeginning():Boolean
		function isCursorAtEnd():Boolean
		function isEditable():Boolean		
		function get text():String
		function get item():Object
	}
}