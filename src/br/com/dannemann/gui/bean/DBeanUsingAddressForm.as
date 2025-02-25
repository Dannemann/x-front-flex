package br.com.dannemann.gui.bean
{
	import br.com.dannemann.gui.domain.StrConsts;
	import br.com.dannemann.gui.component.addressing.brazil.DAddressFormBrazil;

	public final class DBeanUsingAddressForm implements DIBean
	{
		public var _index:String;
		public var _tabNavigatorIndex:String;
		public var _hasOverrides:Boolean;
		public var _validationMode:String = DAddressFormBrazil._VALIDATION_MODE_ALL_FIELDS_REQUIRED;

		public function DBeanUsingAddressForm(object:Object=null)
		{
			if (object)
				fillMe(object);
		}

		public function fillMe(object:Object):void
		{
			if (object is String)
			{
				const usingAddressFormStr:String = object as String;

				if (usingAddressFormStr)
				{
					const doubleSemicolonSplitted:Array = usingAddressFormStr.split(StrConsts._CHAR_SEMICOLON_DOUBLE);
					const doubleSemicolonSplittedLength:int = doubleSemicolonSplitted.length;

					if (doubleSemicolonSplitted)
					{
						var doubleSemicolonValue:String;
						var doubleSemicolonValueSemicolonSplitted:Array;
						var key:String;
						var value:String;

						for (var i:int = 0; i < doubleSemicolonSplittedLength; i++)
						{
							doubleSemicolonValue = doubleSemicolonSplitted[i];

							if (doubleSemicolonValue)
							{
								doubleSemicolonValueSemicolonSplitted = doubleSemicolonValue.split(StrConsts._CHAR_EQUAL);

								if (doubleSemicolonValueSemicolonSplitted)
								{
									key = doubleSemicolonValueSemicolonSplitted[0];
									value = doubleSemicolonValueSemicolonSplitted[1];

									if (key == StrConsts._D_PROPERTY_index)
										_index = value.toString();
									else if (key == StrConsts._D_PROPERTY_tabNavigatorIndex)
										_tabNavigatorIndex = value.toString();
									else if (key == StrConsts._D_PROPERTY_hasOverrides)
									{
										if (value == StrConsts._FLEX_STYLE_VALUE_TRUE)
											_hasOverrides = true;
									}
									else if (key == StrConsts._D_PROPERTY_validationMode)
										_validationMode = String(value);
								}
							}
						}
					}
				}
				else
					throw new Error(" ### DBeanUsingAddressForm.fillMe: usingAddressFormStr String é nulo.");
			}
			else
				throw new Error(" ### DBeanUsingAddressForm.fillMe: Este método deve receber uma String como parâmetro.");
		}
	}
}
