package br.com.dannemann.gui.component.adg
{
	import br.com.dannemann.gui.domain.StrConsts;
	
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.controls.TextInput;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridHeaderRenderer;
	import mx.core.UIComponent;
	import mx.utils.StringUtil;
	
	import spark.components.RichEditableText;

	public final class DADGHeaderRenderer extends AdvancedDataGridHeaderRenderer
	{
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Fields:

		public var _inputFilter:TextInput;

		private const _inputFilterKeyBoardControl:Timer = new Timer(150, 1);

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Overrides:

		//----------------------------------------------------------------------
		// Class Overrides:

		override protected function createChildren():void
		{
			super.createChildren();

			if (!_inputFilter)
			{
				_inputFilter = new TextInput();

				_inputFilter.setStyle("borderStyle", "solid");
				_inputFilter.setStyle("borderSides", "bottom");
				_inputFilter.setStyle("color", StrConsts._COLOR_RED_FIREBRICK);
				_inputFilter.setStyle("focusThickness", 1);
				_inputFilter.setStyle("fontWeight", "bold");
				_inputFilter.addEventListener(Event.CHANGE, onFilterByColumn, false, 0, true);
				addChild(_inputFilter);

				_inputFilterKeyBoardControl.addEventListener(TimerEvent.TIMER_COMPLETE, doFilter, false, 0, true);
			}
		}

		override protected function measure():void
		{
			super.measure();

			measuredMinHeight = measuredHeight += _inputFilter.getExplicitOrMeasuredHeight();
		}

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);

			_inputFilter.setActualSize(unscaledWidth - 3, _inputFilter.getExplicitOrMeasuredHeight());
			_inputFilter.x = 2;
			_inputFilter.y = -1;

			label.y += 11;

			if (getChildAt(3))
				getChildAt(3).y += 11;
		}

		//----------------------------------------------------------------------
		// DIGUI implementation:

		public function dispose():void
		{
			_inputFilter.removeEventListener(Event.CHANGE, onFilterByColumn);
			_inputFilterKeyBoardControl.removeEventListener(TimerEvent.TIMER_COMPLETE, doFilter);
		}

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Private interface:

		// Event listeners:

		private function onFilterByColumn(event:Event):void
		{
			if (_inputFilterKeyBoardControl.running)
			{
				_inputFilterKeyBoardControl.stop();
				_inputFilterKeyBoardControl.start();
			}
			else
				_inputFilterKeyBoardControl.start();
		}

		private function doFilter(event:TimerEvent):void
		{
			const selectionActivePosition:int = _inputFilter.selectionActivePosition;
			(data as DADGColumn).filter(StringUtil.trim(_inputFilter.text));
			callLater(doSetFocus, [ selectionActivePosition ]);
		}

		// Event listeners helpers:

		private function doSetFocus(selectionActivePosition:int):void
		{
			const iObj:InteractiveObject = getFocus();

			if (!iObj)
			{
				_inputFilter.setFocus();
				_inputFilter.selectRange(selectionActivePosition, selectionActivePosition);
			}
			else
			{
				if (iObj is TextInput)
				{
					const iObjTextInput:TextInput = iObj as TextInput;
					iObjTextInput.setFocus();
					iObjTextInput.selectRange(iObjTextInput.selectionActivePosition, iObjTextInput.selectionActivePosition);
				}
				else if (iObj is RichEditableText)
				{
					const iObjRichEditableText:RichEditableText = iObj as RichEditableText;
					iObjRichEditableText.setFocus();
					iObjRichEditableText.selectRange(iObjRichEditableText.selectionActivePosition, iObjRichEditableText.selectionActivePosition);
				}
				else if (iObj is spark.components.TextInput)
				{
					const iObjSparkComponentsTextInput:spark.components.TextInput = iObj as spark.components.TextInput;
					iObjSparkComponentsTextInput.setFocus();
					iObjSparkComponentsTextInput.selectRange(iObjSparkComponentsTextInput.selectionActivePosition, iObjSparkComponentsTextInput.selectionActivePosition);
				}
				else if (iObj is UIComponent)
					(iObj as UIComponent).setFocus();
			}
		}

		//----------------------------------------------------------------------
	}
}
