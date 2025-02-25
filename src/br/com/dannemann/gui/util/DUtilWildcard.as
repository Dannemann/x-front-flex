package br.com.dannemann.gui.util
{
	/**
	 * Use this when working with wildcards.
	 */
	public final class DUtilWildcard
	{
		/**
		 * Convert wildcard String to regular expression.
		 *
		 * @param wildcard Wildcard String to be converted to a regular expression.
		 * @param flags Flags used to create the regular expression (see RegExp documentation).
		 * @param asterisk Whether asterisk is interpreted as any character sequence.
		 * @param questionMark Whether question mark is interpreted as any character.
		 *
		 * @return A regular expression equivalent to the passed wildcard.
		 */
		public static function wildcardToRegExp(wildcard:String, flags:String="i", asterisk:Boolean=true, questionMark:Boolean=true):RegExp
		{
			var resultStr:String;

			// Excape metacharacters other than "*" and "?".
			resultStr = wildcard.replace(/[\^\$\\\.\+\(\)\[\]\{\}\|]/g, "\\$&");
			// Replace wildcard "?" with RegExp equivalent ".".
			resultStr = resultStr.replace(/[\?]/g, ".");
			// Replace wildcard "*" with RegExp equivalen ".*?".
			resultStr = resultStr.replace(/[\*]/g, ".*?");

			return new RegExp(resultStr, flags);
		}

	}
}
