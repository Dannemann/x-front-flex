package br.com.dannemann.gui.util
{
	import br.com.dannemann.gui.domain.StrConsts;

	import flash.net.FileFilter;

	public final class DUtilUpload
	{
		public static const _1MB_In_Bytes:int = 1048576;

		public static function getImageFilter():FileFilter
		{
			return new FileFilter(StrConsts.getRMString(95) + " (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png");
		}

		public static function getImageFilterArray():Array
		{
			return [
				new FileFilter(StrConsts.getRMString(96) + " (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png"),
				new FileFilter(StrConsts.getRMString(97) + " *.jpg", "*.jpg"),
				new FileFilter(StrConsts.getRMString(97) + " *.jpeg", "*.jpeg"),
				new FileFilter(StrConsts.getRMString(97) + " *.gif", "*.gif"),
				new FileFilter(StrConsts.getRMString(97) + " *.png", "*.png"),
			];
		}
	}
}
