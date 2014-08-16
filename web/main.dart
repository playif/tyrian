import "package:play_phaser/phaser.dart";


main() {
  Game game = new Game(800, 600, WEBGL, '');
  game.state.add('tyrian', new Tyrian());
  game.state.start('tyrian');
}


class Tyrian extends State {
  preload() {
    //game.load.atlas('breakout', 'img/breakout.png', 'img/breakout.json');

    game.load.atlasJSONHash('tyrian', 'img/tyrian.png', 'img/tyrian.json');
  }

  Sprite bot;
  CursorKeys cursors;
  Group aliens;

  create() {

    game.physics.startSystem(Physics.ARCADE);

    game.stage.backgroundColor = 0x182d3b;

    //    game.add.image(0, 0, 'starwars');
    //    game.add.image(0, 300, 'spaceship');
    //    game.add.image(700, 360, 'test');

    aliens = game.add.group();
    aliens.enableBody = true;

    for (var i = 0; i < 200; i++) {
      int frame = game.rnd.integerInRange(0, 150);
      Sprite s = aliens.create(game.world.randomX, game.world.randomY, 'tyrian', frame);
      s.scale.set(1);
      s.anchor.setTo(0.5);
      s.body.collideWorldBounds = true;
      s.body.bounce.set(1);
      s.body.velocity.setTo(10 + Math.random() * 40, 10 + Math.random() * 40);
      //s.rotation = game.rnd.real() * 10;
      s.body.angularAcceleration=game.rnd.real() * 10;
    } 

    bot = game.add.sprite(200, 200, 'tyrian', '001');
    bot.anchor.setTo(0.5);
    game.physics.arcade.enableBody(bot);
    bot.body.angularAcceleration=game.rnd.real() * 10;
    bot.body.allowRotation=true;

    bot.body.velocity.setTo(1, 20);

    cursors = game.input.keyboard.createCursorKeys();
  }

  update() {
    game.physics.arcade.collideSpriteVsGroup(bot,aliens);
    //bot.rotation += 0.1;
    //bot.x+=1;
  }

  render() {
    game.debug.quadTree(game.physics.arcade.quadTree);
    game.debug.body(bot);
  }

  shutdown() {

  }
}
