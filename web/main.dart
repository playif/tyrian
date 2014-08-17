import "package:play_phaser/phaser.dart";


main() {
  Game game = new Game(800, 600, WEBGL, '');
  game.state.add('tyrian', new Tyrian());
  game.state.start('tyrian');
}

//abstract class PanelItem {
//  bool fitParent;
//}

class Header extends Sprite {
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
    });
  }

  update() {
    if (isDragging && target != null) {
      target.x = this.x + offset.x;
      target.y = this.y + offset.y;
    }
  }
}

class Panel extends Group {
  Game game;
  Layout layout;
  Graphics _mask;
  Graphics _border;

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
      Point offset = _background.input.dragOffset;
      _background.hitArea = new Rectangle(-_background.x, -_background.y, _width, _height);
    });


    _mask = game.make.graphics(0, 0);
    _border = game.make.graphics(0, 0);

    _background.mask = _mask;

//    _view.loadTexture(_background);
//    _view.inputEnabled = true;
//    _view.input.enableDrag();
//    _view.input.allowHorizontalDrag = false;


    this.addChild(_mask);
    this.addChild(_background);
    this.addChild(_border);
    _view = game.add.group(this);
    _view.mask = _mask;
  }


  GameObject addItem(GameObject item) {
    //super.addChild(item);
    _view.addChild(item);
    _dirty = true;
    return item;
  }

  GameObject removeItem(GameObject item) {
    //super.addChild(item);
    _view.removeChild(item);
    _dirty = true;
    return item;
  }

  updateLayout() {
    layout.updateLayout();

    _mask.lineWidth = 0;

    _mask.beginFill(0, 0);
    _mask.drawRect(0, 0, _width, _height);
    _mask.endFill();

    _border.lineWidth = _borderWidth;
    _border.lineColor = _borderColor;
    //_border.beginFill(_borderColor, 0);
    _border.drawRect(-_borderWidth, -_borderWidth, _width + 2 * _borderWidth, _height + 2 * _borderWidth);
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
    _background.hitArea = new Rectangle(-_background.x, -_background.y, _width, _height);

  }

  update() {
    List<GameObject> items = _view.children;
    for (int i = 0; i < items.length; i++) {
      GameObject item = items[i];
      item.update();
    }

    if (_dirty) {
      updateLayout();
      _dirty = false;
    }
    if (isDragging) {
      _view.y = _background.y;

    }
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

      Text text = game.make.text(100, 25, "道具 ${p.length}", font);
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

    //game.world.add(p2);

    Sprite btn = game.add.sprite(200, 0, '__missing');
    btn.inputEnabled = true;
    btn.events.onInputOver.add((point, e) {
      p.addItem(getItem());
    });

    Header header = new Header(game, p, 'tyrian', 2);

    game.world.add(header);
    header.offset += p.position;

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
