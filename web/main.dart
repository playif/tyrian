import "package:play_phaser/phaser.dart";


main() {
  Game game = new Game(800, 600, CANVAS, '');
  game.state.add('tyrian', new Tyrian());
  game.state.start('tyrian');
}

//abstract class PanelItem {
//  bool fitParent;
//}

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
    obj.input.enableSnap(32, 32);
    obj.events.onDragStart.add(getDragStartFunction(id));
    obj.events.onDragStop.add(getDragStopFunction());
    return obj;
  }

  TileSprite createBorder(num x, num y, num width, num height, Object key, Object frame, int id) {
    TileSprite obj = game.make.tileSprite(x, y, width, height, key, frame);
    obj.inputEnabled = true;
    obj.input.enableDrag();
    obj.input.enableSnap(32, 32);
    obj.events.onDragStart.add(getDragStartFunction(id));
    obj.events.onDragStop.add(getDragStopFunction());
    return obj;
  }

  Border(Game game, [Object key, Object frame]) : super(game) {
    this.key = key;

    //Group elements

    leftBorder = createBorder(0, _borderHeight, _borderWidth, height - _borderHeight * 2, key, 8, 0);// game.make.tileSprite(0, _borderHeight, _borderWidth, height - _borderHeight * 2, key, 0);
    rightBorder = createBorder(_width - _borderWidth, _borderHeight, _borderWidth, height - _borderHeight * 2, key, 10, 1);// game.make.tileSprite(_width - _borderWidth, _borderHeight, _borderWidth, height - _borderHeight * 2, key, 1);
    topBorder = createBorder(_borderWidth, 0, width - _borderWidth * 2, _borderHeight, key, 1, 2); // game.make.tileSprite(_borderWidth, 0, width - _borderWidth * 2, _borderHeight, key, 2);
    bottomBorder = createBorder(_borderWidth, height - _borderHeight, width - _borderWidth * 2, _borderHeight, key, 17, 3);//  game.make.tileSprite(_borderWidth, height - _borderHeight, width - _borderWidth * 2, _borderHeight, key, 3);

    leftTopCorner = createCorner(0, 0, key, 0, 4);
    leftBottomCorner = createCorner(0, height - _borderHeight, key, 16, 5);
    //leftBottomCorner.input.boundsRect = new Rectangle(_width - minWidth, _height - minHeight, maxWidth - minWidth, maxHeight - minHeight);


    rightTopCorner = createCorner(_width - _borderWidth, 0, key, 2, 6);


    rightBottomCorner = createCorner(_width - _borderWidth, height - _borderHeight, key, 18, 7);
    //rightBottomCorner.input.boundsRect = new Rectangle(_width - minWidth, _height - minHeight, maxWidth - minWidth, maxHeight - minHeight);

    //    RightBottomCorner.inputEnabled = true;
    //    RightBottomCorner.input.enableDrag();
    //    RightBottomCorner.input.boundsRect = new Rectangle(_width - minWidth, _height - minHeight, maxWidth - minWidth, maxHeight - minHeight);
    //    RightBottomCorner.events.onDragStart.add((sender, pointer) {
    //      //if (checkViewPort(pointer)) {
    //      isDragging = true;
    //      //}
    //
    //    });
    //    RightBottomCorner.events.onDragStop.add((sender, pointer) {
    //      isDragging = false;
    //      //Point offset = _background.input.dragOffset;
    //      _dirty = true;
    //    });



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

    _panel.width = width - _borderWidth * 2;
    _panel.height = height - _borderHeight * 2;
    _panel.x = _borderWidth + startX;
    _panel.y = _borderHeight + startY;

    //topBorder = game.make.tileSprite(_borderWidth, 0, width - _borderWidth * 2, _borderHeight, key, 2);
    // = game.make.tileSprite(_borderWidth, height - _borderHeight, width - _borderWidth * 2, _borderHeight, key, 3);

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

class Header extends Sprite {
  bool _dirty = false;
  bool isDragging = false;
  GameObject target;
  Point offset = new Point();

  Header(Game game, [GameObject target, Object key, Object frame])
      : super(game, 0, 0, key, frame) {
    this.target = target;

    inputEnabled = true;
    input.enableDrag(false, false, true);
    events.onDragStart.add((p, e) {
      isDragging = true;
    });
    events.onDragStop.add((p, e) {
      isDragging = false;
      _dirty = true;
    });
  }



  update() {
    if ((isDragging || _dirty) && target != null) {
      target.x = this.x + offset.x;
      target.y = this.y + offset.y;
      _dirty = false;
    }
  }
}

class Panel extends Group {
  Game game;
  Layout layout;
  Graphics _mask;
  //  Graphics _border;

  Group _view;
  TileSprite _background;

  bool fitParent;
  bool _dirty = false;

  num _borderWidth = 0;

  num get borderWidth => _borderWidth;

  set borderWidth(num value) {
    _borderWidth = value;
    _dirty = true;
  }

  num _borderColor = 0x055252;

  num get borderColor => _borderColor;

  set borderColor(num value) {
    _borderColor = value;
    _dirty = true;
  }

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

  num get length => _view.children.length;

  bool isDragging = false;

  bool checkViewPort(point) {
    Point world = this.world;

    num x = point.x;
    num y = point.y;
    if (x < world.x || y < world.y) {
      return false;
    } else {
      return x < world.x + _width && y < world.y + _height;
    }

    //return x>_mask.x &&
  }



  Panel(Game game, [Object key, Object frame]) : super(game) {

    this.layout = new VerticalLayout(this);
    this.game = game;

    //_background = new BitmapData(game, key, width, height);
    //_background.disableTextureUpload = true;
    _background = new TileSprite(game, 0, 0, width, height, key, frame);
    _background.inputEnabled = true;
    _background.input.enableDrag();
    _background.input.allowHorizontalDrag = false;
    _background.events.onDragStart.add((sender, pointer) {
      //if (checkViewPort(pointer)) {
      isDragging = true;
      //}

    });
    _background.events.onDragStop.add((sender, pointer) {
      isDragging = false;
      //Point offset = _background.input.dragOffset;
      _dirty = true;
      _background.hitArea = getHitArea();
    });


    _mask = game.make.graphics(0, 0);
    //    _border = game.make.graphics(0, 0);

    _background.mask = _mask;

    //    _view.loadTexture(_background);
    //    _view.inputEnabled = true;
    //    _view.input.enableDrag();
    //    _view.input.allowHorizontalDrag = false;


    this.addChild(_mask);
    this.addChild(_background);
    //    this.addChild(_border);
    _view = game.add.group(this);
    //_view.addChild(_mask);
    _view.mask = _mask;
  }


  GameObject addItem(GameObject item) {
    //super.addChild(item);
    _view.addChild(item);
    item.anchor.set(0.5);
    _dirty = true;
    return item;
  }

  GameObject removeItem(GameObject item) {
    //super.addChild(item);
    _view.removeChild(item);
    _dirty = true;
    return item;
  }

  Rectangle getHitArea() {
    Panel parent = findPanelParent(this);

    if (parent != null) {
      Rectangle hitArea = new Rectangle(x, y, _width, _height);
      hitArea = parent.getHitArea().intersection(hitArea);
      hitArea.offsetRect(-x - _background.x, -y - _background.y);
      //game.debug.rectangle(hitArea);
      return hitArea;
    } else {
      Rectangle hitArea = new Rectangle(-_background.x, -_background.y, _width, _height);
      return hitArea;
    }
  }

  Panel findPanelParent(GameObject panel) {
    if (panel == null || panel.parent == panel) {
      return null;
    } else if (panel.parent != null && panel.parent is Panel) {
      return panel.parent;
    } else {
      return findPanelParent(panel.parent);
    }
  }

  updateLayout() {
    layout.updateLayout();

    _mask.clear();
    _mask.lineWidth = 0;

    _mask.beginFill(0, 0);
    _mask.drawRect(0, 0, _width, _height);
    _mask.endFill();


    //    _border.clear();
    //    _border.lineWidth = _borderWidth;
    //    _border.lineColor = _borderColor;
    //_border.beginFill(_borderColor, 0);
    //    _border.drawRect(-_borderWidth, -_borderWidth, _width + 2 * _borderWidth, _height + 2 * _borderWidth);
    //_border.endFill();

    //      Rectangle bound=_mask.getBounds();
    //      _texture.resize(bound.width, bound.height);
    //      _texture.renderXY(_mask, 0, 0, true);
    //var texture = _mask.generateTexture();
    //Rectangle gbounds=_mask.getBounds();

    _view.updateTransform();
    Rectangle bounds = _view.getLocalBounds();
    //bounds.height = Math.max(bounds.height, height);
    _background.width = bounds.width;
    _background.height = bounds.height;
    //_background.resize(bounds.width, bounds.height);
    //
    //    var ctx = _background.ctx;
    //    ctx.strokeStyle = "red";
    //    ctx.fillStyle = "green";
    //    ctx.lineWidth = _borderWidth;
    //ctx.fillRect(0, 0, bounds.width, bounds.height);

    //ctx.strokeRect(0, 0, bounds.width, 200);

    num verticalSpace = bounds.height - _height;


    _background.input.boundsRect = new Rectangle(0, -verticalSpace, _width, bounds.height + verticalSpace);
    _background.hitArea = getHitArea();

  }

  update() {


    if (_dirty) {
      updateLayout();
    }
    if (isDragging || _dirty) {
      _view.y = _background.y;
      _dirty = false;
    }

    _view.children.forEach((GameObject item) {
      if (item is Panel) {
        item.update();
      }
    });
  }

  Rectangle getBounds([matrix]) {
    return new Rectangle(x, y, _width, _height);
  }
}

abstract class Layout {
  updateLayout();
}

class VerticalLayout extends Layout {
  Panel parent;

  VerticalLayout(Panel parent) {
    this.parent = parent;
  }

  updateLayout() {
    List<GameObject> items = parent._view.children;
    num currentY = 0;
    for (int i = 0; i < items.length; i++) {
      GameObject item = items[i];
      //item.updateTransform();
      item.width = parent.width;
      item.y = currentY;
      currentY += item.height;
    }
  }
}


class Tyrian extends State {
  preload() {
    //game.load.atlas('breakout', 'img/breakout.png', 'img/breakout.json');

    game.load.atlasJSONHash('tyrian', 'img/tyrian.png', 'img/tyrian.json');
    game.load.spritesheet('ground_1x1', 'img/ground_1x1.png', 32);
    game.load.spritesheet('tmw_desert_spacing', 'img/tmw_desert_spacing.png', 32, 32, -1, 1, 1);
  }


  create() {



    //game.physics.startSystem(Physics.ARCADE);

    game.stage.backgroundColor = 0x182d3b;





    Panel p = new Panel(game);
    p.borderWidth = 2;
    p.position.set(50);

    TextStyle font = new TextStyle(fill: 'white', font: '24px 微軟正黑體');

    Group getItem() {
      Group item = game.make.group();



      Graphics itemBorder = game.make.graphics();
      itemBorder.lineStyle(2, 0xff00ff);
      itemBorder.beginFill(2, 0.4);
      itemBorder.drawRect(1, 0, 198, 50);
      itemBorder.endFill();

      Sprite btn = game.add.sprite(150, 10, '__missing');
      btn.inputEnabled = true;
      btn.input.pixelPerfectClick = true;
      num shift = p.length;
      btn.events.onInputDown.add((sender, pointer) {
        if (p.checkViewPort(pointer)) {
          print("道具 ${shift}");
        }
      });

      Text text = game.make.text(100, 25, "item ${p.length}", font);
      text.anchor.setTo(0.5, 0.5);
      //      text.inputEnabled=true;
      //      text.events.onInputDown.add((p, e) {
      //        print("道具 ${p.length}");
      //      });



      item.add(itemBorder);
      item.add(btn);
      item.add(text);
      //itemBorder.y += 50 * p.length;

      return item;
    }

    p.addItem(getItem());
    p.addItem(getItem());
    p.addItem(getItem());
    p.addItem(getItem());
    p.addItem(getItem());
    p.addItem(getItem());

    Panel p2 = new Panel(game);
    p2.borderWidth = 8;
    p2.name = "p2";

    p2.addItem(getItem());
    p2.addItem(getItem());
    p2.addItem(getItem());
    p2.addItem(getItem());
    p2.addItem(getItem());

    //p2.position.set(50);
    p.addItem(p2);

    //p.visible=false;
    Border border = new Border(game, "tmw_desert_spacing");
    border.rotation=1;
    border.anchor.set(1);
    game.world.add(border);
    border.add(p);
    border.setPanel(p);
    //
    //    //game.world.add(p2);
    //
    //    Sprite btn = game.add.sprite(200, 0, '__missing');
    //    btn.inputEnabled = true;
    //    btn.events.onInputOver.add((point, e) {
    //      p.addItem(getItem());
    //    });
    //
    //Header header = new Header(game, border, '', 2);

    //game.world.add(header);
    //header.offset += p.position;

    //    Graphics mask = game.add.graphics();
    //    mask.beginFill(0, 1);
    //    mask.drawRect(0, 0, 200, 200);
    //    mask.endFill();
    //
    //    //mask.position.setTo(20, 20);
    //
    //    Graphics box = game.add.graphics();
    //    //box.boundsPadding=0;
    //
    //
    //    box.lineStyle(0, 0xff00ff);
    //    box.beginFill(0, 0.4);
    //    box.drawRect(0, 0, 200, 200);
    //    box.endFill();

    //    box.moveTo(100, 100);
    //    box.bezierCurveTo(0, 0, 200, 10, 200, 200);
    //    box.bezierCurveTo(200, 200, 10, 200, 600, 500);
    //
    //    TextStyle font = new TextStyle(fill:'white', font:'24px 微軟正黑體');
    //
    //    Sprite sp = game.add.sprite(0, 0, new BitmapData(game, '', 200, 200));
    //    //sp.width
    //    //RenderTexture rt=new RenderTexture(game,200,200);
    //
    //    Graphics getItem() {
    //      Graphics itemBorder = game.make.graphics();
    //      itemBorder.lineStyle(0, 0xff00ff);
    //      itemBorder.beginFill(0, 0.4);
    //      itemBorder.drawRect(0, 0, 200, 50);
    //      itemBorder.endFill();
    //
    //      Text text = game.make.text(100, 25, "道具", font);
    //      text.anchor.setTo(0.5, 0.5);
    //
    //      itemBorder.addChild(text);
    //      itemBorder.y += 50 * sp.children.length;
    //
    //      return itemBorder;
    //    }
    //
    //
    //    sp.addChild(getItem());
    //
    //    sp.addChild(getItem());
    //
    //    sp.addChild(getItem());
    //
    //    sp.addChild(getItem());
    //
    //    sp.addChild(getItem());
    //    //sp.position.setTo(0, 0);
    //
    //    box.position.setTo(200);
    //    box.addChild(sp);
    //    //sp.position.setTo(200);
    //    //sp.addChild(box);
    //
    //    box.addChild(mask);

    //box.events=new Events(box);
    //box.events.onInputOver=new Signal();
    //    sp.events.onInputOver.add((p,e){
    //      print("hi");
    //      box.y-=10;
    //    });
    //    box.mask = mask;
    //    // sp.mask=mask;
    //
    //
    //    sp.inputEnabled = true;
    //    sp.input.enableDrag();
    //    sp.input.allowHorizontalDrag = false;
    //    sp.input.boundsRect = new Rectangle(0, -50, 200, 250);

    //    sp.events.onDragStart.add((p,e){
    //      print("hi");
    //      sp.y-=10;
    //    });

    //box.addChild(sp);
    //game.world.add(sp);

    //box.position.setTo(100, 100);

    //game.add.image(0, 0, 'starwars');

    //    game.add.image(0, 0, 'starwars');
    //    game.add.image(0, 300, 'spaceship');
    //    game.add.image(700, 360, 'test');

    //    aliens = game.add.group();
    //    aliens.enableBody = true;
    //
    //    for (var i = 0; i < 200; i++) {
    //      int frame = game.rnd.integerInRange(0, 150);
    //      Sprite s = aliens.create(game.world.randomX, game.world.randomY, 'tyrian', frame);
    //      s.scale.set(1);
    //      s.anchor.setTo(0.5);
    //      s.body.collideWorldBounds = true;
    //      s.body.bounce.set(1);
    //      s.body.velocity.setTo(10 + Math.random() * 40, 10 + Math.random() * 40);
    //      //s.rotation = game.rnd.real() * 10;
    //      s.body.angularAcceleration=game.rnd.real() * 10;
    //    }
    //
    //    bot = game.add.sprite(200, 200, 'tyrian', '001');
    //    bot.anchor.setTo(0.5);
    //    game.physics.arcade.enableBody(bot);
    //    bot.body.angularAcceleration=game.rnd.real() * 10;
    //    bot.body.allowRotation=true;
    //
    //    bot.body.velocity.setTo(1, 20);
    //
    //    cursors = game.input.keyboard.createCursorKeys();
  }

  update() {
    //game.physics.arcade.collideSpriteVsGroup(bot,aliens);
    //bot.rotation += 0.1;
    //bot.x+=1;
  }

  render() {
    //    game.debug.quadTree(game.physics.arcade.quadTree);
    //    game.debug.body(bot);
  }

  shutdown() {

  }
}
