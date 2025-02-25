package br.com.dannemann.gui.component.adg
{
	import br.com.dannemann.gui.collections.DTempDataProvider;
	import br.com.dannemann.gui.component.adg.filter.DADGColumnFilterBase;
	import br.com.dannemann.gui.component.adg.plugin.DADGToolBar;
	import br.com.dannemann.gui.util.DUtilWildcard;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextLineMetrics;
	import flash.utils.Dictionary;

	import mx.collections.ArrayCollection;
	import mx.collections.CursorBookmark;
	import mx.collections.ICollectionView;
	import mx.collections.IViewCursor;
	import mx.controls.AdvancedDataGrid;
	import mx.controls.TextInput;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridHeaderRenderer;
	import mx.controls.listClasses.IDropInListItemRenderer;
	import mx.core.ScrollPolicy;
	import mx.core.UIComponent;
	import mx.events.AdvancedDataGridEvent;

	public class DADG extends AdvancedDataGrid implements SearchableAdg
	{
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Fields:

		public var _dADGToolBar:DADGToolBar;

		internal var isFiltered:Boolean = false;
		public function get _isFiltered():Boolean
		{
			return isFiltered;
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

			horizontalScrollPolicy = ScrollPolicy.AUTO;
			verticalScrollPolicy = ScrollPolicy.AUTO;
		}

		override protected function getSeparator(i:int, seperators:Array, headerLines:UIComponent):UIComponent
		{
			const sep:UIComponent = super.getSeparator(i, seperators, headerLines);
			sep.doubleClickEnabled = true;

			// TODO: How to dispose this?
			if (!sep.hasEventListener(MouseEvent.DOUBLE_CLICK))
				sep.addEventListener(MouseEvent.DOUBLE_CLICK, columnResizeDoubleClickHandler, false, 0, true); // TODO: Dispose this.

			return sep;
		}

		override protected function mouseDownHandler(event:MouseEvent):void
		{
			if ((event.target.hasOwnProperty("owner")) && (event.target.owner) && (event.target.owner is TextInput))
				event.preventDefault();
			else
				super.mouseDownHandler(event);
		}

		override protected function headerReleaseHandler(event:AdvancedDataGridEvent):void
		{
			if (event.triggerEvent.target.owner is TextInput)
				event.preventDefault();
			else
				super.headerReleaseHandler(event);
		}

		// Getters and setters:

		/**
		 * @see http://flexpearls.blogspot.com/2008/05/fixing-itemrenderer-memory-leak-in.html
		 */
		override public function set columns(value:Array):void
		{
			super.columns = value;
			itemRendererToFactoryMap = new Dictionary(false);
		}

		override public function get dataProvider():Object
		{
			if (!super.dataProvider)
				super.dataProvider = new ArrayCollection();

			return super.dataProvider;
		}

		override public function set dataProvider(value:Object):void
		{
			if (value is DTempDataProvider)
			{
				updateDADGToolBarNumberOfEntriesLabelToLoading();

				if (value._closeDADGToolBarGroupColumnsPopUp)
					if (_dADGToolBar)
						_dADGToolBar.actionCloseGroupByPopUp();
			}
			else if (dataProvider is DTempDataProvider)
				updateDADGToolBarNumberOfEntriesLabel(value ? value.length : 0);

			super.dataProvider = value;
		}

		//----------------------------------------------------------------------
		// DIGUI implementation:

		public function dispose():void
		{
			const infos:Array = getHeaderInfos();
			if (infos)
			{
				const infosLength:int = infos.length;
				var headerItem:AdvancedDataGridHeaderRenderer;
				for (var i:int = 0; i < infosLength; i++)
				{
					headerItem = infos[i].headerItem;

					if (headerItem is DADGHeaderRenderer)
						(headerItem as DADGHeaderRenderer).dispose();
				}
			}

			_dADGToolBar = null;
		}

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Public interface:

		public function getHeaderInfos():Array
		{
			return headerInfos;
		}

		public function cleanFilters():void
		{
			const infos:Array = getHeaderInfos();

			if (infos)
			{
				const emptyString:String = "";
				var i:int;

				const infosLength:int = infos.length;
				var headerItem:AdvancedDataGridHeaderRenderer;
				var dADGHeaderRenderer:DADGHeaderRenderer;

				for (i = 0; i < infosLength; i++)
				{
					headerItem = infos[i].headerItem;

					if (headerItem is DADGHeaderRenderer)
					{
						dADGHeaderRenderer = headerItem as DADGHeaderRenderer;

						if (dADGHeaderRenderer._inputFilter)
							dADGHeaderRenderer._inputFilter.text = emptyString;
					}
				}

				const columnsLength:int = columns.length;
				var column:AdvancedDataGridColumn;
				var dADGColumn:DADGColumn;

				for (i = 0; i < columnsLength; i++)
				{
					column = columns[i];

					if (column is DADGColumn)
					{
						dADGColumn = column as DADGColumn;

						if (dADGColumn._filter)
							dADGColumn._filter._searchString = emptyString;
					}
				}

				if (collection)
				{
					collection.filterFunction = null;
					collection.refresh();

					if (_dADGToolBar)
						_dADGToolBar.updateNumberOfEntriesLabel(collection.length);
				}
				else
				{
					if (_dADGToolBar)
						_dADGToolBar.updateNumberOfEntriesLabel(0);
				}
			}
		}

		public function updateColumnFilterFunctions():void
		{
			const cff:Array = [];

			var columnFilter:DADGColumnFilterBase;
			var column:DADGColumn;
			for each (column in columns)
			{
				columnFilter = column._filter;
				if (columnFilter && columnFilter._isActive && columnFilter._searchExpression)
					cff.push(columnFilter.filterFunction);
			}

			columnFilterFunctions = cff;

			if (collection)
			{
				collection.filterFunction = collectionFilterFunction;
				collection.refresh();

				if (_dADGToolBar)
					_dADGToolBar.updateNumberOfEntriesLabel(collection.length);
			}
			else
			{
				if (_dADGToolBar)
					_dADGToolBar.updateNumberOfEntriesLabel(0);
			}
		}

		public function updateDADGToolBarNumberOfEntriesLabelToLoading():void
		{
			if (_dADGToolBar)
				_dADGToolBar.updateNumberOfEntriesLabelToLoading();
		}

		public function updateDADGToolBarNumberOfEntriesLabel(dataProviderLength:int):void
		{
			if (_dADGToolBar)
				_dADGToolBar.updateNumberOfEntriesLabel(dataProviderLength);
		}

		public function setNewTempDataProviderAndCleanFilters():void
		{
			cleanFilters();
			this.dataProvider = new DTempDataProvider();
		}

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Private interface:

		// Event listeners:

		private function columnResizeDoubleClickHandler(event:MouseEvent):void
		{
			// Check if the ADG is enabled and the columns are resizable.
			if (!enabled || !resizableColumns)
				return;

			const target:DisplayObject = DisplayObject(event.target);
			const index:int = target.parent.getChildIndex(target);
			const optimumColumns:Array = getOptimumColumns(); // Get the columns array.

			// Check for resizable column.
			if (!optimumColumns[index].resizable)
				return;

			// Calculate the "maxWidth".
			// TODO: Optimize this calculation.
			if (listItems)
			{
				const len:int = listItems.length;
				var maxWidth:int = 0;
				for (var i:int = 0; i < len; i++)
					if(listItems[i][index] is IDropInListItemRenderer)
					{
						const lineMetrics:TextLineMetrics = measureText(IDropInListItemRenderer(listItems[i][index]).listData.label);

						if (lineMetrics.width > maxWidth)
							maxWidth = lineMetrics.width;
					}
			}

			// Set the column's "width".
			optimumColumns[index].width = maxWidth + getStyle("paddingLeft") + getStyle("paddingRight") + 8;
		}

		// Private generic interface:

		private function collectionFilterFunction(obj:Object):Boolean
		{
			for each (var cff:Function in columnFilterFunctions)
				if (!cff(obj))
					return false;

			return true;
		}

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------

		public var copyDataProvider:Boolean = true;

		[Bindable("onOriginalCollectionChange")]
		public var originalCollection:ICollectionView;

		protected var columnFilterFunctions:Array;
		protected var columnFiltersChanged:Boolean;

		[Bindable("searchResultChanged")]
		public function get found():Boolean
		{
			return _found;
		}

		/**
		 * @private
		 * Storage for current found value.
		 */
		protected var _found:Boolean;

		/**
		 * @private
		 * Set <code>found</code> value and dispatch "searchResultChanged" event if needed.
		 */
		protected function setFound(value:Boolean):void
		{
			if (value != _found)
			{
				_found = value;
				dispatchEvent(new Event("searchResultChanged"));
			}
		}


		/**
		 * @copy com.iwobanas.core.ISearchable#searchString
		 */
		[Bindable("searchParamsChanged")]
		public function get searchString():String
		{
			return _searchString;
		}
		/**
		 * @private
		 * Storage for current searchString value.
		 */
		protected var _searchString:String;


		/**
		 * @copy com.iwobanas.core.ISearchable#searchExpression
		 */
		[Bindable("searchParamsChanged")]
		public function get searchExpression():RegExp
		{
			return _searchExpression;
		}

		/**
		 * @private
		 * Storage for current searchExpression value.
		 */
		protected var _searchExpression:RegExp;


		public function registerWildcard(wildcard:String, caseInsensitive:Boolean = true):void
		{
			if (!wildcard)
			{
				_searchString = null;
				_searchExpression = null;
				dispatchEvent(new Event("searchParamsChanged"));
				setFound(false);
				updateList();
			}
			_searchString = wildcard;
			_searchExpression = DUtilWildcard.wildcardToRegExp(wildcard, caseInsensitive ? "ig":"g");
			dispatchEvent(new Event("searchParamsChanged"));
		}

		/**
		 * Find item matching given wildcard and assign first match to selectedItem.
		 *
		 * <p>Unlike standard findSting() function this functions searches labels of all visible columns.
		 * It also supports wildcards containing <code>"?"</code> or <code>"*"</code> characters
		 * interpreted as any character or any character sequence respectively.</p>
		 *
		 * <p>The search starts at <code>selectedIndex</code> location and if match is find stops immediately.
		 * If it reaches the end of the data provider it starts over from the beginning.
		 * If you need to navigate between matches user <code>findNext() / findPrevious()</code> functions.</p>
		 *
		 * @param wildcard text to search for
		 * @param caseInsensitive flag indicating whether search should be case insensitive
		 * @return <code>true</code> if text was fond or <code>false</code> if not
		 *
		 * @see com.iwobanas.core.ISearchable
		 */
		public function find(wildcard:String, caseInsensitive:Boolean = true):Boolean
		{
			if (!wildcard)
			{
				_searchString = null;
				_searchExpression = null;
				dispatchEvent(new Event("searchParamsChanged"));
				setFound(false);
				updateList();
				return false;
			}
			_searchString = wildcard;
			_searchExpression = DUtilWildcard.wildcardToRegExp(wildcard, caseInsensitive ? "ig":"g");
			dispatchEvent(new Event("searchParamsChanged"));
			return findItem();
		}

		public function findNext():Boolean
		{
			return findItem(true, true);
		}

		public function findPrevious():Boolean
		{
			return findItem(false, true);
		}

		/**
		 * @private
		 * Iterate through data provider and check if it matches search condition by calling <code>matchItem()</code>.
		 * If matching item is found set <code>selectedIndex</code> to point to this item and scroll the content
		 * so that selected item can be seen.
		 *
		 * @param forward determines if items should be searched forward (from top to bottom) or backward.
		 * @param skip determines if search should start at <code>selectedIndex</code> or one item after/before.
		 */
		protected function findItem(forward:Boolean = true, skip:Boolean = false):Boolean
		{
			var cursor:IViewCursor = collection.createCursor();
			var itemFound:Boolean = false;

			if (selectedIndex > 0)
				cursor.seek(CursorBookmark.FIRST, selectedIndex);
			else
				cursor.seek(CursorBookmark.FIRST);

			if (skip)
			{
				if (forward)
					cursor.moveNext();
				else
					cursor.movePrevious()
			}

			// Iterate through collection (note that "i" is not current index).
			const colLen:int = collection.length;
			for (var i:int = 0; i < colLen; i++)
			{
				if (matchItem(cursor.current))
				{
					itemFound = true;
					break;
				}

				if (forward)
					cursor.moveNext();
				else
					cursor.movePrevious();

				if (cursor.afterLast)
					cursor.seek(CursorBookmark.FIRST);

				if (cursor.beforeFirst)
					cursor.seek(CursorBookmark.LAST);
			}

			if (itemFound)
			{
				selectedItem = cursor.current;

				//scrollToIndex(selectedIndex); // Scrolls the content so that selected item is always the first item.

				// We wanted selected item to be at the bottom if we scroll downward so scrollToIndex is not used.
				if (selectedIndex < verticalScrollPosition)
					verticalScrollPosition = selectedIndex;

				if (selectedIndex > verticalScrollPosition + rowCount - lockedRowCount - 2) // 1 for header + 1 for last row.
					verticalScrollPosition = selectedIndex - rowCount + lockedRowCount + 2;
			}

			setFound(itemFound);

			return itemFound;
		}

		protected function matchItem(item:Object):Boolean
		{
			for each (var column:DADGColumn in columns)
				if (column.visible && _searchExpression && _searchExpression.test(column.itemToLabel(item)))
				{
					_searchExpression.lastIndex = 0;
					return true;
				}

			return false;
		}

		//----------------------------------------------------------------------
	}
}
