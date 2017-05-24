/*Classe reponsável pelos eventos dos botões
    Todo movieclip que pertencer a essa classe possuira os metodos e propriedades aqui instanciados
     Essa classe faz o controle dos estados de BLINK, OVER, ACTIVE, CHECK e claro UP
     Além de ser possível já programar ações para os eventos de onRollOver e onRollOut sem precisar usar o evento padrão
     Para todo movieclip que pertencer a essa classe, eles terão de estar no padrão. Labels nomeadas corretamente.
*/
//import inc.*;

class Btn extends MovieClip
{
	//atributos
	//Variavel recebera a ação do evento onClick
	private var acao:Function;
	//Variavel recebera a ação do evento onRoll
	private var roll:Function;
	//Variavel recebera a ação do evento onOut
	private var out:Function;
	//Variaveis em desuso
	private var active_mc:MovieClip;
	private var over_mc:MovieClip;
	private var hit:MovieClip;
	//**
	//Variavel que recebe a propriedade BLINK
	public var eblink:Boolean;
	//Variavel que recebe a propriedade CHECK
	public var chk:Boolean;
	//Variavel que recebe a propriedade ACTIVE
	public var active:Boolean;
	//seta o id
	public var id:Number;
	//construtora
	function Btn ()
	{
		super ();
		_focusrect = false;
		this.eblink = false;
		this.chk = false;
	}
	//métodos
	public function verificaCheck ()
	{
		
		var flag = _root.getArrayControle (this.id);
		
		this.eblink = !flag;
		this.chk = flag;
		
		gotoAndStop(flag ? "CHECK" : "BLINK");

	}
	//Metodo seta o evento onClick (Substitui o onRelease)
	function set onClick (valor:Function):Void
	{
		acao = valor;
	}
	//Metodo retorna o evento
	function get onClick ()
	{
		return acao;
	}
	//Metodo seta o evento onRoll. (Substitui o onRollOver)
	function set onRoll (valor:Function):Void
	{
		roll = valor;
	}
	//Metodo retorna o evento
	function get onRoll ()
	{
		return roll;
	}
	//Metodo seta o evento onOut (Substitui o onRollOut)
	function set onOut (valor:Function):Void
	{
		out = valor;
	}
	//Metodo retorna o evento
	function get onOut ()
	{
		return out;
	}
	//Envoca o evento onClick
	function onRelease ()
	{
		acao ();
		this.gotoAndStop ("ACTIVE");
	}
	//Envoca o evento onRollOut
	function onReleaseOutside ()
	{
		onRollOut ();
	}
	//Envoca o evento onRoll
	function onRollOver ()
	{
		roll ();
		this.gotoAndStop ("OVER");
	}
	//Envoca o evento onOut e faz o controle dos estados dependendo da propriedade setada
	function onRollOut ()
	{
		out ();
		if (this.eblink)
		{
			this.gotoAndStop ("BLINK");
		}
		else if (this.active)
		{
			this.gotoAndStop ("ACTIVE");
		}
		else if (this.chk)
		{
			this.gotoAndStop ("CHECK");
		}
		else
		{
			this.gotoAndStop ("UP");
		}
	}
	//Envoca o evento onRollOver ao receber o foco através da tecla TAB e ao clicar o Enter envoca o evento onRelease
	function onSetFocus ()
	{
		onRollOver ();
		onKeyDown = function ()
		{
			if (Key.getCode () == 13)
			{
				onRelease ();
			}
		};
	}
	//Envoca o envento onRollOut ao perder o foco através da tecla TAB
	function onKillFocus ()
	{
		onRollOut ();
		delete onKeyDown;
	}
}
