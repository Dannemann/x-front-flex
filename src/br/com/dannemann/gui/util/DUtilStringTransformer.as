package br.com.dannemann.gui.util
{
	import br.com.dannemann.gui.controller.ServerVarsDecoder;

	import mx.collections.ArrayList;
	import mx.utils.StringUtil;

	/**
	 * <p>Transform custom predefined Strings into objects based on predefined
	 * rules. Currently, there is 1 transformation type available. All String
	 * formats (transformation types) are listed below:</p>
	 *
	 * <p><b>Type 1:</b> A list of Objects with populated properties (like a
	 * Vector.&lt;Object&gt; or an ArrayList of Objects) in a String representation.
	 * The items (the Objects), by default, are separated with a double semicolon
	 * (;;) and and the properties of the Object with a single semicolon (;).
	 * The property/value pairs are separated by an equal sign (=), like a
	 * typical properties file. All the characters used to split the String information
	 * can be overridden on the transformation method calls.<br />
	 * <b> - Example String:</b> <code>"propertyName11=value 1;propertyName12=value 2;;propertyName21=value 3;propertyName22=value 4"</code></p>
	 *
	 * <p><b>Type 2:</b> A comma-separated values (CSV) line. The character used to split
	 * the String values can be overridden on the transformation method calls.<br />
	 * <b> - Example String:</b> <code>"value 1,value 2,value 3,value 4,value 5"</code></p>
	 *
	 * <p><b>Type 3:</b> A comma-separated values (CSV) line where each value
	 * represents a property/value pair. The property/value pairs are separated by
	 * an equal sign (=), like a typical properties file. The characters used to
	 * split the String properties and values can be overridden on the transformation method calls.<br />
	 * <b> - Example String:</b> <code>"propertyName1=value 1,propertyName2=value 2,propertyName3=value 3,propertyName4=value 4"</code></p>
	 */
	public final class DUtilStringTransformer
	{
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Public static interface:

		//----------------------------------------------------------------------
		// Type 1:

		/**
		 * <p>Transform a String of type 1 into a Vector.&lt;Object&gt;.</p>
		 *
		 * @param type1String The type 1 String. If this is null or an empty String, this method will return null.
		 * @param entriesSeparator The String that separate the entries on <code>type1String</code> (default <code>";;"</code>).
		 * @param propertiesSeparator The String that separate the properties on <code>type1String</code> (default <code>";"</code>).
		 * @param propertyValueSeparator The String that separate the properties from it's values (default <code>"="</code>).
		 *
		 * @return A populated Vector.&lt;Object&gt;.
		 *
		 * @see #transformation1IntoArrayList()
		 */
		public static function transformation1IntoVector(type1String:String, entriesSeparator:String=";;", propertiesSeparator:String=";", propertyValueSeparator:String="="):Vector.<Object>
		{
			if (type1String)
			{
				var i:int;
				var j:int;
				var entryObject:Object;
				var entry:String;
				var entryPropertiesArray:Array;
				var numberOfProperties:int;
				var propertyAndValue:String;
				var propertyValueArray:Array;
				var propertyValueArrayLength:int;
				var property:String;
				const entriesVector:Vector.<Object> = new Vector.<Object>();
				const entriesSplittedBySeparator:Array = type1String.split(entriesSeparator);

				if (entriesSplittedBySeparator)
				{
					const numberOfEntries:int = entriesSplittedBySeparator.length;
					for (i = 0; i < numberOfEntries; i++)
					{
						entryObject = new Object();
						entry = entriesSplittedBySeparator[i];

						if (entry)
						{
							entryPropertiesArray = entry.split(propertiesSeparator);

							if (entryPropertiesArray)
							{
								numberOfProperties = entryPropertiesArray.length;
								for (j = 0; j < numberOfProperties; j++)
								{
									propertyAndValue = entryPropertiesArray[j];

									if (propertyAndValue)
									{
										propertyValueArray = propertyAndValue.split(propertyValueSeparator);

										if (propertyValueArray)
										{
											propertyValueArrayLength = propertyValueArray.length;
											property = StringUtil.trim(propertyValueArray[0]);

											if (propertyValueArrayLength == 2)
												entryObject[property] = StringUtil.trim(ServerVarsDecoder.replaceAllMessageDVars(propertyValueArray[1]));
											else if (propertyValueArrayLength == 1)
												entryObject[property] = null;
										}
									}
								}
							}
						}

						entriesVector.push(entryObject);
					}
				}

				return entriesVector;
			}
			else
				return null;
		}

		/**
		 * <p>Transform a String of type 1 into an ArrayList.</p>
		 *
		 * @param type1String The type 1 String. If this is null or an empty String, this method will return null.
		 * @param entriesSeparator The String that separate the entries on <code>type1String</code> (default <code>";;"</code>).
		 * @param propertiesSeparator The String that separate the properties on <code>type1String</code> (default <code>";"</code>).
		 * @param propertyValueSeparator The String that separate the properties from it's values (default <code>"="</code>).
		 *
		 * @return A populated ArrayList.
		 *
		 * @see #transformation1IntoVector()
		 */
		public static function transformation1IntoArrayList(type1String:String, entriesSeparator:String=";;", propertiesSeparator:String=";", propertyValueSeparator:String="="):ArrayList
		{
			if (type1String)
			{
				var i:int;
				var j:int;
				var entryObject:Object;
				var entry:String;
				var entryPropertiesArray:Array;
				var numberOfProperties:int;
				var propertyAndValue:String;
				var propertyValueArray:Array;
				var propertyValueArrayLength:int;
				var property:String;
				const entriesArrayList:ArrayList = new ArrayList();
				const entriesSplittedBySeparator:Array = type1String.split(entriesSeparator);

				if (entriesSplittedBySeparator)
				{
					const numberOfEntries:int = entriesSplittedBySeparator.length;
					for (i = 0; i < numberOfEntries; i++)
					{
						entryObject = new Object();
						entry = entriesSplittedBySeparator[i];

						if (entry)
						{
							entryPropertiesArray = entry.split(propertiesSeparator);

							if (entryPropertiesArray)
							{
								numberOfProperties = entryPropertiesArray.length;
								for (j = 0; j < numberOfProperties; j++)
								{
									propertyAndValue = entryPropertiesArray[j];

									if (propertyAndValue)
									{
										propertyValueArray = propertyAndValue.split(propertyValueSeparator);

										if (propertyValueArray)
										{
											propertyValueArrayLength = propertyValueArray.length;
											property = StringUtil.trim(propertyValueArray[0]);

											if (propertyValueArrayLength == 2)
												entryObject[property] = StringUtil.trim(ServerVarsDecoder.replaceAllMessageDVars(propertyValueArray[1]));
											else if (propertyValueArrayLength == 1)
												entryObject[property] = null;
										}
									}
								}
							}
						}

						entriesArrayList.addItem(entryObject);
					}
				}

				return entriesArrayList;
			}
			else
				return null;
		}

		//----------------------------------------------------------------------
		// Type 2:

		/**
		 * <p>Transform a String of type 2 (a CSV line) into an ArrayList.</p>
		 *
		 * @param csvLine The type 2 String (a CSV line). If this is null or an empty String, this method will return null.
		 * @param valuesSeparator The String that separate the values on <code>csvLine</code> (default <code>","</code>).
		 *
		 * @return A populated ArrayList.
		 */
		public static function transformation2IntoArrayList(csvLine:String, valuesSeparator:String=","):ArrayList
		{
			if (csvLine)
				return new ArrayList(csvLine.split(valuesSeparator));
			else
				return null;
		}

		//----------------------------------------------------------------------
		// Type 3:

		/**
		 * <p>Transform a String of type 3 (a CSV line with properties and values) into an Object map (like a java.util.Map).</p>
		 *
		 * @param csvLine The type 3 String (a CSV line with properties and values). If this is null or an empty String, this method will return null.
		 * @param propertiesSeparator The String that separate the properties on <code>csvLine</code> (default <code>","</code>).
		 * @param propertyValueSeparator The String that separate the properties from it's values (default <code>"="</code>).
		 *
		 * @return A populated Object.
		 */
		public static function transformation3IntoObject(csvLine:String, propertiesSeparator:String=",", propertyValueSeparator:String="="):Object
		{
			if (csvLine)
			{
				const returnObj:Object = new Object();
				const csvLineSplitted:Array = csvLine.split(propertiesSeparator);
				const csvLineSplittedLength:int = csvLineSplitted.length;
				var propValueSplitted:Array;
				var propValueSplittedLength:int;
				var prop:String;

				for (var i:int = 0; i < csvLineSplittedLength; i++)
				{
					propValueSplitted = (csvLineSplitted[i] as String).split(propertyValueSeparator);
					propValueSplittedLength = propValueSplitted.length;
					prop = StringUtil.trim(propValueSplitted[0]);

					if (propValueSplittedLength == 2)
						returnObj[prop] = StringUtil.trim(propValueSplitted[1]);
					else if (propValueSplittedLength == 1)
						returnObj[prop] = null;
				}

				return returnObj;
			}
			else
				return null;
		}

		//----------------------------------------------------------------------
	}
}
