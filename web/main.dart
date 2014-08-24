import "package:play_phaser/phaser.dart";

import "ui.dart";

main() {
  Game game = new Game(480, 800, WEBGL, '');
  game.state.add('tyrian', new Tyrian());
  game.state.start('tyrian');
}

abstract class Entity extends GameObject {
//  num x,y;
  num HP, MHP;
  int team;


  num getBarValue(int type);
//num getBarMaxValue(int type);

}

class Bar extends TileSprite {
  Entity entity;
  int barType;
  num maxValue;

  Bar(Game game, Entity entity, [num width = 10, num height = 5, int barType = 0, num maxValue = 10, Object key, Object frame])
  : super(game, 0, 0, 12, 20, key, frame) {
    this.entity = entity;
    this.barType = barType;
    this.maxValue = maxValue;
  }


}

class Flight extends Sprite implements Entity {
  num HP = 3,
  MHP = 3,
  team = 0;
  Group<Bullet> bullets;

//  List<Weapon> weapons = new List<Weapon>();
  FlightType flightType;

  bool isEnemy = true;

  num _direction = 0;

  num nextFireTime = 0;

  num get direction => _direction;

  set direction(num value) {
    _direction = value;
    rotation = _direction;
  }

  num getBarValue(int type) {
    return HP;
  }

  Flight(Game game, bullets, [Object key, Object frame])
  : super(game, 0, 0, key, frame) {
    this.bullets = bullets;
    this.key = key;
  }

//  addWeapon(Weapon weapon, [Point shift]) {
//    //Weapon weapon =new Weapon(this);
//    if (shift != null) {
//      weapon.shift = shift;
//    }
//
//
//    weapons.add(weapon);
//  }

//  fire() {
//    for (Weapon weapon in weapons) {
//      weapon.tryFire();
//    }
//  }

  update() {
    if (!this.exists) return;
    if (game.time.now >= nextFireTime) {
      nextFireTime = game.time.now + flightType.fireCD;

      flightType.fire(this);

    }
  }

  resetFlight(num x, num y, FlightType type, [bool isEnemy=false]) {
    this.reset(x, y);
    this.loadTexture('tyrian', type.frame);
    this.isEnemy = isEnemy;
    this.flightType = type;
    this.MHP = this.HP = type.MHP;
    //this._fire=fire;
    if (this.isEnemy) {
      this.rotation=Math.PI;
    }
  }

}

typedef FireFunc(Flight flight, [target]);

class FlightType {
  num fireCD = 1000;
  num MHP = 2;
  Object frame = "011";
  Function fire = basicFire;

  static FlightType BasicFlight = new FlightType();


  static basicFire(Flight flight, [target]) {
    Group<Bullet> bullets = flight.bullets;
    Bullet bullet = flight.bullets.getFirstExists(false);
    num x = flight.x;
    num y = flight.y;
    if (bullet != null) {
      bullet.resetBullet(x, y, BulletType.basicBullet, flight, target);

    } else {
      print("Error! not enough bullets in pool.");
    }
  }
}

class BulletType {
  num damage = 1;
  Object frame = "bullets/ball";
  Point velocity = new Point(0, -1000);

  static BulletType basicBullet = new BulletType();
}

class Weapon {
  Flight flight;
  Point shift = new Point();
  num cdTime = 1000;
  num cdCounter = 0;

  Weapon(Flight flight) {
    this.flight = flight;
  }

  tryFire() {

  }
}

class Bullet extends Sprite {
  //Group<Bullet> group;
  BulletType bulletType;
  Flight flight;
  var target;

  Bullet(Game game, [Object key, Object frame])
  : super(game, 0, 0, key, frame) {
    this.key = key;
    //game.physics.enable(this);
    //this.group=group;


    //group.addChild(this);
  }

  resetBullet(num x, num y, BulletType bulletType, Flight flight, [target]) {
    this.reset(x, y);

    this.bulletType = bulletType;
    this.loadTexture('tyrian', bulletType.frame);
    this.flight = flight;
    this.target = target;

    this.body.velocity.copyFrom(bulletType.velocity);
    if (flight.isEnemy) {
      this.body.velocity.y *= -1;
    }

  }

}


class FlightInfo {
  num x = 0,
  y = 0;
  int FlightType = 0;

}


class Tyrian extends State {

  preload() {
    //game.load.spritesheet("sword2", "img/Sword2.png", 192);
    game.load.spritesheet('kaboom', 'img/explode.png', 128, 128);
    game.load.atlasJSONHash('tyrian', 'img/tyrian.png', 'img/tyrian.json');
    game.load.spritesheet('ground_1x1', 'img/ground_1x1.png', 32);
    game.load.spritesheet('tmw_desert_spacing', 'img/tmw_desert_spacing.png', 32, 32, -1, 1, 1);
  }

  Key k;
  Sprite sword2;

  Group<Flight> playerFlights;
  Group<Flight> enemyFlights;
  Group<Bullet> playerBullets;
  Group<Bullet> enemyBullets;
  Group<Sprite> explosions;

  List<FlightInfo> playerInfo;
  List<FlightInfo> levels;


  setupLevel(List<FlightInfo> flightInfos, Group<Flight> flights, [bool invert = false]) {

    for (FlightInfo flightInfo in flightInfos) {
      Flight flight = flights.getFirstAlive();
      flight.reset(flightInfo.x, flightInfo.y);
      flight.anchor.setTo(0.5);

      if (invert) {
        flight.direction = 1;
      } else {
        flight.direction = -1;
      }


    }
  }

  clearLevel() {
    playerFlights.forEachAlive((Sprite g) => g.kill());
    enemyFlights.forEachAlive((Sprite g) => g.kill());
    playerBullets.forEachAlive((Sprite g) => g.kill());
    enemyBullets.forEachAlive((Sprite g) => g.kill());
  }

  create() {

//    sword2 = game.add.sprite(300, 300, "sword2");
//    sword2.animations.add("hit", [0, 1, 2, 3, 4, 5]);
//    sword2.animations.add("hit2", [6, 7, 8, 9, 10, 11]);
//    sword2.anchor.setTo(0.5);
//    k = game.input.keyboard.addKey(Keyboard.A);


    //game.physics.startSystem(Physics.ARCADE);

    game.stage.backgroundColor = 0x101010;

    //  An explosion pool
    explosions = game.add.group();
    explosions.createMultiple(30, 'kaboom');
    explosions.forEach(setupInvader);
    //game.scale.s

    playerFlights = game.add.group();
    playerBullets = game.add.group();
    enemyFlights = game.add.group();
    enemyBullets = game.add.group();

    playerFlights.enableBody = true;
    playerFlights.creator = () => new Flight(game, playerBullets, "tyrian")
      ..anchor.setTo(0.5);

    playerFlights.createMultiple(100);

    playerBullets.enableBody = true;
    playerBullets.creator = () => new Bullet(game, "tyrian")
      ..anchor.setTo(0.5)
      ..outOfBoundsKill = true
      ..checkWorldBounds = true;
    playerBullets.createMultiple(1000);

    enemyFlights.enableBody = true;
    enemyFlights.creator = () => new Flight(game, enemyBullets, "tyrian")
      ..anchor.setTo(0.5);

    enemyFlights.createMultiple(100);

    enemyBullets.enableBody = true;
    enemyBullets.creator = () => new Bullet(game, "tyrian")
      ..anchor.setTo(0.5)
      ..outOfBoundsKill = true
      ..checkWorldBounds = true;

    enemyBullets.createMultiple(1000);

    Flight flight = playerFlights.getFirstExists(false);
    flight.resetFlight(200, 700, FlightType.BasicFlight);

    Flight enemy = enemyFlights.getFirstExists(false);
    enemy.resetFlight(200, 200, FlightType.BasicFlight, true);


//    Panel p = new VerticalPanel(game);
//    p.borderWidth = 2;
//    p.position.set(50);
//
//    TextStyle font = new TextStyle(fill: 'white', font: '24px 微軟正黑體');
//
//    Group getItem() {
//      Group item = game.make.group();
//
//      num randW = game.rnd.integerInRange(10, 100);
//      num randH = game.rnd.integerInRange(10, 100);
//
//      Graphics itemBorder = game.make.graphics();
//      itemBorder.lineStyle(2, 0xff00ff);
//      itemBorder.beginFill(2, 0.4);
//      //itemBorder.drawRect(1, 0, randW, randH);
//      itemBorder.drawRect(1, 0, 32, 32);
//      itemBorder.endFill();
//
//      //      Sprite btn = game.add.sprite(150, 10, '__missing');
//      //      btn.inputEnabled = true;
//      //      btn.input.pixelPerfectClick = true;
//      //      num shift = p.length;
//      //      btn.events.onInputDown.add((sender, pointer) {
//      //        //if (p.checkViewPort(pointer)) {
//      //        print("道具 ${shift}");
//      //        //}
//      //      });
//
//      Text text = game.make.text(100, 25, "item ${p.length}", font);
//      text.anchor.setTo(0.5, 0.5);
//      //      text.inputEnabled=true;
//      //      text.events.onInputDown.add((p, e) {
//      //        print("道具 ${p.length}");
//      //      });
//
//
//      item.add(itemBorder);
//      //item.add(btn);
//      //item.add(text);
//      //itemBorder.y += 50 * p.length;
//      //item.updateTransform();
//      //item.width=200;
//      return item;
//    }
//
//    p.addItem(getItem());
//    p.addItem(getItem());
//    //    p.addItem(getItem());
//    //    p.addItem(getItem());
//    //    p.addItem(getItem());
//    //    p.addItem(getItem());
//
//    FlowPanel p2 = new FlowPanel(game);
//    p2.width = 300;
//    p2.wrapWidth = 600;
//
//
//    p2.borderWidth = 8;
//    p2.name = "p2";
//
//    for (int i = 0; i < 500; i++) {
//      p2.addItem(getItem());
    ////      p2.addItem(getItem());
    ////      p2.addItem(getItem());
    ////      p2.addItem(getItem());
    ////      p2.addItem(getItem());
//    }
//    p2.addItem(getItem());
//    p2.addItem(getItem());
//    p2.addItem(getItem());
//    p2.addItem(getItem());
//    p2.addItem(getItem());
//    //p2.updateTransform();
//
//
//    //p2.position.set(50);
//    //p.addItem(p2);
//
//    //p.visible=false;
//    Border border = new Border(game, "tmw_desert_spacing");
//    //border.rotation=1;
//    border.anchor.set(1);
//    //game.world.add(border);
//    //border.add(p);
//    //border.setPanel(p);
//    //
//    //    //game.world.add(p2);
//    //
//    //    Sprite btn = game.add.sprite(200, 0, '__missing');
//    //    btn.inputEnabled = true;
//    //    btn.events.onInputOver.add((point, e) {
//    //      p.addItem(getItem());
//    //    });
//    //
//    Header header = new Header(game, border, '', 2);

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

  setupInvader(Sprite invader) {
    invader.anchor.x = 0.5;
    invader.anchor.y = 0.5;
    invader.animations.add('kaboom');
  }

  update() {
    game.physics.arcade.overlap(enemyBullets, playerFlights, collisionHandler);
    game.physics.arcade.overlap(playerBullets, enemyFlights, collisionHandler);


//    Point p = game.input.position;
//    //game.input.mousePointer.justReleased()
//    if (game.input.mousePointer.justPressed()) {
//      sword2.position.copyFrom(p);
//      sword2.revive();
//      sword2.play("hit2", 16.66, false, true);
//    }
    //game.physics.arcade.collideSpriteVsGroup(bot,aliens);
    //bot.rotation += 0.1;
    //bot.x+=1;
  }

  collisionHandler(Bullet bullet, Flight flight) {

    //  When a bullet hits an alien we kill them both
    bullet.kill();
    flight.HP -= bullet.bulletType.damage;

    var explosion = explosions.getFirstExists(false);
    explosion.reset(bullet.x, bullet.y);
    explosion.play('kaboom', 30, false, true);

    if (flight.HP <= 0) {
      flight.kill();
    }

    //flight.kill();

//  //  Increase the score
//  score += 20;
//  scoreText.text = scoreString + score.toString();
//
//  //  And create an explosion :)
//  var explosion = explosions.getFirstExists(false);
//  explosion.reset(alien.body.x, alien.body.y);
//  explosion.play('kaboom', 30, false, true);
//
//  if (aliens.countLiving() == 0) {
//    score += 1000;
//    scoreText.text = scoreString + score.toString();
//
//    enemyBullets.forEach((Sprite s) => s.kill());
//    stateText.text = " You Won, \n Click to restart";
//    stateText.visible = true;
//
//    //the "click to restart" handler
//    game.input.onTap.addOnce(restart);
//  }

  }

  render() {
    //    game.debug.quadTree(game.physics.arcade.quadTree);
    //    game.debug.body(bot);
  }

  shutdown() {

  }
}
