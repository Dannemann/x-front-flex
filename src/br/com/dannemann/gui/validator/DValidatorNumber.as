package br.com.dannemann.gui.validator
{
	import br.com.dannemann.gui.domain.StrConsts;
	import br.com.dannemann.gui.formatter.DFormatterBrazilianDecimal;
	import br.com.dannemann.gui.util.DUtilJava;
	
	import mx.core.UIComponent;
	import mx.validators.NumberValidator;

	public final class DValidatorNumber extends NumberValidator
	{
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Fields:
		
		protected var javaType:String;
		public function get _javaType():String
		{
			return javaType;
		}
		public function set _javaType(value:String):void
		{
			javaType = value;
			
			if (javaType)
			{
				if (DUtilJava.isJavaLangShort(javaType))
				{
					maxValue = DUtilJava._JAVA_LANG_SHORT_MAX_VALUE;
					minValue = DUtilJava._JAVA_LANG_SHORT_MIN_VALUE;
				}
				else if (DUtilJava.isJavaLangInteger(javaType))
				{
					maxValue = DUtilJava._JAVA_LANG_INTEGER_MAX_VALUE;
					minValue = DUtilJava._JAVA_LANG_INTEGER_MAX_VALUE;
				}
				else if (DUtilJava.isJavaLangLong(javaType))
				{
					maxValue = DUtilJava._JAVA_LANG_LONG_MAX_VALUE;
					minValue = DUtilJava._JAVA_LANG_LONG_MIN_VALUE;
				}
			}
		}
		
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Constructor:
		
		public function DValidatorNumber(javaType:String=null)
		{
			_javaType = javaType;
		}
		
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Overrides:
		
		//----------------------------------------------------------------------
		// Class Overrides:
		
		override protected function doValidation(value:Object):Array
		{
			const results:Array = super.doValidation(value);
			hackForSDK35Bug22911ToRemoveRepeatingErrorMessages();
			return results;
		}
		
		override public function get exceedsMaxError():String
		{
			if (javaType)
			{
				const dfbd:DFormatterBrazilianDecimal = new DFormatterBrazilianDecimal();
				
				if (DUtilJava.isJavaLangShort(javaType))
					return StrConsts.getRMString(159) + " " + dfbd.format(DUtilJava._JAVA_LANG_SHORT_MAX_VALUE); 
				else if (DUtilJava.isJavaLangInteger(javaType))
					return StrConsts.getRMString(159) + " " + dfbd.format(DUtilJava._JAVA_LANG_INTEGER_MAX_VALUE); 
				else if (DUtilJava.isJavaLangLong(javaType))
					return StrConsts.getRMString(159) + " " + dfbd.format(DUtilJava._JAVA_LANG_LONG_MAX_VALUE); 
			}
			
			return super.exceedsMaxError;
		}
		
		override public function get lowerThanMinError():String
		{
			if (javaType)
			{
				const dfbd:DFormatterBrazilianDecimal = new DFormatterBrazilianDecimal();
				
				if (DUtilJava.isJavaLangShort(javaType))
					return StrConsts.getRMString(160) + " " + dfbd.format(DUtilJava._JAVA_LANG_SHORT_MIN_VALUE); 
				else if (DUtilJava.isJavaLangInteger(javaType))
					return StrConsts.getRMString(160) + " " + dfbd.format(DUtilJava._JAVA_LANG_INTEGER_MIN_VALUE); 
				else if (DUtilJava.isJavaLangLong(javaType))
					return StrConsts.getRMString(160) + " " + dfbd.format(DUtilJava._JAVA_LANG_LONG_MIN_VALUE); 
			}
			
			return super.lowerThanMinError;
		}
		
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Protected interface:
		
		protected function hackForSDK35Bug22911ToRemoveRepeatingErrorMessages():void
		{
			const uiComponent:UIComponent = source as UIComponent;
			
			uiComponent.callLater(
				function (uiComponent:UIComponent):void
				{
					uiComponent.errorString = uiComponent.errorString.split("\n")[0];
				},
				[ uiComponent ]);
		}
		
		//----------------------------------------------------------------------
	}
}
