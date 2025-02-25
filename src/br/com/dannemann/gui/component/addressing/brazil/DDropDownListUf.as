package br.com.dannemann.gui.component.addressing.brazil
{
	import mx.collections.ArrayCollection;
	
	import br.com.dannemann.gui.component.input.DDropDownList;
	import br.com.dannemann.gui.domain.StrConsts;

	public class DDropDownListUf extends DDropDownList
	{
		// -------------------------------------------------------------------------
		// Static:
		
		public static const ufs:Array = new Array(27);

		// Static initialization.
		{
			// Initialy ordered by "label".
			ufs[0] = { code:"AC", label:"Acre" };
			ufs[1] = { code:"AL", label:"Alagoas" };
			ufs[2] = { code:"AP", label:"Amapá" };
			ufs[3] = { code:"AM", label:"Amazonas" };
			ufs[4] = { code:"BA", label:"Bahia" };
			ufs[5] = { code:"CE", label:"Ceará" };
			ufs[6] = { code:"DF", label:"Distrito Federal" };
			ufs[7] = { code:"ES", label:"Espírito Santo" };
			ufs[8] = { code:"GO", label:"Goiás" };
			ufs[9] = { code:"MA", label:"Maranhão" };
			ufs[10] = { code:"MT", label:"Mato Grosso" };
			ufs[11] = { code:"MS", label:"Mato Grosso Do Sul" };
			ufs[12] = { code:"MG", label:"Minas Gerais" };
			ufs[13] = { code:"PA", label:"Pará" };
			ufs[14] = { code:"PB", label:"Paraíba" };
			ufs[15] = { code:"PR", label:"Paraná" };
			ufs[16] = { code:"PE", label:"Pernambuco" };
			ufs[17] = { code:"PI", label:"Piauí" };
			ufs[18] = { code:"RJ", label:"Rio De Janeiro" };
			ufs[19] = { code:"RN", label:"Rio Grande Do Norte" };
			ufs[20] = { code:"RS", label:"Rio Grande Do Sul" };
			ufs[21] = { code:"RO", label:"Rondônia" };
			ufs[22] = { code:"RR", label:"Roraima" };
			ufs[23] = { code:"SC", label:"Santa Catarina" };
			ufs[24] = { code:"SP", label:"São Paulo" };
			ufs[25] = { code:"SE", label:"Sergipe" };
			ufs[26] = { code:"TO", label:"Tocantins" };
		}
		
		// -------------------------------------------------------------------------
		// Constructor:
		
		public function DDropDownListUf()
		{
			_dataField = StrConsts._STR_code;
			dataProvider = new ArrayCollection(ufs);
		}
		
		// -------------------------------------------------------------------------
		// Features:
		
		public var abbreviatedLabels:Boolean;
		
		// -------------------------------------------------------------------------
		// Protected:

		protected function resolveLabels():void
		{
			if (abbreviatedLabels)
			{
				labelField = StrConsts._STR_code;
				ufs.sortOn(StrConsts._STR_code);
			}
		}

		// -------------------------------------------------------------------------
		// UIComponent overrides:
		
		override public function initialize():void
		{
			resolveLabels();
			super.initialize();
		}
		
		// -------------------------------------------------------------------------
	}
}
