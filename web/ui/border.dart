part of PhaserUI;

class Border extends Group {
  bool _dirty = false;
  bool isDragging = false;
  int dragger = -1;

  TileSprite leftBorder;
  TileSprite rightBorder;
  TileSprite topBorder;
  TileSprite bottomBorder;

  Sprite leftTopCorner;
  Sprite leftBottomCorner;
  Sprite rightTopCorner;
  Sprite rightBottomCorner;

  Panel _panel;

  num _height = 200;

  num get height => _height;

  set height(num value) {
    _height = value;
    _dirty = true;
  }

  num _width = 200;

  num get width => _width;

  set width(num value) {
    _width = value;
    _dirty = true;
  }

  num _borderWidth = 32;
  num _borderHeight = 32;

  num startX = 0;
  num startY = 0;

  var key;

  num minWidth = 96;
  num maxWidth = 320;

  num minHeight = 96;
  num maxHeight = 320;

  Function getDragStartFunction(int dragger) {
    return (sender, pointer) {
      isDragging = true;
      this.dragger = dragger;
    };
  }

  Function getDragStopFunction() {
    return (sender, pointer) {
      isDragging = true;
    };
  }

  Sprite createCorner(num x, num y, Object key, Object frame, int id) {
    Sprite obj = this.create(x, y, key, frame);
    obj.inputEnabled = true;
    obj.input.enableDrag();
    //obj.input.enableSnap(32, 32);
    obj.events.onDragStart.add(getDragStartFunction(id));
    obj.events.onDragStop.add(getDragStopFunction());
    return obj;
  }

  TileSprite createBorder(num x, num y, num width, num height, Object key, Object frame, int id) {
    TileSprite obj = game.make.tileSprite(x, y, width, height, key, frame);
    obj.inputEnabled = true;
    obj.input.enableDrag();
    //obj.input.enableSnap(32, 32);
    obj.events.onDragStart.add(getDragStartFunction(id));
    obj.events.onDragStop.add(getDragStopFunction());
    return obj;
  }

  Border(Game game, [Object key, Object frame]) : super(game) {
    this.key = key;

    leftBorder = createBorder(0, _borderHeight, _borderWidth, height - _borderHeight * 2, key, 8, 0);// game.make.tileSprite(0, _borderHeight, _borderWidth, height - _borderHeight * 2, key, 0);
    rightBorder = createBorder(_width - _borderWidth, _borderHeight, _borderWidth, height - _borderHeight * 2, key, 10, 1);// game.make.tileSprite(_width - _borderWidth, _borderHeight, _borderWidth, height - _borderHeight * 2, key, 1);
    topBorder = createBorder(_borderWidth, 0, width - _borderWidth * 2, _borderHeight, key, 1, 2); // game.make.tileSprite(_borderWidth, 0, width - _borderWidth * 2, _borderHeight, key, 2);
    bottomBorder = createBorder(_borderWidth, height - _borderHeight, width - _borderWidth * 2, _borderHeight, key, 17, 3);//  game.make.tileSprite(_borderWidth, height - _borderHeight, width - _borderWidth * 2, _borderHeight, key, 3);

    leftTopCorner = createCorner(0, 0, key, 0, 4);
    leftBottomCorner = createCorner(0, height - _borderHeight, key, 16, 5);
    rightTopCorner = createCorner(_width - _borderWidth, 0, key, 2, 6);
    rightBottomCorner = createCorner(_width - _borderWidth, height - _borderHeight, key, 18, 7);

    this.addChild(leftBorder);
    this.addChild(rightBorder);
    this.addChild(topBorder);
    this.addChild(bottomBorder);
  }

  setPanel(Panel panel) {
    this._panel = panel;
    panel.x = _borderWidth;
    panel.y = _borderHeight;

    _panel.width = width - _borderWidth * 2;
    _panel.height = height - _borderHeight * 2;
  }

  updateLayout() {
    leftBorder.height = _height - _borderHeight * 2;
    leftBorder.x = startX;
    leftBorder.y = _borderHeight + startY;

    rightBorder.height = _height - _borderHeight * 2;
    rightBorder.x = _width - _borderWidth + startX;
    rightBorder.y = _borderHeight + startY;

    topBorder.width = _width - _borderWidth * 2;
    topBorder.x = _borderWidth + startX;
    topBorder.y = startY;

    bottomBorder.width = _width - _borderWidth * 2;
    bottomBorder.x = _borderWidth + startX;
    bottomBorder.y = _height - _borderHeight + startY;


    rightTopCorner.x = _width - _borderWidth + startX;
    rightTopCorner.y = startY;

    leftBottomCorner.x = startX;
    leftBottomCorner.y = _height - _borderHeight + startY;

    rightBottomCorner.x = _width - _borderWidth + startX;
    rightBottomCorner.y = _height - _borderHeight + startY;

    leftTopCorner.x = startX;
    leftTopCorner.y = startY;

    if (_panel != null) {
      _panel.width = width - _borderWidth * 2;
      _panel.height = height - _borderHeight * 2;
      _panel.x = _borderWidth + startX;
      _panel.y = _borderHeight + startY;
    }



  }

  update() {

    if (isDragging || _dirty) {
      switch (dragger) {
      //right-bottom
        case 7:
          this._width = rightBottomCorner.x + rightBottomCorner.width - startX;
          this._height = rightBottomCorner.y + rightBottomCorner.height - startY;
          break;
      //right-top
        case 6:
          this._width = rightTopCorner.x + rightTopCorner.width - startX;
          this._height = rightBottomCorner.y + rightBottomCorner.height - rightTopCorner.y;

          this.startY = rightTopCorner.y;
          break;
      //left-bottom
        case 5:
          this._width = rightBottomCorner.x + rightBottomCorner.width - leftBottomCorner.x;
          this._height = leftBottomCorner.y + leftBottomCorner.height - startY;

          this.startX = leftBottomCorner.x;
          break;
      //left-top
        case 4:
          this._width = rightTopCorner.x + rightTopCorner.width - leftTopCorner.x;
          this._height = leftBottomCorner.y + leftBottomCorner.height - leftTopCorner.y;

          this.startX = leftTopCorner.x;
          this.startY = leftTopCorner.y;
          break;

      //bottom border
        case 3:
          this._height = bottomBorder.y + bottomBorder.height - startY;
          break;

      //top border
        case 2:
          this.startY = topBorder.y;
          this._height = bottomBorder.y + bottomBorder.height - startY;
          break;

      //right border
        case 1:
          this._width = rightBorder.x + rightBorder.width - startX;
          break;

      //left border
        case 0:
          this.startX = leftBorder.x;
          this._width = rightBorder.x + rightBorder.width - startX;
          break;
      }

      bool left = (dragger == 0 || dragger == 4 || dragger == 5);
      bool right = (dragger == 1 || dragger == 6 || dragger == 7);
      bool top = (dragger == 2 || dragger == 4 || dragger == 6);
      bool bottom = (dragger == 3 || dragger == 5 || dragger == 7);
      bool w = right && !left;
      bool h = !top && bottom;

      if (_width > maxWidth) {
        if (w) {
          startX += _width - maxWidth;
        }
        _width = maxWidth;
      } else if (_width < minWidth) {
        if (w) {
          startX += _width - minWidth;
        }
        _width = minWidth;
      }

      if (_height > maxHeight) {
        if (h) {
          startY += _height - maxHeight;
        }
        _height = maxHeight;
      } else if (_height < minHeight) {
        if (h) {
          startY += _height - minHeight;
        }
        _height = minHeight;
      }

      //this._width = Math.max(minWidth, Math.min(this._width, maxWidth));
      //this._height = Math.max(minHeight, Math.min(this._height, maxHeight));



      updateLayout();

      if (_panel != null) {
        _panel._dirty = true;
      }

      _dirty = false;
    }

    if (_panel != null) {
      _panel.update();
    }


    //_panel.update();

    //    _view.children.forEach((GameObject item) {
    //      if (item is Panel) {
    //        item.update();
    //      }
    //    });
  }
}