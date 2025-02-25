package br.com.dannemann.gui.controller
{
	import mx.resources.ResourceManager;
	import mx.utils.StringUtil;
	
	import br.com.dannemann.gui.XFrontConfigurator;
	import br.com.dannemann.gui.domain.StrConsts;
	import br.com.dannemann.gui.util.DUtilString;

	public final class ServerVarsDecoder
	{
		//----------------------------------------------------------------------
		// Fields:

		public var _serverVarStr:String;
		public var _isServerVar:Boolean;

		//----------------------------------------------------------------------
		// Constructor:

		public function ServerVarsDecoder(serverVarStr:String)
		{
			_serverVarStr = serverVarStr;
			_isServerVar = isServerVar();
		}

		//----------------------------------------------------------------------
		// Public interface:

		public function getValue():String
		{
			if (_isServerVar)
				return _serverVarStr.substr(2, _serverVarStr.indexOf(StrConsts._CHAR_SERVER_VAR_VALUE_END) - 2);
			else
				return _serverVarStr;
		}

		public function getMessageType():int
		{
			if (_isServerVar)
				return int(_serverVarStr.substr(_serverVarStr.indexOf(StrConsts._CHAR_SERVER_VAR_VALUE_END) + 1, 1));
			else
				return -1;
		}

		public function getResourceBundleSource():String
		{
			if (_isServerVar)
			{
				const value:String = _serverVarStr.split(StrConsts._CHAR_SEMICOLON_DOUBLE)[1] as String;
				return value ? value : null;
			}
			else
				return null;
		}





		public static function hasNamedDVarWithin(string:String, dVarName:String=null):Boolean
		{
			return new RegExp("\\$" + dVarName + "{.+}", "is").test(string);
		}

		public static function getNamedDVarValue(string:String, dVarName:String):String
		{
			const regExp:RegExp = new RegExp("\\$" + dVarName + "{(\\w+)}", "is");
			if (regExp.test(string))
				return regExp.exec(string)[1];
			else
				return null;
		}

		public static function getNamedDVarValues(string:String, dVarName:String):Array
		{
			const regExp:RegExp = new RegExp("\\$" + dVarName + "{(.+)}", "is");
			if (regExp.test(string))
				return regExp.exec(string);
			else
				return null;
		}

		public static function removeNamedDVar(string:String, dVarName:String):String
		{
			const regExp:RegExp = new RegExp("\\$" + dVarName + "{\\w+}", "is");
			if (regExp.test(string))
				return StringUtil.trim(string.replace(regExp, StrConsts._CHAR_EMPTY_STRING));
			else
				return string;
		}

		public static function removeAllNamedDVars(string:String):String
		{
			return StringUtil.trim(string.split(/\$\w+{\w+}/is).join(StrConsts._CHAR_EMPTY_STRING));
		}

		public static function getMessageDVarValue(string:String):String
		{
			const regExp:RegExp = /\${(.+)}/is;
			if (regExp.test(string))
				return regExp.exec(string)[1];
			else
				return null;
		}

		public static function replaceAllMessageDVars(targetString:String, origin:String="erpro_flex_locale"):String
		{
			const regExp:RegExp = /\${\w+}/is;

			if (origin == "erpro_flex_locale")
			{
				while (regExp.test(targetString))
					targetString = targetString.replace(regExp, ResourceManager.getInstance().getString(XFrontConfigurator._applicationResourceBundle, getMessageDVarValue(targetString)));
			}
			else if (origin == "xfront_flex_locale")
			{
				while (regExp.test(targetString))
					targetString = targetString.replace(regExp, StrConsts.getRMString2(getMessageDVarValue(targetString)));
			}

			return StringUtil.trim(targetString);
		}

		public static function replaceAllNamedDVars(targetString:String, dVarName:String, origin:String="erpro_flex_locale"):String
		{
			const regExp:RegExp = new RegExp("\\$" + dVarName + "{.+}", "is");

			if (origin == "erpro_flex_locale")
			{
				while (regExp.test(targetString))
					targetString = targetString.replace(regExp, ResourceManager.getInstance().getString(XFrontConfigurator._applicationResourceBundle, getMessageDVarValue(targetString)));
			}
			else if (origin == "xfront_flex_locale")
			{
				while (regExp.test(targetString))
					targetString = targetString.replace(regExp, StrConsts.getRMString2(getMessageDVarValue(targetString)));
			}

			return StringUtil.trim(targetString);
		}

		public static function replaceMessageDVarCode(code:String, origin:String="erpro_flex_locale"):String
		{
			return replaceAllMessageDVars("${" + code + "}", origin);
		}

		//----------------------------------------------------------------------
		// Private interface:

		private function isServerVar():Boolean
		{
			return _serverVarStr && (DUtilString.startsWith(_serverVarStr, StrConsts._CHAR_SERVER_VAR_VALUE_BEGIN)) && (_serverVarStr.indexOf(StrConsts._CHAR_SERVER_VAR_VALUE_END) != -1);
		}

		//----------------------------------------------------------------------
	}
}
