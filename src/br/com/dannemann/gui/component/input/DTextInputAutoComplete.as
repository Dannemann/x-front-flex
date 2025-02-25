package br.com.dannemann.gui.component.input
{
	import br.com.dannemann.gui.domain.StrConsts;
	import br.com.dannemann.gui.event.DTextInputAutoCompleteEvent;

	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;

	import mx.collections.ArrayCollection;
	import mx.collections.ListCollectionView;
	import mx.collections.Sort;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.FlexEvent;
	import mx.events.FlexMouseEvent;
	import mx.events.SandboxMouseEvent;
	import mx.utils.StringUtil;

	import spark.components.DataGroup;
	import spark.components.Group;
	import spark.components.List;
	import spark.components.PopUpAnchor;
	import spark.components.TextInput;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.IndexChangeEvent;
	import spark.events.TextOperationEvent;

	[Event (name="onSelect", type="br.com.dannemann.gui.event.DTextInputAutoCompleteEvent")]
	[Event (name="onEnter", type="mx.events.FlexEvent")]
	[Event (name="onChange", type="spark.events.TextOperationEvent")]

	// TODO: IMPLEMENT INTERFACES!!!
	public class DTextInputAutoComplete extends SkinnableComponent// implements DIGUIInput, DIValidatableComponent
	{
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Fields:

		[SkinPart(required="true", type="spark.components.Group")]
		public var dropDown:Group;
		[SkinPart(required="true", type="spark.components.PopUpAnchor")]
		public var popUp:PopUpAnchor;
		[SkinPart(required="true", type="spark.components.List")]
		public var list:List;
		[SkinPart(required="true", type="spark.components.TextInput")]
		public var inputTextDTextInputAutoComplete:TextInput;

		public var maxRows:Number = 15;
		public var minChars:Number = 1;
		public var prefixOnly:Boolean = true;
		public var requireSelection:Boolean = false;
		public var forceOpen:Boolean = false;
		public var sortFunction:Function = defaultSortFunction; // Default sorting: alphabetically ascending.
		public var returnField:String;
		
		public var _isSelectedIndexTheLast:Boolean = true;
		public var _isSelectedIndexTheFirst:Boolean;

		private var collection:ListCollectionView = new ArrayCollection();
		private var _text:String = StrConsts._CHAR_EMPTY_STRING;
		private var _labelField:String;
		private var _labelFunction:Function;
/*		private var _selectedItem:Object;
		private var _selectedIndex:int = -1;*/
		// PopUp position controller.
		public var _firstAndCorrectPopUpPosition:Number = NaN;
		public var _firstAndMamimumPopUpSize:Number = NaN;

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Constructor:

		public function DTextInputAutoComplete()
		{
			this.mouseEnabled = true;
			this.setStyle("skinClass", Class(DTextInputAutoCompleteSkin));
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			collection.addEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChange);
		}

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Overrides:

		// Class overrides:

		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance)

			if (instance == inputTextDTextInputAutoComplete)
			{
				//inputTxt.addEventListener(FocusEvent.FOCUS_OUT, _focusOutHandler);
				inputTextDTextInputAutoComplete.addEventListener(FocusEvent.FOCUS_IN, _focusInHandler);
				inputTextDTextInputAutoComplete.addEventListener(MouseEvent.CLICK, _focusInHandler);
				inputTextDTextInputAutoComplete.addEventListener(TextOperationEvent.CHANGE, onChange);
				inputTextDTextInputAutoComplete.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				inputTextDTextInputAutoComplete.addEventListener(FlexEvent.ENTER, enter);
				inputTextDTextInputAutoComplete.text = _text;
			}

			if (instance == list)
			{
				list.dataProvider = collection;
				list.labelField = labelField;
				list.labelFunction = labelFunction;
				list.addEventListener(FlexEvent.CREATION_COMPLETE, addClickListener);
				list.focusEnabled = false;
				list.requireSelection = requireSelection;
				list.addEventListener(
					KeyboardEvent.KEY_DOWN,
					function (event:KeyboardEvent):void
					{
						if (event.keyCode == Keyboard.ENTER)
						{
							if (list.selectedItem)
								acceptCompletion(event);
							else
								focusOnLastElementOfTheList();
						}
						else if (event.keyCode == Keyboard.TAB)
						{
							event.stopImmediatePropagation();
							callLater(inputTextDTextInputAutoComplete.setFocus);
						}
						else if (event.keyCode == Keyboard.ESCAPE)
						{
							close(event);
							callLater(inputTextDTextInputAutoComplete.setFocus);
						}
						else if (event.keyCode == Keyboard.DOWN)
						{
							if (_isSelectedIndexTheLast)
							{
								focusOnFirstElementOfTheList();
								_isSelectedIndexTheFirst = true;
								_isSelectedIndexTheLast = false;
							}
						}
						else if (event.keyCode == Keyboard.UP)
						{
							if (_isSelectedIndexTheFirst)
							{
								focusOnLastElementOfTheList();
								_isSelectedIndexTheFirst = false;
								_isSelectedIndexTheLast = true;
							}
						}
					}
				);
				list.addEventListener(
					IndexChangeEvent.CHANGE,
					function (event:IndexChangeEvent):void
					{
						if (event.newIndex == 0)
							_isSelectedIndexTheFirst = true
						else
							_isSelectedIndexTheFirst = false;

						if (event.newIndex == (list.dataProvider.length - 1))
							_isSelectedIndexTheLast = true
						else
							_isSelectedIndexTheLast = false;
					}
				);
			}

			if (instance == dropDown)
			{
				dropDown.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, mouseOutsideHandler);	
				dropDown.addEventListener(FlexMouseEvent.MOUSE_WHEEL_OUTSIDE, mouseOutsideHandler);				
				dropDown.addEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE, mouseOutsideHandler);
				dropDown.addEventListener(SandboxMouseEvent.MOUSE_WHEEL_SOMEWHERE, mouseOutsideHandler);
			}
		}

		override public function setFocus():void
		{
			if (inputTextDTextInputAutoComplete)
				inputTextDTextInputAutoComplete.setFocus();
		}

		// Class overrides - Getters and setters:

		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;

			if (inputTextDTextInputAutoComplete)
				inputTextDTextInputAutoComplete.enabled = value;
		}

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Public interface:

		// Public interface:

		public function reset():void
		{
			if (inputTextDTextInputAutoComplete)
				inputTextDTextInputAutoComplete.text = StrConsts._CHAR_EMPTY_STRING;

			if (popUp)
				popUp.displayPopUp = false;

			_isSelectedIndexTheLast = true;
			_isSelectedIndexTheFirst = false;
		}

		public function filterData():void
		{
			if (!this.focusManager || this.focusManager.getFocus() != inputTextDTextInputAutoComplete)
				return;

			if (!popUp)
				return;

			collection.filterFunction = filterFunction;
			const customSort:Sort = new Sort();
			customSort.compareFunction = sortFunction;
			collection.sort = customSort;
			collection.refresh();

			if ((text == StrConsts._CHAR_EMPTY_STRING || collection.length == 0) && !forceOpen)
				popUp.displayPopUp = false;
			else
			{
				if (collection.length == 0)
					popUp.displayPopUp = false;
				else
				{
					popUp.displayPopUp = true;

					if (requireSelection)
						//list.selectedIndex = 0;
						list.selectedIndex = (collection as ListCollectionView).length - 1;
					else
						list.selectedIndex = -1;

					const dataGroup:DataGroup = list.dataGroup;

					if (dataGroup)
					{
						dataGroup.verticalScrollPosition = 0;
						dataGroup.horizontalScrollPosition = 0;
					}

					list.height = Math.min(maxRows, collection.length) * 22 + 2;
					list.validateNow();

					popUp.width = inputTextDTextInputAutoComplete.width;

					if (isNaN(_firstAndCorrectPopUpPosition))
						_firstAndCorrectPopUpPosition = dropDown.y;
					if (isNaN(_firstAndMamimumPopUpSize))
						_firstAndMamimumPopUpSize = dropDown.height;

					dropDown.height = list.height;

					if (!isNaN(_firstAndCorrectPopUpPosition) && !isNaN(_firstAndMamimumPopUpSize))
					{
						dropDown.y = _firstAndCorrectPopUpPosition + (_firstAndMamimumPopUpSize - dropDown.height);
						dropDown.validateNow();
					}

					if (dataGroup)
						list.layout.verticalScrollPosition = dataGroup.contentHeight - list.height + 2;
				}
			}
		}

		// Default filter function. 
		public function filterFunction(item:Object):Boolean
		{
			const label:String = itemToLabel(item).toLowerCase();

			// Prefix mode.
			if (prefixOnly)
			{
				if (label.search(StringUtil.trim(text.toLowerCase())) == 0) 
					return true;
				else 
					return false;
			}
			// Infix mode.
			else 
				if (label.search(StringUtil.trim(text.toLowerCase())) != -1)
					return true;

			return false;
		}

		public function itemToLabel(item:Object):String
		{
			if (item == null)
				return StrConsts._CHAR_EMPTY_STRING;

			if (labelFunction != null)
				return labelFunction(item);
			else if (labelField && item[labelField])
				return item[labelField];
			else
				return item.toString();
		}

		public function defaultSortFunction(item1:Object, item2:Object, fields:Array=null):int
		{
			const label1:String = itemToLabel(item1);
			const label2:String = itemToLabel(item2);

			/*if (label1 < label2)
				return -1;
			else if (label1 == label2)
				return 0;
			else
				return 1;*/

			if (label1 < label2)
				return 1;
			else if (label1 == label2)
				return 0;
			else
				return -1;
		}

		public function acceptCompletion(event:Event):void
		{
			if (list.selectedIndex >= 0 && collection.length > 0)
			{
				/*_selectedIndex = list.selectedIndex;
				_selectedItem = collection.getItemAt(_selectedIndex);

				text = returnFunction(_selectedItem);

				inputTxt.selectRange(inputTxt.text.length, inputTxt.text.length);

				dispatchEvent(new DTextInputAutoCompleteEvent("onSelect", _selectedItem));*/

				dispatchEvent(createNewDTextInputAutoCompleteEvent(DTextInputAutoCompleteEvent.ON_SELECT));
			}
			else
			{
				/*_selectedIndex = */list.selectedIndex = -1;
				/*_selectedItem = null*/
			}

			popUp.displayPopUp = false;

			updateAfterEventIfEventHasIt(event);
		}

		// Getters and setters.

		public function get dataProvider():Object
		{
			return collection;
		}

		public function set dataProvider(value:Object):void
		{
			if (value is Array)
				collection = new ArrayCollection(value as Array);
			else if (value is ListCollectionView)
			{
				collection = value as ListCollectionView;
				collection.addEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChange);
			}

			if (list)
				list.dataProvider = collection;

			filterData();
		}

		public function get text():String
		{
			return _text;
		}

		public function set text(t:String):void
		{
			_text = t;

			if (inputTextDTextInputAutoComplete)
				inputTextDTextInputAutoComplete.text = t;
		}

		public function get labelField():String
		{
			return _labelField;
		}

		public function set labelField(field:String):void
		{
			_labelField = field;

			if (list)
				list.labelField = field ;
		}

		public function get labelFunction():Function
		{
			return _labelFunction;
		}

		public function set labelFunction(func:Function):void
		{
			_labelFunction = func;

			if (list)
				list.labelFunction = func; 
		}

		public function get selectedItem():Object
		{
			//return _selectedItem;
			return collection.getItemAt(list.selectedIndex);
		}

		/*public function set selectedItem(item:Object):void
		{
			//_selectedItem = item;
			//inputTxt.text = returnFunction(item);
			text = returnFunction(item);
		}*/

		public function get selectedIndex():int
		{
			//return _selectedIndex;
			return list.selectedIndex;
		}

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Private interface:

		// Event handlers:

		private function collectionChange(event:CollectionEvent):void
		{
			if (event.kind == CollectionEventKind.RESET || event.kind == CollectionEventKind.ADD)
				filterData();
		}

		private function onChange(event:TextOperationEvent):void
		{
			_text = inputTextDTextInputAutoComplete.text;
			filterData();

			if (text.length >= minChars)
				filterData();

			dispatchEvent(createNewDTextInputAutoCompleteEvent(DTextInputAutoCompleteEvent.ON_CHANGE));
		}

		private function onKeyDown(event:KeyboardEvent):void
		{
			if (popUp.displayPopUp)
				switch (event.keyCode)
				{
					case Keyboard.UP:
						selectAllInputTextAndDispatchEvent(event);
						break;
					case Keyboard.DOWN:
					case Keyboard.END:
					case Keyboard.HOME:
					case Keyboard.PAGE_UP:
					case Keyboard.PAGE_DOWN:
						selectAllInputTextAndDispatchEvent(event);
						break;
					case Keyboard.ENTER:
						acceptCompletion(event);
						break;
					case Keyboard.TAB:
						/*if (requireSelection)
							acceptCompletion();
						else
							popUp.displayPopUp = false;*/

						if (collection.length >= 1)
							callLater(focusOnLastElementOfTheList);

						break;
					case Keyboard.ESCAPE:
						popUp.displayPopUp = false;
						break;
				}
		}

		private function enter(event:FlexEvent):void
		{
			dispatchEvent(createNewDTextInputAutoCompleteEvent(DTextInputAutoCompleteEvent.ON_ENTER));

			if (popUp.displayPopUp && list.selectedIndex > -1)
				return;
		}

		// This is a workaround to reset the mouse cursor.
		private function onMouseOut(event:MouseEvent):void
		{
			Mouse.cursor = MouseCursor.AUTO;
		}

		private function _focusInHandler(event:Event):void
		{
			if (forceOpen)
				filterData();
		}

		/*private function _focusOutHandler(event:FocusEvent):void
		{
			close(event);

			if (collection.length == 0)
			{
				_selectedIndex = -1;
				selectedItem = null;
			}
		}*/

		private function mouseOutsideHandler(event:*):void
		{
			if (event is FlexMouseEvent)
			{
				const e:FlexMouseEvent = event as FlexMouseEvent;

				if (inputTextDTextInputAutoComplete.hitTestPoint(e.stageX, e.stageY))
					return;
			}

			close(event);
		}

		private function close(event:Event):void
		{
			popUp.displayPopUp = false;
			_isSelectedIndexTheLast = true;
			_isSelectedIndexTheFirst = false;
			updateAfterEventIfEventHasIt(event);
		}

		private function addClickListener(event:FlexEvent):void
		{
			list.dataGroup.addEventListener(MouseEvent.CLICK, listItemClick);
		}

		private function listItemClick(event:MouseEvent):void
		{
			acceptCompletion(event);
			event.stopPropagation();
		}

		// Private interface:

		private function returnFunction(item:Object):String
		{
			if (item == null)
				return StrConsts._CHAR_EMPTY_STRING;

			if (returnField)
				return item[returnField];
			else
				return itemToLabel(item);
		}

		private function focusOnFirstElementOfTheList():void
		{
			list.setFocus();
			list.selectedIndex = 0;
		}

		private function focusOnAntepenultElementOfTheList():void
		{
			list.setFocus();
			list.selectedIndex = collection.length - 2;
		}

		private function focusOnLastElementOfTheList():void
		{
			list.setFocus();
			list.selectedIndex = collection.length - 1;
		}

		private function selectAllInputTextAndDispatchEvent(event:KeyboardEvent):void
		{
			inputTextDTextInputAutoComplete.selectRange(text.length, text.length);
			list.dispatchEvent(event);
		}

		private function updateAfterEventIfEventHasIt(event:Event):void
		{
			if (event is KeyboardEvent)
				(event as KeyboardEvent).updateAfterEvent();
			else if (event is MouseEvent)
				(event as MouseEvent).updateAfterEvent();
		}

		private function createNewDTextInputAutoCompleteEvent(type:String):DTextInputAutoCompleteEvent
		{
			const dTextInputAutoCompleteEvent:DTextInputAutoCompleteEvent = new DTextInputAutoCompleteEvent(type);
			dTextInputAutoCompleteEvent._currentWritedText = inputTextDTextInputAutoComplete.text;

			if ((collection && collection.length > 0) && (list.selectedIndex != -1))
				dTextInputAutoCompleteEvent._selectedString = collection.getItemAt(list.selectedIndex).toString();

			return dTextInputAutoCompleteEvent;
		}

		//----------------------------------------------------------------------
	}
}
