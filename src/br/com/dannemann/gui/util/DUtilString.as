package br.com.dannemann.gui.util
{
	import br.com.dannemann.gui.domain.StrConsts;

	import mx.utils.StringUtil;

	public final class DUtilString
	{
		//----------------------------------------------------------------------
		// Public interface:

		public static function camelCaseFieldToNormalWithSpaces(getOrSetMethodName:String):String
		{
			getOrSetMethodName = upperCaseFirstLetter(getOrSetMethodName);

			// For vars.
			const stringLength:int = getOrSetMethodName.length;
			var character:String;
			var finalString:String = StrConsts._CHAR_EMPTY_STRING;
			var charCode:Number;

			for (var i:int = 0; i < stringLength; i++)
			{
				character = getOrSetMethodName.charAt(i);
				charCode = character.charCodeAt();

				if (charCode > 64 && charCode < 91)
					finalString += StrConsts._CHAR_SPACE + character;
				else
					finalString += character;
			}

			return StringUtil.trim(finalString);
		}

		public static function camelCaseGetSetToNormalWithSpaces(getOrSetMethodName:String):String
		{
			return camelCaseFieldToNormalWithSpaces(removeGetSetPrefix(getOrSetMethodName));
		}

		public static function containsWord(word:String, targetStr:String, caseSensitive:Boolean=false):int
		{
			word = parameterHelper_Trim_LowerCase_AddSpaces(word, caseSensitive);
			targetStr = parameterHelper_Trim_LowerCase_AddSpaces(targetStr, caseSensitive);

			const wordBeginIndex:int = targetStr.indexOf(word);

			if (targetStr.charAt(wordBeginIndex) == StrConsts._CHAR_SPACE)
				wordBeginIndex + 1;

			return wordBeginIndex;
		}

		public static function fieldNameToSetter(fieldName:String):String
		{
			return StrConsts._STR_set + DUtilString.upperCaseFirstLetter(fieldName);
		}

		public static function findUntil(toFind:String, target:String):String
		{
			if (target)
			{
				const indexOfToFindStr:int = target.indexOf(toFind);

				if (indexOfToFindStr != -1)
					return target.substring(0, indexOfToFindStr);
				else
					return null;
			}
			else
				return null
		}

		public static function getStringAfterFirstOccurrenceOf(strToFind:String, target:String):String
		{
			if (target)
			{
				const indexOfToFindStr:int = target.indexOf(strToFind);

				if (indexOfToFindStr != -1)
					return target.substring(indexOfToFindStr + 1);
				else
					return target;
			}
			else
				return null
		}

		public static function getStringAfterLastOccurrenceOf(strToFind:String, target:String):String
		{
			if (target)
			{
				const lastIndexOfToFindStr:int = target.lastIndexOf(strToFind);

				if (lastIndexOfToFindStr != -1)
					return target.substring(lastIndexOfToFindStr + 1);
				else
					return target;
			}
			else
				return null
		}

		public static function fullClassNameToSimpleClassName(fullClassName:String):String
		{
			return fullClassName.substr(fullClassName.lastIndexOf(StrConsts._CHAR_DOT) + 1);
		}

		public static function fullClassNameToSimpleClassNameFormatted(fullClassName:String):String
		{
			return camelCaseFieldToNormalWithSpaces(fullClassName.substr(fullClassName.lastIndexOf(StrConsts._CHAR_DOT) + 1));
		}

		public static function isWhitespace(character:String):Boolean
		{
			return StringUtil.isWhitespace(character);
		}

		public static function hasValue(string:Object):Boolean
		{
			if (!string)
				return false;

			const stringStr:String = StringUtil.trim(string.toString());

			if (!stringStr)
				return false;

			return true;
		}

		public static function numberOfOccurrences(targetString:String, pattern:String):int
		{
			var count:int = 0;
			var startIndex:int = 0;

			while (targetString.indexOf(pattern, startIndex) != -1)
			{
				count++;
				startIndex = targetString.indexOf(pattern, startIndex) + 1;
			}

			return count;
		}

		public static function removeGetSetPrefix(getOrSetMethodName:String):String
		{
			return getOrSetMethodName.substring(3, getOrSetMethodName.length);
		}

		public static function replaceAll(string:String, char:String, replaceWith:String):String
		{
			return string.split(char).join(replaceWith);
		}

		public static function startsWith(string:String, prefix:String):Boolean
		{
			if (string == null)
				string = StrConsts._CHAR_EMPTY_STRING;
			if (prefix == null)
				prefix = StrConsts._CHAR_EMPTY_STRING;

			if (string == prefix)
				return true;

			const prefixLength:int = prefix.length;

			for (var i:int = 0; i < prefixLength; i++)
				if (string.charAt(i) != prefix.charAt(i))
					return false;

			return true;
		}

		public static function endsWith(string:String, sufix:String):Boolean
		{
			if (string == null)
				string = StrConsts._CHAR_EMPTY_STRING;
			if (sufix == null)
				sufix = StrConsts._CHAR_EMPTY_STRING;

			if (string == sufix)
				return true;

			const sufixLength:int = sufix.length;
			const stringEnd:String = string.substr(string.length - sufixLength);

			for (var i:int = 0; i < sufixLength; i++)
				if (stringEnd.charAt(i) != sufix.charAt(i))
					return false;

			return true;
		}

		public static function upperCaseFirstLetter(string:String):String
		{
			return string.substring(0, 1).toUpperCase() + string.substring(1);
		}

		// TODO: Modificar método para alterar todas as ocorrências de "word" em "targetStr".
		public static function upperCaseWord(word:String, targetStr:String):String
		{
			word = parameterHelper_Trim_LowerCase_AddSpaces(word, true);
			targetStr = parameterHelper_Trim_LowerCase_AddSpaces(targetStr, true);

			return StringUtil.trim(
				targetStr.replace(
					new RegExp(word, StrConsts._CHAR_EMPTY_STRING),
					function (matchStr:String, ...rest):String
					{
						return matchStr.toUpperCase();
					}
				)
			);
		}

		public static function trim(string:String):String
		{
			return StringUtil.trim(string);
		}

		public static function removeSpecialChars(string:String):String
		{
			return StringUtil.trim(string
				.replace(/á/g, "a")
				.replace(/é/g, "e")
				.replace(/í/g, "i")
				.replace(/ó/g, "o")
				.replace(/ú/g, "u")
				.replace(/Á/g, "A")
				.replace(/É/g, "E")
				.replace(/Í/g, "I")
				.replace(/Ó/g, "O")
				.replace(/Ú/g, "U")
				.replace(/â/g, "a")
				.replace(/ê/g, "e")
				.replace(/î/g, "i")
				.replace(/ô/g, "o")
				.replace(/û/g, "u")
				.replace(/Â/g, "A")
				.replace(/Ê/g, "E")
				.replace(/Î/g, "I")
				.replace(/Ô/g, "O")
				.replace(/Û/g, "U")
				.replace(/ã/g, "a")
				.replace(/õ/g, "o")
				.replace(/Ã/g, "A")
				.replace(/Õ/g, "O")
				.replace(/ç/g, "c")
				.replace(/Ç/g, "C")
				.replace(/ü/g, "u")
				.replace(/Ü/g, "U")
				.replace(/à/g, "a")
				.replace(/è/g, "e")
				.replace(/ì/g, "i")
				.replace(/ò/g, "o")
				.replace(/ù/g, "u")
				.replace(/À/g, "A")
				.replace(/È/g, "E")
				.replace(/Ì/g, "I")
				.replace(/Ò/g, "O")
				.replace(/Ù/g, "U")
				.replace(/[^0-9a-zA-Z ]/gi, "")
				.replace(/[ ]+/g, " "));
		}

		public static function removeSpecialCharsAndUpperCase(string:String):String
		{
			return removeSpecialChars(string).toUpperCase();
		}

		public static function numToChar(num:int):String
		{
			if (num > 47 && num < 58)
			{
				const strNums:String = "0123456789";
				return strNums.charAt(num - 48);
			}
			else if (num > 64 && num < 91)
			{
				const strCaps:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
				return strCaps.charAt(num - 65);
			}
			else if (num > 96 && num < 123)
			{
				const strLow:String = "abcdefghijklmnopqrstuvwxyz";
				return strLow.charAt(num - 97);
			}
			else
				return num.toString();
		}

		//----------------------------------------------------------------------
		// Private interface:

		private static function parameterHelper_Trim_LowerCase_AddSpaces(string:String, caseSensitive:Boolean):String
		{
			string = StringUtil.trim(string);
			return StrConsts._CHAR_SPACE + (!caseSensitive ? string.toLowerCase() : string) + StrConsts._CHAR_SPACE;
		}

		//----------------------------------------------------------------------
	}
}
