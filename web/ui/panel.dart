part of PhaserUI;

class Panel extends Group {
  Game game;
  //Layout layout;
  Graphics _mask;
  Group _view;
  TileSprite _background;

  bool fitParent;
  bool _dirty = true;

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

  num margin = 1;
  num spacing = 2;

  bool isDragging = false;

  bool fitChild = false;
  //0 left, 1 center, 2 right
  int alignChild = 0;

  //  bool checkViewPort(point) {
  //    Point world = this.world;
  //
  //    num x = point.x;
  //    num y = point.y;
  //    if (x < world.x || y < world.y) {
  //      return false;
  //    } else {
  //      return x < world.x + _width && y < world.y + _height;
  //    }
  //
  //  }

  List<Panel> panels = new List<Panel>();


  Panel(Game game, [Object key, Object frame]) : super(game) {

    //this.layout = new VerticalLayout(this);
    this.game = game;

    _background = new TileSprite(game, 0, 0, width, height, key, frame);
    _background.inputEnabled = true;
    _background.input.enableDrag();

    _background.events.onDragStart.add((sender, pointer) {
      isDragging = true;
    });
    _background.events.onDragStop.add((sender, pointer) {
      isDragging = false;
      _dirty = true;
      _background.hitArea = getHitArea();
    });


    _mask = game.make.graphics(0, 0);

    _background.mask = _mask;


    this.addChild(_mask);
    this.addChild(_background);

    _view = game.add.group(this);
    _view.mask = _mask;
  }


  GameObject addItem(GameObject item) {
    //super.addChild(item);
    _view.addChild(item);
    item.anchor.set(0.5);
    _dirty = true;

    if (item is Panel) {
      panels.add(item);
    }

    return item;
  }

  GameObject removeItem(GameObject item) {
    //super.addChild(item);
    _view.removeChild(item);
    _dirty = true;

    if (item is Panel) {
      panels.remove(item);
    }

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
    //layout.updateLayout();

    _mask.clear();
    //_mask.lineWidth = 20;

    _mask.beginFill(0, 0);
    _mask.drawRect(0, 0, _width, _height);
    _mask.endFill();


    _view.updateTransform();
    Rectangle bounds = _view.getLocalBounds();
    bounds.width = Math.max(bounds.width, _width);
    bounds.height = Math.max(bounds.height, _height);

    _background.width = bounds.width;
    _background.height = bounds.height;

    num horizontalSpace = bounds.width - _width;
    num verticalSpace = bounds.height - _height;

    _background.input.boundsRect = new Rectangle(-horizontalSpace, -verticalSpace, bounds.width + horizontalSpace, bounds.height + verticalSpace);
    _background.hitArea = getHitArea();


  }

  update() {


    if (_dirty) {

      updateLayout();
    }

    if (isDragging || _dirty) {
//      _view.cacheAsBitmap=false;
      _view.y = _background.y;
      _view.x = _background.x;
    }


    panels.forEach((Panel item) {
      //if (item is Panel) {
      if (_dirty) {
        item._dirty = true;
      }
      item.update();
      //}
    });

    _dirty = false;

  }

  Rectangle getBounds([matrix]) {
    return new Rectangle(x, y, _width, _height);
  }
}

//abstract class Layout {
//  updateLayout();
//}

class VerticalPanel extends Panel {
  //  Panel panel;
  //
  //  VerticalLayout(Panel panel) {
  //    this.panel = panel;
  //  }

  VerticalPanel(Game game, [Object key, Object frame]) : super(game, key, frame) {
    _background.input.allowHorizontalDrag = false;
  }

  updateLayout() {
    bool fit = fitChild;
    List<GameObject> items = _view.children;
    num currentY = margin;
    for (int i = 0; i < items.length; i++) {
      GameObject item = items[i];
      if (fit) {
        item.width = _width;
      }

      item.y = currentY;
      currentY += item.height + spacing;
    }
    super.updateLayout();
  }
}

class HorizontalPanel extends Panel {
  //  Panel panel;
  //
  //  VerticalLayout(Panel panel) {
  //    this.panel = panel;
  //  }

  HorizontalPanel(Game game, [Object key, Object frame]) : super(game, key, frame) {
    _background.input.allowVerticalDrag = false;
  }

  updateLayout() {
    bool fit = fitChild;
    List<GameObject> items = _view.children;
    num currentX = margin;
    for (int i = 0; i < items.length; i++) {
      GameObject item = items[i];
      if (fit) {
        item.height = _height;
      }

      item.x = currentX;
      currentX += item.width + spacing;
    }
    super.updateLayout();
  }
}

class FlowPanel extends Panel {
  //  Panel panel;
  //
  //  VerticalLayout(Panel panel) {
  //    this.panel = panel;
  //  }
  num wrapWidth = 200;

  FlowPanel(Game game, [Object key, Object frame]) : super(game, key, frame) {
    //_background.input.allowVerticalDrag = false;
  }

  updateLayout() {
    //bool fit = fitChild;
    List<GameObject> items = _view.children;
    num currentX = margin;
    num currentY = margin;
    num wrapHeight = 0;
    for (int i = 0; i < items.length; i++) {
      GameObject item = items[i];
      num extendX = item.width + spacing;

      if (currentX + extendX > wrapWidth) {
        currentX = margin;
        currentY += wrapHeight + spacing;
        wrapHeight = 0;
      }

      item.x = currentX;
      item.y = currentY;

      if (wrapHeight < item.height) {
        wrapHeight = item.height;
      }

      currentX += extendX;



    }
    super.updateLayout();
  }
}