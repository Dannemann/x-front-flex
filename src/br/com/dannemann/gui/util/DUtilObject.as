package br.com.dannemann.gui.util
{
	import br.com.dannemann.gui.domain.StrConsts;

	import mx.utils.ObjectUtil;

	public final class DUtilObject
	{
		public static function getLength(obj:Object):int
		{
			var i:int = 0;
			for (var key:String in obj)
				i++;

			return i;
		}

		public static function navigateToPropertyAndGetValue(propertyToFind:String, target:Object):String
		{
			const propertiesToFind:Array = propertyToFind.split(StrConsts._CHAR_DOT);
			const propertiesToFindLength:int = propertiesToFind.length;
			var propertyValue:Object = null;

			for (var i:int = 0; i < propertiesToFindLength; i++)
			{
				if (!propertyValue)
				{
					propertyValue = target[propertiesToFind[i]];

					if (propertyValue is Object)
						continue;
				}
				else
				{
					if (propertyValue is String)
						return propertyValue as String;
					else
					{
						propertyValue = propertyValue[propertiesToFind[i]];

						if (propertyValue is String || propertyValue is Number)
							return propertyValue.toString();
						else
							continue;
					}
				}
			}

			return null;
		}

		// TODO: Método feito sem nenhuma metodologia. Verificar se funciona corretamente.
		public static function navigateToPropertyAndSetValue(propertyToFind:String, target:Object, valueToAdd:Object):void
		{
			const propertiesToFind:Array = propertyToFind.split(StrConsts._CHAR_DOT);
			const propertiesToFindLength:int = propertiesToFind.length;
			var propertyValue:Object = null;
			var javaField:String = null;

			for (var i:int = 0; i < propertiesToFindLength; i++)
			{
				javaField = String(propertiesToFind[i]);

				if (!propertyValue)
				{
					propertyValue = target[javaField];

					if (propertyValue is Object)
						continue;
					else
						return;
				}
				else
				{
					if (i == (propertiesToFindLength - 1))
						propertyValue[javaField] = valueToAdd;
					else
					{
						if (propertyValue is Object)
						{
							if (!propertyValue[javaField])
							{
								propertyValue[javaField] = new Object();
								propertyValue = propertyValue[javaField];
								continue;
							}

							propertyValue = propertyValue[javaField];
							continue;
						}
					}
				}
			}
		}

		public static function removeAllObjectAndObjectProxyProperties(object:Object):Object
		{
			const newObject:Object = new Object();

			const classInfo:Object = ObjectUtil.getClassInfo(object);
			const props:Array = classInfo.properties;
			const propsLen:int = props.length;
			var prop:Object;
			for (var i:int = 0; i < propsLen; i++)
			{
				prop = props[i];
				newObject[prop.localName] = object[prop];
			}

			return newObject;
		}
	}
}
