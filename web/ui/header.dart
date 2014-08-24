part of PhaserUI;

class Header extends Group {
  TileSprite _background;
  TileSprite get background => _background;

  bool _dirty = true;
  bool isDragging = false;
  GameObject target;
  Point offset = new Point();

  num _width = 192;
  num _height = 32;


  Header(Game game, [GameObject target, Object key, Object frame])
  : super(game) {


    this.target = target;

    this._background = new TileSprite(game);
    this._background.loadTexture(key, frame);
    this._background.alpha = 0.1;

    this._background.inputEnabled = true;
    this._background.input.enableDrag();
    this._background.events.onDragStart.add((p, e) {
      isDragging = true;
    });
    this._background.events.onDragStop.add((p, e) {
      isDragging = false;
      _dirty = true;
    });

    addChild(_background);
  }

  updateLayout() {

    _background.height = _height;
    _background.width = _width;

  }

  update() {
    if ((isDragging || _dirty) && target != null) {
      target.x = _background.x + offset.x;
      target.y = _background.y + offset.y + _height;
      updateLayout();
      _dirty = false;
    }
  }
}