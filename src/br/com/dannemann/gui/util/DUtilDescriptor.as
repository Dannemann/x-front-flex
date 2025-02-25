package br.com.dannemann.gui.util
{
	import br.com.dannemann.gui.domain.StrConsts;
	import br.com.dannemann.gui.bean.FieldDescriptorBean;
	import br.com.dannemann.gui.controller.EntityDescriptor;

	public final class DUtilDescriptor
	{
		// TODO: Remove this?
//		public static function populateObjWithMainIDAndMainDescriptorFieldsNames(entityBeanDescriptorsHandler:EntityBeanDescriptorsHandler, objHolder:Object):void
//		{
//			const fieldsDescriptors:Vector.<DBeanFieldDescriptor> = entityBeanDescriptorsHandler._fieldDescriptors;
//			const fieldsDescriptorsLength:int = fieldsDescriptors.length;
//			var fieldDescriptor:DBeanFieldDescriptor;
//			for (var i:int = 0; i < fieldsDescriptorsLength; i++)
//			{
//				fieldDescriptor = fieldsDescriptors[i];
//
//				if (fieldDescriptor._isMainID)
//					objHolder[DFxGUIConstants._STR_mainID] = fieldDescriptor._javaField;
//				else if (fieldDescriptor._isDescriptionField)
//					objHolder[DFxGUIConstants._STR_descriptorField] = fieldDescriptor._javaField;
//			}
//		}

		public static function findIDFieldDescriptor(entityBeanDescriptorsHandler:EntityDescriptor):FieldDescriptorBean
		{
			const fieldsDescriptors:Array = entityBeanDescriptorsHandler._fields;
			const fieldsDescriptorsLength:int = fieldsDescriptors.length;
			var fieldDescriptor:FieldDescriptorBean;
			for (var i:int = 0; i < fieldsDescriptorsLength; i++)
			{
				fieldDescriptor = fieldsDescriptors[i];

				if (fieldDescriptor._isMainID)
					return fieldDescriptor;
			}

			return null;
		}

		public static function isNumericType(fieldDescriptor:FieldDescriptorBean):Boolean
		{
			const javaType:String = fieldDescriptor._javaType;

			return (
				(javaType == StrConsts._JAVA_TYPE_Short) ||
				(javaType == StrConsts._JAVA_TYPE_Integer) ||
				(javaType == StrConsts._JAVA_TYPE_Long)
			);
		}
	}
}
