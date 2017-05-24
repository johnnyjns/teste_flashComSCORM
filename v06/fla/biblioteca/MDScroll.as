import mx.effects.Tween;
dynamic class MDScroll
{
	private var _container:MovieClip;
	private var _mask:MovieClip;
	private var _scroll:MovieClip;
	private var _max:Number;
	private var _yini:Number;
	private var _type:Boolean;
	function MDScroll(rolagem,container,mascara)
	{
		_container = container;
		_mask = mascara;
		_scroll = rolagem;
		_scroll.drag_mc.useHandCursor = _scroll.fundo_mc.useHandCursor = false;
	};
	public function init(txt:Boolean):Void
	{
		if(txt)setScrollTextField();
		else setScrollMovieClip();
		_type = txt;
		createChild();
	};
	private function setScrollMovieClip():Void
	{	
		var area:Number = (_mask._height / _container._height) * 100;
		_max = Math.round(_container._height-_mask._height);
		_yini = _container._y;
		_scroll.drag_mc._y = 0;
		animate(Math.max(15,Math.min(100,area)));
	};
	private function setScrollTextField():Void
	{
		_container.scroll = 0;
		_max = _container.maxscroll;	
		var total = _container.bottomScroll - (_container.scroll - 1);
		animate(Math.max(15, Math.min(100, total / (total+_max) * 100)));
		if (_max <= 1) _scroll.drag_mc._y = 0,_scroll.drag_mc._yscale = 100;
		delete total;
	};
	private function createChild():Void
	{
		_scroll.desce.onPress = downPress;
		_scroll.desce.onRelease = _scroll.desce.onReleaseOutside =
		_scroll.sobe.onRelease = _scroll.sobe.onReleaseOutside = arrowRelease;
		_scroll.sobe.onPress = upPress;
		_scroll.drag_mc.classObj = this;
		_scroll.drag_mc.movePosition = movePosition;
		_scroll.drag_mc.onPress = dragPress;
		_scroll.drag_mc.onRelease = _scroll.drag_mc.onReleaseOutside = dragRelease;
		_scroll.fundo_mc.onRelease = fundoRelease;
	};
	private function upPress():Void
	{
		var sc:MovieClip = this._parent;
		this._interval = setInterval(
			function(){
				sc.drag_mc._y = Math.max(0, sc.drag_mc._y - 10);
				sc.drag_mc.movePosition();
			},50);
	};
	private function downPress():Void
	{
		var sc:MovieClip = this._parent;
		this._interval = setInterval(
			function(){
				sc.drag_mc._y = Math.min(sc.fundo_mc._height - sc.drag_mc._height, sc.drag_mc._y + 10);
				sc.drag_mc.movePosition();
			},50);
	};
	private function arrowRelease():Void
	{
		clearInterval(this._interval);
	};
	private function dragPress():Void
	{
		this.startDrag(false, 0, 0, 0, this._parent.fundo_mc._height - this._height);
		this.onMouseMove = this.movePosition; 
	};
	private function dragRelease():Void
	{
		delete this.onMouseMove;
		this.stopDrag();
	};
	private function fundoRelease():Void
	{
		this._parent.drag_mc._y = Math.max(0, Math.min(this._height - this._parent.drag_mc._height, (this._ymouse - (this._parent.drag_mc._height/2))));
		this._parent.drag_mc.movePosition();
	};
	private function movePosition():Void
	{
		if(this.classObj._type)this.classObj._container.scroll = this.classObj.updatePosition()+1;		
		else this.classObj._container._y = this.classObj._yini - this.classObj.updatePosition();		
		updateAfterEvent();
	};
	private function updatePosition():Number
	{
		return Math.round(_scroll.drag_mc._y / (_scroll.fundo_mc._height - _scroll.drag_mc._height) * _max);
	};
	private function animate(value:Number):Void
	{
		var lis:MovieClip = _scroll.drag_mc;
		var _tween:Tween = new Tween(lis,lis._yscale,value,650);
		lis.onTweenUpdate = lis.onTweenEnd = function(v:Number):Void		{
			this._yscale = Math.round(v);
		};
	};
};
