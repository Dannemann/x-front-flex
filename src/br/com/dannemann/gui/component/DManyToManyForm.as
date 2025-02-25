package br.com.dannemann.gui.component
{
	import br.com.dannemann.gui.domain.StrConsts;
	import br.com.dannemann.gui.XFrontConfigurator;
	import br.com.dannemann.gui.dto.persistence.Request;
	import br.com.dannemann.gui.bean.FieldDescriptorBean;
	import br.com.dannemann.gui.component.container.DVGroup;
	import br.com.dannemann.gui.component.input.DSelectOneListing;
	import br.com.dannemann.gui.controller.BlazeDs;
	import br.com.dannemann.gui.controller.DSession;
	import br.com.dannemann.gui.controller.EntityDescriptor;
	import br.com.dannemann.gui.event.DSelectOneListingEvent;
	import br.com.dannemann.gui.library.DIconLibrary48;

	import flash.events.Event;
	import flash.events.MouseEvent;

	import mx.collections.ArrayCollection;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.IUIComponent;
	import mx.events.DragEvent;
	import mx.managers.DragManager;

	import spark.components.HGroup;
	import spark.components.VGroup;
	import spark.layouts.VerticalAlign;

	public final class DManyToManyForm extends DVGroup
	{
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Fields:

		public var _entityDescriptorJoinColumn:EntityDescriptor;
		public var _entityDescriptorInverseJoinColumn:EntityDescriptor;
		public var _description:String;
		public var _tableName:String;
		public var _joinColumn:String;
		public var _joinColumnJavaField:String;
		public var _inverseJoinColumn:String;
		public var _joinColumnValueRequired:Boolean = true;
		public var _showJoinColumnInput:Boolean = false;
		public var _showRefreshButton:Boolean = true;

		private const _dBeanCRUDParam:Request = new Request();

		public function set _selectedItemLocked1(value:Object):void
		{
			if (value)
			{
				enabled = true;

				if (_showJoinColumnInput)
				{
					_dSelectOneListingJoinColumn._selectedItem = value;
					_dSelectOneListingJoinColumn.enabled = false;
				}
				else
					joinColumnValue = value[_entityDescriptorJoinColumn._fieldDescriptorID._javaField];
			}
			else
			{
				enabled = false;

				if (_showJoinColumnInput)
				{
					_dSelectOneListingJoinColumn.clean();
					_dSelectOneListingJoinColumn.enabled = true;
				}
				else
					joinColumnValue = null;
			}
		}

		// Components:

		public var joinColumnValue:String;

		public const _dSelectOneListingJoinColumn:DSelectOneListing = new DSelectOneListing();
		public const _dSelectOneListingInverseJoinColumn:DSelectOneListing = new DSelectOneListing();
		public const _dataGrid:DataGrid = new DataGrid();
		public const _trashImg:DImage = new DImage(DIconLibrary48.TRASH);
		public var _refreshImg:DImage;

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Overrides:

		//----------------------------------------------------------------------
		// Class Overrides:

		override protected function createChildren():void
		{
			super.createChildren();

			if (_joinColumnValueRequired)
				enabled = false;

			_dBeanCRUDParam.tenant = DSession._tenant;
			_dBeanCRUDParam.objectType = _entityDescriptorJoinColumn._crudDescriptor._className;
			_dBeanCRUDParam._idJavaType = _entityDescriptorJoinColumn._fieldDescriptorID._javaType;
			_dBeanCRUDParam._invokeGetOnResult = _joinColumnJavaField;

			var hGroup:HGroup = new HGroup();
			hGroup.percentWidth = 100;
			hGroup.verticalAlign = VerticalAlign.BOTTOM;

			if (_showJoinColumnInput)
			{
				_dSelectOneListingJoinColumn._entityDescriptor = _entityDescriptorJoinColumn;
				_dSelectOneListingJoinColumn.percentWidth = 100;
				hGroup.addElement(_dSelectOneListingJoinColumn);
			}
			else
				hGroup.addElement(new DLabel(StrConsts.getRMString(10) + ":"));

			_dSelectOneListingInverseJoinColumn._entityDescriptor = _entityDescriptorInverseJoinColumn;
			_dSelectOneListingInverseJoinColumn.percentWidth = 100;
			_dSelectOneListingInverseJoinColumn.addEventListener(DSelectOneListingEvent._ON_CHANGE, onInverseJoinColumnSelected, false, 0, true);
			hGroup.addElement(_dSelectOneListingInverseJoinColumn);

			addElement(hGroup);

			var inverseJoinColumnCodeFD:FieldDescriptorBean;
			if (_entityDescriptorInverseJoinColumn._codeField)
				inverseJoinColumnCodeFD = _entityDescriptorInverseJoinColumn._codeField;
			else
				inverseJoinColumnCodeFD = _entityDescriptorInverseJoinColumn._fieldDescriptorID;

			const dgc1:DataGridColumn = new DataGridColumn();
			dgc1.dataField = inverseJoinColumnCodeFD._javaField;
			dgc1.headerText =inverseJoinColumnCodeFD._fieldNameFormatted;
			const dgc2:DataGridColumn = new DataGridColumn();
			dgc2.dataField = _entityDescriptorInverseJoinColumn._descriptionField._javaField;
			dgc2.headerText = _entityDescriptorInverseJoinColumn._descriptionField._fieldNameFormatted;

			_dataGrid.allowMultipleSelection = true;
			_dataGrid.columns = [ dgc1, dgc2 ];
			_dataGrid.draggableColumns = false;
			_dataGrid.dragEnabled = true;
			_dataGrid.dataProvider = new ArrayCollection();
			_dataGrid.percentWidth = 100;
			_dataGrid.percentHeight = 100;

			_trashImg.toolTip = StrConsts.getRMString(149);
			_trashImg.addEventListener(DragEvent.DRAG_ENTER, onDragEnterOnTrash, false, 0, true);
			_trashImg.addEventListener(DragEvent.DRAG_DROP, onDragDropOnTrash, false, 0, true);

			const vGroup:VGroup = new VGroup();

			if (_showRefreshButton)
			{
				_refreshImg = new DImage(DIconLibrary48.REFRESH);
				_refreshImg.buttonMode = true;
				_refreshImg.toolTip = StrConsts.getRMString(150);
				_refreshImg.addEventListener(MouseEvent.CLICK, loadData, false, 0, true);
				vGroup.addElement(_refreshImg);
			}

			vGroup.addElement(_trashImg);

			hGroup = new HGroup();
			hGroup.percentWidth = 100;
			hGroup.verticalAlign = VerticalAlign.BOTTOM;
			hGroup.addElement(_dataGrid);
			hGroup.addElement(vGroup);

			addElement(hGroup);
		}

		//----------------------------------------------------------------------
		// DIGUIInput implementation:

		override public function setFocus():void
		{
			if (enabled && _dSelectOneListingInverseJoinColumn.enabled)
				callLater(_dSelectOneListingInverseJoinColumn.setFocus);
		}

		public function clean():void
		{
			if (_dSelectOneListingJoinColumn.stage)
			_dSelectOneListingJoinColumn.clean();
			if (_dSelectOneListingInverseJoinColumn.stage)
			_dSelectOneListingInverseJoinColumn.clean();
			_dataGrid.dataProvider = new ArrayCollection();
			_selectedItemLocked1 = null;
			_dBeanCRUDParam._sql = null;
			_dBeanCRUDParam.id = null;
		}

		public function dispose():void
		{
			_dSelectOneListingInverseJoinColumn.removeEventListener(DSelectOneListingEvent._ON_CHANGE, onInverseJoinColumnSelected);
			_dataGrid.removeEventListener(DragEvent.DRAG_ENTER, onDragEnterOnTrash);
			_dataGrid.removeEventListener(DragEvent.DRAG_DROP, onDragDropOnTrash);
		}

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Public interface:

		public function mountInsertSQLQuery():String
		{
			return "insert into " + _tableName + " values (" + getJoinColumnValue() + ", " + _dSelectOneListingInverseJoinColumn.text + ")";
		}

		public function cleanInverseJoinColumnAndSetFocus():void
		{
			_dSelectOneListingInverseJoinColumn.clean();
			callLater(_dSelectOneListingInverseJoinColumn.setFocus);
		}

		public function loadData(event:Event=null):void
		{
			_dBeanCRUDParam._sql = null;
			_dBeanCRUDParam.id = getJoinColumnValue();

			new BlazeDs().invokeOld(
				XFrontConfigurator._crudServiceDestination + StrConsts._METHOD_DOTfind,
				_dBeanCRUDParam,
				function (returnObj:Object=null):void
				{
					_dataGrid.dataProvider = new ArrayCollection(returnObj as Array);
				},
				this);
		}

		public function getJoinColumnValue():String
		{
			return _showJoinColumnInput ? _dSelectOneListingJoinColumn.text : joinColumnValue;
		}

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Private interface:

		//----------------------------------------------------------------------
		// Event listeners:

		private function onInverseJoinColumnSelected(event:DSelectOneListingEvent):void
		{
			_dBeanCRUDParam._sql = mountInsertSQLQuery();

			new BlazeDs().invokeOld(
				XFrontConfigurator._crudServiceDestination + StrConsts._METHOD_DOTsaveOrUpdate,
				_dBeanCRUDParam,
				function (returnObj:Object=null):void
				{
					const theSelectedItemInverseJoinColumn:Object = _dSelectOneListingInverseJoinColumn._selectedItem;
					if (theSelectedItemInverseJoinColumn)
						(_dataGrid.dataProvider as ArrayCollection).addItem(theSelectedItemInverseJoinColumn);

					cleanInverseJoinColumnAndSetFocus();
				},
				this,
				function (error:Object=null):void
				{
					if (error && error.rootException && error.rootException.SQLState == "23505")
						DNotificator.showInfo(StrConsts.getRMString(151));
					else
						DNotificator.showError2(StrConsts.getRMString(152));
				});
		}

		private function onDragEnterOnTrash(event:DragEvent):void
		{
			DragManager.acceptDragDrop(IUIComponent(event.currentTarget));
		}

		private function onDragDropOnTrash(event:DragEvent):void
		{
			const theDataProvider:ArrayCollection = _dataGrid.dataProvider as ArrayCollection;
			const items:Array = _dataGrid.selectedItems;
			const itemsLenght:int = items.length;
			const joinColumnValue:String = getJoinColumnValue();
			var item:Object;
			var sql:String = "";
			for (var i:int = 0; i < itemsLenght; i++)
			{
				item = items[i];
				sql += "delete from " + _tableName + " where " + _joinColumn + " = " + joinColumnValue + " and " + _inverseJoinColumn + " = " + item[_dSelectOneListingInverseJoinColumn._idField] + ";";
			}

			_dBeanCRUDParam._sql = sql;

			new BlazeDs().invokeOld(
				XFrontConfigurator._crudServiceDestination + StrConsts._METHOD_DOTdelete,
				_dBeanCRUDParam,
				onDeleteOK,
				this);
		}

		private function onDeleteOK(returnObj:Object=null):void
		{
			const theDataProvider:ArrayCollection = _dataGrid.dataProvider as ArrayCollection;
			const items:Array = _dataGrid.selectedItems;
			const itemsLenght:int = items.length;
			for (var i:int = 0; i < itemsLenght; i++)
				theDataProvider.removeItemAt(theDataProvider.getItemIndex(items[i]));

			cleanInverseJoinColumnAndSetFocus();
		}

		//----------------------------------------------------------------------
	}
}
