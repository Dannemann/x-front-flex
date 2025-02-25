package br.com.dannemann.gui.util
{
	public final class DUtilFile
	{
		public static function addBeginSlash(path:String):String
		{
			if (DUtilString.startsWith(path, "/"))
				return path;
			else
				return "/" + path;
		}

		public static function addEndSlash(path:String):String
		{
			if (DUtilString.endsWith(path, "/"))
				return path;
			else
				return path + "/";
		}

		public static function removeBeginSlash(path:String):String
		{
			if (DUtilString.startsWith(path, "/"))
				return path.substring(1);
			else
				return path;
		}

		public static function removeEndSlash(path:String):String
		{
			if (DUtilString.endsWith(path, "/"))
				return path.substring(0, path.length - 1);
			else
				return path;
		}
	}
}
