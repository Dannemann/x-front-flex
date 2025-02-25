package br.com.dannemann.gui.event
{
	import flash.events.Event;

	public final class DUploadDownloadEvent extends Event
	{
		public static const _ON_UPLOAD_COMPLETE:String = "uploadComplete";
		public static const _ON_UPLOAD_PROGRESS:String = "uploadProgress";
		public static const _ON_UPLOAD_CANCEL:String = "uploadCancel";
		public static const _ON_UPLOAD_IO_ERROR:String = "uploadIOError";
		public static const _ON_UPLOAD_DGUIERROR:String = "uploadDGUIError";
		public static const _ON_UPLOAD_SECURITY_ERROR:String = "uploadSecurityError";

		public function DUploadDownloadEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
