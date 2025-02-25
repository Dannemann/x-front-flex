package br.com.dannemann.gui.component
{
	import br.com.dannemann.gui.domain.StrConsts;
	import br.com.dannemann.gui.library.DIconLibrary48;
	import br.com.dannemann.gui.library.DIconLibrary64;
	import br.com.dannemann.gui.util.DUtilComponent;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;

	import flashx.textLayout.container.ScrollPolicy;

	import mx.containers.TitleWindow;
	import mx.core.FlexGlobals;
	import mx.core.mx_internal;
	import mx.graphics.SolidColor;
	import mx.managers.PopUpManager;

	import spark.components.Group;
	import spark.components.HGroup;
	import spark.components.Label;
	import spark.components.VGroup;
	import spark.layouts.HorizontalAlign;
	import spark.layouts.VerticalAlign;
	import spark.layouts.VerticalLayout;
	import spark.primitives.BitmapImage;
	import spark.primitives.Rect;

	public final class DPrompt extends TitleWindow
	{
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Fields:

		public var _executeOnSelect:Function;

		public const _messages:Vector.<String> = new Vector.<String>();
		public const _icons:Vector.<Class> = new Vector.<Class>();
		public const _returnValues:Vector.<Object> = new Vector.<Object>();

		private var _groupsToDispose:Vector.<Group> = new Vector.<Group>();

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Overrides:

		//----------------------------------------------------------------------
		// Class Overrides:

		override protected function createChildren():void
		{
			super.createChildren();

			if (_executeOnSelect == null)
				throw new Error(" ### DPrompt.createChildren: Função de retorno não informada.");
			if (_messages.length == 0)
				throw new Error(" ### DPrompt.createChildren: Mensagem(ns) não informada(s).");

			horizontalScrollPolicy = ScrollPolicy.OFF;
			maxWidth = 400;
			maxHeight = 600;
			showCloseButton = true;
			addEventListener(KeyboardEvent.KEY_DOWN, onCloseByButton, false, 0, true);
			mx_internal::closeButton.addEventListener(MouseEvent.CLICK, onCloseByButton, false, 0, true);

			if (!title)
				title = StrConsts.getRMString(103);

			const allOptions:VGroup = new VGroup();
			allOptions.verticalAlign = VerticalAlign.MIDDLE;
			DUtilComponent.padding_BottomLeftRightTop_VGroup(allOptions, 3);
			DUtilComponent.widthHeightTo100Percent(allOptions);
			allOptions.addEventListener(Event.ADDED_TO_STAGE, whenAddedToStage, false, 0, true);

			var group:Group;
			var hGroup:HGroup;
			var rect:Rect;
			var iconBPM:BitmapImage;
			var label:Label;
			const messagesLength:int = _messages.length;
			for (var i:int = 0; i < messagesLength; i++)
			{
				iconBPM = new BitmapImage();
				iconBPM.source = _icons[i] ? _icons[i] : DIconLibrary64.MAKEFILE;
				iconBPM.smooth = true;
				iconBPM.width = 64;
				iconBPM.height = 64;

				label = new DLabel(_messages[i]);
				label.percentWidth = 100;

				hGroup = new HGroup();
				hGroup.verticalAlign = VerticalAlign.MIDDLE;
				DUtilComponent.widthHeightTo100Percent(hGroup);
				hGroup.addElement(iconBPM);
				hGroup.addElement(label);

				rect = new Rect();
				rect.fill = new SolidColor(0xFFFFFF);
				DUtilComponent.widthHeightTo100Percent2(rect);

				group = new Group();
				DUtilComponent.widthHeightTo100Percent(group);
				group.addEventListener(MouseEvent.ROLL_OVER, doChangeBackgroundColor, false, 0, true);
				group.addEventListener(MouseEvent.ROLL_OUT, doChangeBackgroundColor, false, 0, true);
				group.addEventListener(MouseEvent.CLICK, itemClicked, false, 0, true);
				group.addElement(rect);
				group.addElement(hGroup);

				allOptions.addElement(group);

				_groupsToDispose.push(group);
			}

			iconBPM = new BitmapImage();
			iconBPM.source = DIconLibrary48.CANCEL;
			iconBPM.smooth = true;

			const verticalLayout:VerticalLayout = new VerticalLayout();
			verticalLayout.gap = 0;
			verticalLayout.horizontalAlign = HorizontalAlign.CENTER;
			verticalLayout.verticalAlign = VerticalAlign.MIDDLE;
			verticalLayout.paddingBottom = 0;
			verticalLayout.paddingLeft = 0;
			verticalLayout.paddingRight = 0;
			verticalLayout.paddingTop = 0;

			const wh64:Group = new Group();
			wh64.width = 64;
			wh64.height = 64;
			wh64.layout = verticalLayout;
			wh64.addElement(iconBPM);

			label = new DLabel("Cancelar e voltar.");
			label.percentWidth = 100;

			hGroup = new HGroup();
			hGroup.verticalAlign = VerticalAlign.MIDDLE;
			DUtilComponent.widthHeightTo100Percent(hGroup);
			hGroup.addElement(wh64);
			hGroup.addElement(label);

			rect = new Rect();
			rect.fill = new SolidColor(0xFFFFFF);
			DUtilComponent.widthHeightTo100Percent2(rect);

			group = new Group();
			DUtilComponent.widthHeightTo100Percent(group);
			group.addEventListener(MouseEvent.ROLL_OVER, doChangeBackgroundColor, false, 0, true);
			group.addEventListener(MouseEvent.ROLL_OUT, doChangeBackgroundColor, false, 0, true);
			group.addEventListener(MouseEvent.CLICK, itemClicked, false, 0, true);
			group.addElement(rect);
			group.addElement(hGroup);

			allOptions.addElement(group);

			_groupsToDispose.push(group);

			addElement(allOptions);
		}

		//----------------------------------------------------------------------
		// DIGUIInput implementation:

		public function dispose():void
		{
			removeEventListener(KeyboardEvent.KEY_DOWN, onCloseByButton);
			getElementAt(0).removeEventListener(Event.ADDED_TO_STAGE, whenAddedToStage);

			if (mx_internal::closeButton)
				mx_internal::closeButton.removeEventListener(MouseEvent.CLICK, onCloseByButton);

			const groupsToDisposeLength:int = _groupsToDispose.length;
			var groupToDispose:Group;
			for (var i:int = 0; i < groupsToDisposeLength; i++)
			{
				groupToDispose = _groupsToDispose[i];
				groupToDispose.removeEventListener(MouseEvent.ROLL_OVER, doChangeBackgroundColor);
				groupToDispose.removeEventListener(MouseEvent.ROLL_OUT, doChangeBackgroundColor);
				groupToDispose.removeEventListener(MouseEvent.CLICK, itemClicked);
			}

			_groupsToDispose = null;
		}

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Public interface:

		public function show(parent:DisplayObject=null):void
		{
			PopUpManager.addPopUp(this, parent ? parent : FlexGlobals.topLevelApplication as DisplayObject, true);
			PopUpManager.centerPopUp(this);
		}

		public function remove():void
		{
			dispose();
			PopUpManager.removePopUp(this);
		}

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Private interface:

		private function whenAddedToStage(event:Event):void
		{
			if (event.currentTarget.stage)
				callLater(event.currentTarget.setFocus);
		}

		private function onCloseByButton(event:Event=null):void
		{
			if (event is KeyboardEvent)
			{
				if ((event as KeyboardEvent).keyCode == Keyboard.ESCAPE)
					doOnCloseByButton();
			}
			else
				doOnCloseByButton();
		}

		private function doOnCloseByButton(event:Event=null):void
		{
			_executeOnSelect((getElementAt(0) as VGroup).numElements - 1);
			remove();
		}

		private function doChangeBackgroundColor(event:MouseEvent):void
		{
			if (event.type == MouseEvent.ROLL_OVER)
				((event.currentTarget as Group).getElementAt(0) as Rect).fill = new SolidColor(0xB2E1FF);
			else
				((event.currentTarget as Group).getElementAt(0) as Rect).fill = new SolidColor(0xFFFFFF);
		}

		private function itemClicked(event:MouseEvent):void
		{
			_executeOnSelect((getElementAt(0) as VGroup).getElementIndex((event.currentTarget as Group)));
			remove();
		}

		//----------------------------------------------------------------------
	}
}

