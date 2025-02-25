package br.com.dannemann.gui.component.input
{
	import br.com.dannemann.gui.component.DComponent;

	public interface DInput extends DComponent
	{
		// TODO: It makes sense to add _description as a feature of D framework's components? (Or maybe in the parent of this class?)
//		public function get _description():String;
//		public function set _description(value:String):void;

		// TODO: THINK ABOUT THIS PROPERTY. AND WHEN RETURNING OBJECTS LIKE THE ADDRESS INPUT?
		function get text():String;
		function set text(value:String):void;

		function setFocus():void;
		function clean():void;
		function dispose():void;
	}
}
