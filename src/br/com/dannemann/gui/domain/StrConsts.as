package br.com.dannemann.gui.domain
{
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	import spark.formatters.DateTimeFormatter;

	public final class StrConsts
	{
		//----------------------------------------------------------------------
		// Strings:

		public static const _BLAZEDS_BlazeDSDefaultRemotingDestination:String = "BlazeDSDefaultRemotingDestination";
		public static const _DSOL_XML_MENU_STRING_1:String = "<xmlTag label=\"";
		public static const _DSOL_XML_MENU_STRING_2:String = "\" bean=\"";
		public static const _DSOL_XML_MENU_STRING_3:String = "\" />";
		public static const _METHOD_DOTmerge:String = ".merge";
		public static const _METHOD_DOTsaveOrUpdate:String = ".saveOrUpdate";
		public static const _METHOD_DOTdelete:String = ".delete";
		public static const _METHOD_DOTfind:String = ".find";
		public static const _METHOD_DOTfindColumnsWhereLikeOrEqual:String = ".findColumnsWhereLikeOrEqual";
		public static const _METHOD_DOTfindByExample:String = "findByExample";
//		public static const _METHOD_DOTfindAll:String = "findAll";
		public static const _METHOD_DOTfindObj_ByID:String = ".findObj_ByID";
		public static const _METHOD_customGroupingFunctionDefaultName:String = "myGroupingFunction";
		public static const _SERVICE_FileUploaderDynamicDestinationResolver:String = "br.com.dannemann.core.dgui.service.FileUploaderDynamicDestinationResolver.resolveDynamicDestination";;
		public static const _D_PREFIX_thisDOT:String = "this.";
		public static const _D_PROPERTY_index:String = "index";
		public static const _D_PROPERTY_tabNavigatorIndex:String = "tabNavigatorIndex";
		public static const _D_PROPERTY_hasOverrides:String = "hasOverrides";
		public static const _D_PROPERTY_validationMode:String = "validationMode";

		//Map<String, Object> deleteOnEnterpriseHomeFolder(

		public static const _CHAR_ASTERISK:String = "*";
		public static const _CHAR_ASTERISKX5:String = "*****";
		public static const _CHAR_COLON:String = ":";
		public static const _CHAR_COLON_SPACE:String = ": ";
		public static const _CHAR_COMMA:String = ",";
		public static const _CHAR_DASH:String = "-";
		public static const _CHAR_DOT:String = ".";
		public static const _CHAR_EMPTY_STRING:String = "";
		public static const _CHAR_EQUAL:String = "=";
		public static const _CHAR_ETCETERA:String = "...";
		public static const _CHAR_EXCLAMATION_MARK:String = "!";
		public static const _CHAR_LINE_BREAK:String = "\n";
		public static const _CHAR_LINE_BREAK_DOUBLE:String = "\n\n";
		public static const _CHAR_M:String = "M";
		public static const _CHAR_F:String = "F";
		public static const _CHAR_FORWARD_SLASH:String = "/";
		public static const _CHAR_PERCENT:String = "%";
		public static const _CHAR_SEMICOLON:String = ";";
		public static const _CHAR_SEMICOLON_DOUBLE:String = ";;";
		public static const _CHAR_SPACE:String = " ";
		public static const _CHAR_SERVER_VAR_VALUE_BEGIN:String = "${";
		public static const _CHAR_SERVER_VAR_VALUE_END:String = "}";
		public static const _CHAR_UNDERSCORE:String = "_";

		public static const _COLOR_BLUE_BIRD:String = "4973AB"; // TODO: Add "0x".
		public static const _COLOR_BLUE_SKY:String = "D0DCEE"; // TODO: Add "0x".
		public static const _COLOR_GREEN_OLD_MONEY:String = "0x337147";
		public static const _COLOR_YELLOW_GOLD:String = "8B7500"; // TODO: Add "0x".
		public static const _COLOR_RED_FIREBRICK:String = "0xB22222"; // TODO: Add "0x".
		public static const _COLOR_GRAY48:String = "0x7A7A7A";
		public static const _COLOR_PINK1:String = "0xFF00FF";

		public static const _COLOR_RED_FIREBRICK_HTML:String = "#B22222";

		public static const _EVENT_inputMaskEnd:String = "inputMaskEnd";
		public static const _EVENT_change:String = "change";
		public static const _DMODULE_SERVICE_SAVE:String = "br.com.erpro.web.service.module.ERProFxModuleService.save"; // TODO: Externalizar (tentar colocar no DjCore [atualmente em ERProWeb]) como serviço EJB3.
		public static const _FLEX_PROPERTY_CHILDREN:String = "children";
		public static const _FLEX_PROPERTY_MX_INTERNAL_UID:String = "mx_internal_uid";
		public static const _FLEX_PROPERTY_ITEM:String = "item";
		public static const _FLEX_PROPERTY_REVERSE:String = "reverse";
		public static const _FLEX_PROPERTY_selectedItem:String = "selectedItem";
		public static const _FLEX_STYLE_PROPERTY_ALPHA:String = "alpha";
		public static const _FLEX_STYLE_PROPERTY_BACKGROUND_ALPHA:String = "backgroundAlpha";
		public static const _FLEX_STYLE_PROPERTY_BACKGROUND_COLOR:String = "backgroundColor";
		public static const _FLEX_STYLE_PROPERTY_BORDER_ALPHA:String = "borderAlpha";
		public static const _FLEX_STYLE_PROPERTY_BORDER_COLOR:String = "borderColor";
		public static const _FLEX_STYLE_PROPERTY_COLOR:String = "color";
		public static const _FLEX_STYLE_PROPERTY_CORNER_RADIUS:String = "cornerRadius";
		public static const _FLEX_STYLE_PROPERTY_CREATION_COMPLETE_EFFECT:String = "creationCompleteEffect";
		public static const _FLEX_STYLE_PROPERTY_errorColor:String = "errorColor";
		public static const _FLEX_STYLE_PROPERTY_FONTWEIGHT:String = "fontWeight";
		public static const _FLEX_STYLE_PROPERTY_ICON:String = "icon";
		public static const _FLEX_STYLE_PROPERTY_HORIZONTAL_ALIGN:String = "horizontalAlign";
		public static const _FLEX_STYLE_PROPERTY_VERTICAL_ALIGN:String = "verticalAlign";
		public static const _FLEX_STYLE_PROPERTY_PADDING_BOTTOM:String = "paddingBottom";
		public static const _FLEX_STYLE_PROPERTY_PADDING_LEFT:String = "paddingLeft";
		public static const _FLEX_STYLE_PROPERTY_PADDING_RIGHT:String = "paddingRight";
		public static const _FLEX_STYLE_PROPERTY_PADDING_TOP:String = "paddingTop";
		public static const _FLEX_STYLE_PROPERTY_REMOVED_EFFECT:String = "removedEffect";
		public static const _FLEX_STYLE_PROPERTY_SHOW_EFFECT:String = "showEffect";
		public static const _FLEX_STYLE_PROPERTY_HIDE_EFFECT:String = "hideEffect";
		public static const _FLEX_STYLE_PROPERTY_SKIN_CLASS:String = "skinClass";
		public static const _FLEX_STYLE_PROPERTY_TEXT_INPUT_STYLE_NAME:String = "textInputStyleName";
		public static const _FLEX_STYLE_VALUE_AUTO:String = "auto";
		public static const _FLEX_STYLE_VALUE_BOLD:String = "bold";
		public static const _FLEX_STYLE_VALUE_BOTTOM:String = "bottom";
		public static const _FLEX_STYLE_VALUE_LEFT:String = "left";
		public static const _FLEX_STYLE_VALUE_RED:String = "Red";
		public static const _FLEX_STYLE_VALUE_RIGHT:String = "right";
		public static const _FLEX_STYLE_VALUE_TRUE:String = "true";
		public static const _FLEX_STYLE_VALUE_FALSE:String = "false";

		public static const _JAVA_TYPE_Boolean:String = "java.lang.Boolean";
		public static const _JAVA_TYPE_Date:String = "java.util.Date";
		public static const _JAVA_TYPE_Double:String = "java.lang.Double";
		public static const _JAVA_TYPE_Float:String = "java.lang.Float";
		public static const _JAVA_TYPE_Integer:String = "java.lang.Integer";
		public static const _JAVA_TYPE_Long:String = "java.lang.Long";
		public static const _JAVA_TYPE_NumberFormatException:String = "java.lang.NumberFormatException";
		public static const _JAVA_TYPE_Short:String = "java.lang.Short";
		public static const _JAVA_TYPE_String:String = "java.lang.String";

		public static const _MASK_HOUR:String = "##:##";
		public static const _REGEXP_RESTRICT_INTEGER:String = "[0-9]";
		public static const _REGEXP_RESTRICT_DECIMAL:String = "[0-9.,]";
		public static const _REGEXP_RESTRICT_TO_ANYLETTER_NUMBER_SPACE:String = "[A-Za-z0-9ÁÉÍÓÚáéíóúÀÈÌÒÙàèìòùÂÊÎÔÛâêîôûÃÕãõÄËÏÖÜäëïöü ]";
		public static const _REGEXP_RESTRICT_U001B:String = "^\u001b";
		public static const _STR_0:String = "0";
		public static const _STR_01:String = "01";
		public static const _STR_1900:String = "1900";
		public static const _STR_00000000000:String = "00000000000";
		public static const _STR_11111111111:String = "11111111111";
		public static const _STR_22222222222:String = "22222222222";
		public static const _STR_33333333333:String = "33333333333";
		public static const _STR_44444444444:String = "44444444444";
		public static const _STR_55555555555:String = "55555555555";
		public static const _STR_66666666666:String = "66666666666";
		public static const _STR_77777777777:String = "77777777777";
		public static const _STR_88888888888:String = "88888888888";
		public static const _STR_99999999999:String = "99999999999";
		public static const _STR_CLASS_NAME_DTextInput:String = "DTextInput";
		public static const _STR_CLASS_NAME_DTextInputID:String = "DTextInputID";
		public static const _STR_CLASS_NAME_DTextInputCNPJ:String = "DTextInputCnpj";
		public static const _STR_CLASS_NAME_DTextInputCPF:String = "DTextInputCpf";
		public static const _STR_CEP:String = "CEP";
		public static const _STR_CNPJ:String = "CNPJ";
		public static const _STR_CPF:String = "CPF";
		public static const _STR_UF:String = "UF";
		public static const _STR_code:String = "code";
		public static const _STR_DAddressInput:String = "DAddressInput";
		public static const _STR_DATE_FORMAT_STRING:String = "DD/MM/YYYY";
		public static const _STR_DATE_HOUR_FORMAT_STRING_4_INPUT:String = "DD/MM/YYYY HH:MM";
		public static const _STR_DATE_HOUR_FORMAT_STRING:String = "DD/MM/YYYY JJ:NN";
		public static const _STR_descriptorField:String = "descriptorField";
		public static const _STR_descriptorProperty:String = "descriptorProperty";
		public static const _STR_hasGreenCard:String = "hasGreenCard";
		public static const _STR_id:String = "id";
		public static const _STR_idDesc:String = "id:desc";
		public static const _STR_label:String = "label";
		public static const _STR_mainID:String = "mainID";
		public static const _STR_data:String = "data";
		public static const _STR_d:String = "d";
		public static const _STR_D:String = "D";
		public static const _STR_M:String = "M";
		public static const _STR_Y:String = "Y";
		public static const _STR_now:String = "now";
		public static const _STR_searchField:String = "searchField";
		public static const _STR_set:String = "set";
		public static const _STR_text:String = "text";
		public static const _STR_TypeFullClassName:String = "TypeFullClassName";
		public static const _STR_version:String = "version";
		public static const _STR_enterprise_WITH_SLASHES:String = "/enterprise/";

		//----------------------------------------------------------------------
		// Regular expressions:
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		//----------------------------------------------------------------------
		// Images:

		[Embed(source="assets/image/abstract-blue.jpg")]
		public static const _IMG_ABSTRACT_BLUE:Class;
		[Embed(source="assets/image/cancel.png")]
		public static const _IMG_CANCEL:Class;
		[Embed(source="br/com/dannemann/gui/component/container/mdi/assets/img/closeButton.png")]
		public static const _IMG_CLOSE:Class;
		[Embed(source="assets/image/delete.png")]
		public static const _IMG_DELETE:Class;
		[Embed(source="assets/image/error.png")]
		public static const _IMG_ERROR:Class;
		[Embed(source="assets/image/execute.png")]
		public static const _IMG_EXECUTE:Class;
		[Embed(source="assets/image/globe-connected.png")]
		public static const _IMG_GLOBE_CONNECTED:Class;
		[Embed(source="assets/image/globe-disconnected.png")]
		public static const _IMG_GLOBE_DISCONNECTED:Class;
		[Embed(source="assets/image/google48.png")]
		public static const _IMG_GOOGLE48:Class;
		[Embed(source="assets/image/groupBy.png")]
		public static const _IMG_GROUP_BY:Class;
		[Embed(source="assets/image/help.png")]
		public static const _IMG_HELP:Class;
		[Embed(source="assets/image/info.png")]
		public static const _IMG_INFO:Class;
		[Embed(source="assets/image/new.png")]
		public static const _IMG_NEW:Class;
		[Embed(source="assets/image/save.png")]
		public static const _IMG_SAVE:Class;
		[Embed(source="assets/image/table-add.png")]
		public static const _IMG_TABLEADD:Class;
		[Embed(source="assets/image/table-delete.png")]
		public static const _IMG_TABLEDELETE:Class;
		[Embed(source="assets/image/tree.png")]
		public static const _IMG_TREE:Class;
		[Embed(source="assets/image/tree-deny.png")]
		public static const _IMG_TREEDENY:Class;

		
		
		
		
		
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Resource manager:
		
		public static const _SUPPORTED_LOCALES:Array = [ { label:"English", tag:"en_US" }, { label:"Português", tag:"pt_BR" } ];
		
		private static const _RM_INSTANCE:IResourceManager = ResourceManager.getInstance();
		private static const _XFRONT_RESOURCE_BUNDLE:String = "xfront_flex_locale";
		
		private static const _localeDateFormatter:DateTimeFormatter = new DateTimeFormatter();
		
		public static function defaultLocale():String
		{
			return _localeDateFormatter.actualLocaleIDName.replace("-", "_");
		}
		
		public static function getRMString(propertyId:int):String
		{
			return _RM_INSTANCE.getString(_XFRONT_RESOURCE_BUNDLE, String(propertyId));
		}

		public static function getRMString2(propertyId:String):String
		{
			return _RM_INSTANCE.getString(_XFRONT_RESOURCE_BUNDLE, propertyId);
		}

		public static function getRMErrorString(propertyID:String):String
		{
			return _RM_INSTANCE.getString(_XFRONT_RESOURCE_BUNDLE, "104") + " " + propertyID + ":\n\n" + _RM_INSTANCE.getString(_XFRONT_RESOURCE_BUNDLE, propertyID);
		}

//		public static function resolveLocale():String
//		{
//			var localeTag:String = DSession._localeTag;
//			
//			if (!localeTag)
//				localeTag = defaultLocale();
//			
//			return localeTag;
//		}

		//----------------------------------------------------------------------
	}
}
