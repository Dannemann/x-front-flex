package br.com.dannemann.gui.component.input
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.controls.DateChooser;
	import mx.controls.DateField;
	import mx.controls.TextInput;
	import mx.core.FlexVersion;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	import mx.styles.StyleProxy;
	
	import br.com.dannemann.gui.XFrontConfigurator;
	import br.com.dannemann.gui.controller.BlazeDs;
	import br.com.dannemann.gui.controller.DGUIServiceProxy;
	import br.com.dannemann.gui.domain.StrConsts;
	import br.com.dannemann.gui.util.DUtilDate;

	use namespace mx_internal;

	public final class DDateField extends DateField implements DInput
	{
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Fields:

		public static const _WORKING_MODE_NUMERIC_FORMAT_YYYYMMDDHHMM:uint = 1;
		public static const _WORKING_MODE_NUMERIC_FORMAT_YYYYMMDD:uint = 2;
		public static const _WORKING_MODE_DATE_FORMAT_YYYYMMDDHHMM:uint = 3; // TODO: Implementar neste modo.
		public static const _WORKING_MODE_DATE_FORMAT_YYYYMMDD:uint = 4; // TODO: Implementar neste modo.

		public static const _NOW:String = "now";

		public var _workingMode:uint = _WORKING_MODE_NUMERIC_FORMAT_YYYYMMDD;

		public var _blazeDS:BlazeDs = new BlazeDs();

		protected var defaultValue:Object;
		public function get _defaultValue():Object
		{
			return defaultValue;
		}
		public function set _defaultValue(value:Object):void
		{
			if (value is String && value.toLowerCase() == "now")
				value = "now";

			defaultValue = value;

			if (defaultValue)
				setStyle("errorColor", _errorColorCode);
			else
				setStyle("errorColor", "0xFF0000");

//			if (_validator)
//				_validator._defaultValue = defaultValue;
		}

		protected var description:String;
		public function get _description():String
		{
			return description;
		}
		public function set _description(value:String):void
		{
			description = value;

//			if (_validator)
//				_validator._description = _description;
		}

		protected const _errorColorCode:String = "0xFF00FF";

		private var _dropdown:DateChooser;

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Constructor:

		public function DDateField()
		{
			editable = true;
			yearNavigationEnabled = true;
		}

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Getters and setters:

		public function get inputMask():String
		{
			const inputMask:String = (textInput as DTextInputDateTemplate).inputMask;
			return inputMask ? inputMask : null;
		}

		public function set inputMask(value:String):void
		{
			if (textInput)
				(textInput as DTextInputDateTemplate).inputMask = value;

			formatString = value;
		}

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Overrides:

		//----------------------------------------------------------------------
		// Class Overrides:

		override protected function createChildren():void
		{
			super.createChildren();

			var level:Number = -1;

			if (textInput)
			{
				if (owns(textInput as DisplayObject))
				{
					level = getChildIndex(textInput as DisplayObject);
					removeChild(textInput as DisplayObject);
				}

				textInput = null;
			}

			if (!textInput)
			{
				var textInputStyleName:Object = getStyle("textInputStyleName");

				if (!textInputStyleName)
					textInputStyleName = new StyleProxy(this, textInputStyleFilters);

				textInput = new DTextInputDateTemplate();
				// TODO: Remove DFxGUIConstants?
				(textInput as DTextInputDateTemplate).inputMask = isDateWithTimestamp() ? StrConsts._STR_DATE_HOUR_FORMAT_STRING_4_INPUT : StrConsts._STR_DATE_FORMAT_STRING;
				textInput.editable = editable;
				textInput.restrict = StrConsts._REGEXP_RESTRICT_U001B;
				textInput.imeMode = super.imeMode;
				textInput.styleName = textInputStyleName;
				textInput.setStyle("disabledColor", "0x657f88");
				textInput.addEventListener(StrConsts._EVENT_inputMaskEnd, uniHandler, false, 0, true);
				textInput.addEventListener(StrConsts._EVENT_change, uniHandler, false, 0, true);
				textInput.addEventListener(FlexEvent.VALUE_COMMIT, uniHandler, false, 0, true);

				if (level != -1)
					addChildAt(textInput as DisplayObject, level);

				this.swapChildren(textInput as DisplayObject, downArrowButton);

				textInput.move(0, 0);
			}

			_dropdown = dropdown;

			if (defaultValue)
				setStyle("errorColor", _errorColorCode);
		}

		override protected function measure():void
		{
			const bigDate:Date = new Date(2004, 12, 31);

			measuredMinWidth = measuredWidth = measureText((labelFunction != null) ? labelFunction(bigDate) : dateToString(bigDate, formatString)).width + 25 + downArrowButton.getExplicitOrMeasuredWidth();

			if (FlexVersion.compatibilityVersion >= FlexVersion.VERSION_3_0)
				measuredMinWidth = measuredWidth += getStyle("paddingLeft") + getStyle("paddingRight");

			measuredMinHeight = measuredHeight = textInput.getExplicitOrMeasuredHeight();
		}

		//----------------------------------------------------------------------
		// DIGUIInput implementation:

		override public function get text():String
		{
			const myText:String = super.text;

			if (_workingMode == _WORKING_MODE_NUMERIC_FORMAT_YYYYMMDDHHMM)
				return myText.substring(4, 8) + myText.substring(2, 4) + myText.substring(0, 2) + myText.substring(8, 10) + myText.substring(10, 12);
			else if (_workingMode == _WORKING_MODE_NUMERIC_FORMAT_YYYYMMDD)
				return myText.substring(4, 8) + myText.substring(2, 4) + myText.substring(0, 2);
			else
				return myText;
		}

		override public function set text(value:String):void
		{
			if (_workingMode == _WORKING_MODE_NUMERIC_FORMAT_YYYYMMDDHHMM)
				super.text = value.substring(6, 8) + value.substring(4, 6) + value.substring(0, 4) + value.substring(8, 10) + value.substring(10, 12);
			else if (_workingMode == _WORKING_MODE_NUMERIC_FORMAT_YYYYMMDD)
				super.text = value.substring(6, 8) + value.substring(4, 6) + value.substring(0, 4);
			else
				super.text = value;
		}

		public function clean():void
		{
			this.text = StrConsts._CHAR_EMPTY_STRING;
		}

		public function dispose():void
		{
			textInput.removeEventListener(StrConsts._EVENT_inputMaskEnd, uniHandler);
			textInput.removeEventListener(StrConsts._EVENT_change, uniHandler);
			textInput.removeEventListener(FlexEvent.VALUE_COMMIT, uniHandler);

//			if (hasEventListener(FocusEvent.FOCUS_OUT))
//				removeEventListener(FocusEvent.FOCUS_OUT, validateInput);
		}

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Public interface:

		public function now():void
		{
			if (textInput)
				textInput.enabled = false;
			else
				callLater(
					function ():void
					{
						textInput.enabled = false;
					}
				);

//			_blazeDS.invoke(DGUIServiceProxy.__now, null, doNow, null/*textInput as UIComponent*/);
			_blazeDS.invoke3(XFrontConfigurator._metaServiceDestination, DGUIServiceProxy._now, null, doNow, null);
		}

		private function doNow(returnObj:Object):void
		{
			const _date:Date = new Date();
			_date.date = returnObj.day;
			_date.month = returnObj.month;
			_date.fullYear = returnObj.year;
			_date.hours = returnObj.hour;
			_date.minutes = returnObj.minute;

			textInput.text = DUtilDate.dateObjToBrStringDDMMYYYYHHMM(_date);

			textInput.enabled = true;
		}

		public function getTextInput():TextInput
		{
			return textInput as TextInput;
		}

		//----------------------------------------------------------------------
		// Private interface:

		private function uniHandler(event:Event):void
		{
			_dropdown.selectedDate = stringToDate((textInput as DTextInputDateTemplate).fullText, formatString);

			if (_dropdown.selectedDate)
			{
				_dropdown.displayedMonth = _dropdown.selectedDate.getMonth();
				_dropdown.displayedYear = _dropdown.selectedDate.getFullYear();
			}
		}

		private function isDateWithTimestamp():Boolean
		{
			if (_workingMode == _WORKING_MODE_NUMERIC_FORMAT_YYYYMMDDHHMM || _workingMode == _WORKING_MODE_DATE_FORMAT_YYYYMMDDHHMM)
				return true;

			return false;
		}

		//----------------------------------------------------------------------
		// Public static interface:

		public static function stringToDate(valueString:String, inputFormat:String):Date
		{
			const n:int = inputFormat.length;
			var mask:String
			var temp:String;
			var dateString:String = StrConsts._CHAR_EMPTY_STRING;
			var monthString:String = StrConsts._CHAR_EMPTY_STRING;
			var yearString:String = StrConsts._CHAR_EMPTY_STRING;
			var j:int = 0;

			for (var i:int = 0; i < n; i++, j++)
			{
				temp = StrConsts._CHAR_EMPTY_STRING + valueString.charAt(j);
				mask = StrConsts._CHAR_EMPTY_STRING + inputFormat.charAt(i);

				if (temp == StrConsts._CHAR_UNDERSCORE)
					temp = StrConsts._STR_0;

				if (mask == StrConsts._STR_M)
				{
					if (isNaN(Number(temp)) || temp == StrConsts._CHAR_SPACE)
						j--;
					else
						monthString += temp;
				}
				else if (mask == StrConsts._STR_D)
				{
					if (isNaN(Number(temp)) || temp == StrConsts._CHAR_SPACE)
						j--;
					else
						dateString += temp;
				}
				else if (mask == StrConsts._STR_Y)
					yearString += temp;
				else if (mask == StrConsts._CHAR_FORWARD_SLASH)
				{

				}
				else if (!isNaN(Number(temp)) && temp != StrConsts._CHAR_SPACE)
					return null;
			}

			if (monthString == StrConsts._CHAR_EMPTY_STRING)
				monthString = StrConsts._STR_01;
			if (dateString == StrConsts._CHAR_EMPTY_STRING)
				dateString = StrConsts._STR_01;
			if (yearString == StrConsts._CHAR_EMPTY_STRING)
				yearString = StrConsts._STR_1900;

			temp = StrConsts._CHAR_EMPTY_STRING + valueString.charAt(inputFormat.length - i + j);

			if (!(temp == StrConsts._CHAR_EMPTY_STRING) && (temp != StrConsts._CHAR_SPACE))
				return null;

			const monthNum:Number = Number(monthString);
			const dayNum:Number = Number(dateString);
			var yearNum:Number = Number(yearString);

			if (isNaN(yearNum) || isNaN(monthNum) || isNaN(dayNum))
				return null;

			if (yearString.length == 2 && yearNum < 70)
				yearNum += 2000;

			var newDate:Date = new Date(yearNum, monthNum - 1, dayNum);

			if (dayNum != newDate.getDate() || (monthNum - 1) != newDate.getMonth())
				return null;

			return newDate;
		}

		//----------------------------------------------------------------------
	}
}
