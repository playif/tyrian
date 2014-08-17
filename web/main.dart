import "package:play_phaser/phaser.dart";


main() {
  Game game = new Game(800, 600, WEBGL, '');
  game.state.add('tyrian', new Tyrian());
  game.state.start('tyrian');
}


class Panel {
  Layout layout;

  update(){
    layout.updateLayout();
  }
}

abstract class Layout {
  updateLayout();
}

class VerticalLayout extends Layout {

}


class Tyrian extends State {
  preload() {
    //game.load.atlas('breakout', 'img/breakout.png', 'img/breakout.json');

    game.load.atlasJSONHash('tyrian', 'img/tyrian.png', 'img/tyrian.json');
  }


  create() {

    //game.physics.startSystem(Physics.ARCADE);

    game.stage.backgroundColor = 0x182d3b;

    Graphics mask = game.add.graphics();
    mask.beginFill(0, 1);
    mask.drawRect(0, 0, 200, 200);
    mask.endFill();

    //mask.position.setTo(20, 20);

    Graphics box = game.add.graphics();
    //box.boundsPadding=0;


    box.lineStyle(0, 0xff00ff);
    box.beginFill(0, 0.4);
    box.drawRect(0, 0, 200, 200);
    box.endFill();

//    box.moveTo(100, 100);
//    box.bezierCurveTo(0, 0, 200, 10, 200, 200);
//    box.bezierCurveTo(200, 200, 10, 200, 600, 500);

    TextStyle font = new TextStyle(fill:'white', font:'24px 微軟正黑體');

    Sprite sp = game.add.sprite(0, 0, new BitmapData(game, '', 200, 200));
    //sp.width
    //RenderTexture rt=new RenderTexture(game,200,200);

    Graphics getItem() {
      Graphics itemBorder = game.make.graphics();
      itemBorder.lineStyle(0, 0xff00ff);
      itemBorder.beginFill(0, 0.4);
      itemBorder.drawRect(0, 0, 200, 50);
      itemBorder.endFill();

      Text text = game.make.text(100, 25, "道具", font);
      text.anchor.setTo(0.5, 0.5);

      itemBorder.addChild(text);
      itemBorder.y += 50 * sp.children.length;

      return itemBorder;
    }


    sp.addChild(getItem());

    sp.addChild(getItem());

    sp.addChild(getItem());

    sp.addChild(getItem());

    sp.addChild(getItem());
    //sp.position.setTo(0, 0);

    box.position.setTo(200);
    box.addChild(sp);
    //sp.position.setTo(200);
    //sp.addChild(box);

    box.addChild(mask);

    //box.events=new Events(box);
    //box.events.onInputOver=new Signal();
//    sp.events.onInputOver.add((p,e){
//      print("hi");
//      box.y-=10;
//    });
    box.mask = mask;
    // sp.mask=mask;


    sp.inputEnabled = true;
    sp.input.enableDrag();
    sp.input.allowHorizontalDrag = false;
    sp.input.boundsRect = new Rectangle(0, -50, 200, 250);

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
