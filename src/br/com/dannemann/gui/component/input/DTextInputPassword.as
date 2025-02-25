package br.com.dannemann.gui.component.input
{
	import flash.utils.ByteArray;
	
	import mx.utils.SHA256;
	
	import br.com.dannemann.gui.crypto.MD5;

	/**
	 * <p>A password input text.</p>
	 */
	public class DTextInputPassword extends DTextInput
	{
		// -------------------------------------------------------------------------
		// Fields:
		
		// Features:
		
		/**
		 * <p>Sets MD5 encryption of the text return by the <code>text</code> property.</p>
		 * <p><b>Note:</b>If this is set to <code>true</code>, <code>_encryptPasswordSha256</code> is set to <code>false</code>.</p>
		 */
		private var encryptPasswordMd5:Boolean;
		
		/**
		 * <p>Sets SHA256 encryption of the text return by the <code>text</code> property.</p>
		 * <p><b>Note:</b>If this is set to <code>true</code>, <code>_encryptPasswordMd5</code> is set to <code>false</code>.</p>
		 */
		private var encryptPasswordSha256:Boolean;

		// -------------------------------------------------------------------------
		// Constructor:
		
		/**
		 * <p>Defaults to <code>displayAsPassword=true</code> and <code>maxChars=50</code>.</p>
		 */
		public function DTextInputPassword():void
		{
			displayAsPassword = true;
			maxChars = 50;
		}

		// -------------------------------------------------------------------------
		// Features:
		
		/**
		 * @copy #encryptPasswordMd5
		 */
		
		public function get _encryptPasswordMd5():Boolean
		{
			return encryptPasswordMd5;
		}
		
		public function set _encryptPasswordMd5(value:Boolean):void
		{
			encryptPasswordMd5 = value;
			
			if (encryptPasswordMd5)
				encryptPasswordSha256 = false;
		}
		
		/**
		 * @copy #encryptPasswordSha256
		 */
		
		public function get _encryptPasswordSha256():Boolean
		{
			return encryptPasswordSha256;
		}
		
		public function set _encryptPasswordSha256(value:Boolean):void
		{
			encryptPasswordSha256 = value;
			
			if (encryptPasswordSha256)
				encryptPasswordMd5 = false;
		}
		
		// -------------------------------------------------------------------------
		// Encryption:
		
		override public function get text():String
		{
			var myText:String = super.text;

			if (myText)
			{
				if (encryptPasswordMd5)
					myText = MD5.hash(myText);
				else if (_encryptPasswordSha256)
				{
					const byteArray:ByteArray = new ByteArray();
					byteArray.writeUTFBytes(myText);
					myText = SHA256.computeDigest(byteArray);
				}
			}
			
			return myText;
		}
		
		// -------------------------------------------------------------------------
	}
}
