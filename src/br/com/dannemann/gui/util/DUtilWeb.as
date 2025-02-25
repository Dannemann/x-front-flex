package br.com.dannemann.gui.util
{
	import flash.net.LocalConnection;

	public final class DUtilWeb
	{
		public static function checkProtocol(flashVarURL:String):Boolean
		{
			const result:Object = new RegExp("^http[s]?\:\\/\\/([^\\/]+)\\/").exec(flashVarURL);

			if (result == null || result[1] != new LocalConnection().domain || flashVarURL.length >= 4096)
				return false;

			return true;
		}
	}
}
