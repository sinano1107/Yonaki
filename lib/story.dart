import 'dart:math' as math;

dynamic getRandomStory() {
  var rand = math.Random();
  dynamic newStory = _stories[rand.nextInt(_stories.length)];
  // ２回目だった時のためindexをリセット
  newStory.reset();
  return newStory;
}

class Story {
  int _index = 0;
  final List<List<Map<String, dynamic>>> _program = [];

  void next() => _index++;
  void reset() => _index = 0;
  get program => _index < _program.length ? _program[_index] : null;
}

//------------------------------------------------------------------------------

dynamic _stories = [
  Menasi(),
  Ichimatu(),
  Hand(),
];

//-目無し------------------------------------------------------------------------
class Menasi extends Story {
  List<List<Map<String, dynamic>>> _program = [
    [
      {'p': 'createObject', 'name': 'eyeball', 'space': '0', 'number': '1'},
      {'p': 'setTrigger', 'trigger': 'Find'},
      {'p': 'showStory', 'stories': '''["なんだこの目玉、本物かな(笑)", "面白いから持って帰ろう。"]'''},
      {'p': 'resetGauge'},
      {'p': 'setTrigger', 'trigger': 'PickUp'},
    ],
    [
      {'p': 'createObject', 'name': 'menasi', 'space': '3', 'number': '1'},
      {'p': 'setTrigger', 'trigger': 'Find'},
      {'p': 'showStory', 'stories': '''["なんだあいつ"]'''},
      {'p': 'toggleShowGauge'},
      {'p': 'startChase', 'speed': '60', 'collider': '0.5'},
      {'p': 'setAnim', 'num': '1'},
      {'p': 'await'},
      {'p': 'destroyObject'},
      {'p': 'showStory', 'stories': '''["変な奴におそわれた", "目玉を拾ったから怒ったのだろうか"]'''},
    ],
  ];
}

//-市松人形----------------------------------------------------------------------
class Ichimatu extends Story {
  List<List<Map<String, dynamic>>> _program = [
    [
      {'p': 'createObject', 'name': 'ichimatu', 'space': '0', 'number': '1'},
      {'p': 'showStory', 'stories': '''["近くに何か落ちている..."]'''},
      {'p': 'setTrigger', 'trigger': 'Find'},
      {'p': 'showStory', 'stories': '''["気味の悪い人形だな", "放っておこう、"]'''},
    ],
    [
      {'p': 'createObject', 'name': 'ichimatu', 'space': '0', 'number': '1'},
      {'p': 'setTrigger', 'trigger': 'Find'},
      {'p': 'showStory', 'stories': '''["また落ちてる......", "ハハっ、、\\nどうせ偶然だよ。。たまたま、"]'''},
    ],
    [
      {'p': 'createObject', 'name': 'ichimatu', 'space': '1', 'number': '1'},
      {'p': 'setTrigger', 'trigger': 'Find'},
      {'p': 'showStory', 'stories': '''["嘘だろ..."]'''},
      {'p': 'resetGauge'},
      {'p': 'setTrigger', 'trigger': 'Find'},
      {'p': 'toggleShowGauge'},
      {'p': 'startChase', 'speed': '30', 'collider': '0.5'},
      {'p': 'setAnim', 'num': '1'},
      {'p': 'await'},
      {'p': 'destroyObject'},
      {'p': 'showStory', 'stories': '''["道に落ちている日本人形には気をつけよう..."]'''},
    ],
  ];
}

//-手---------------------------------------------------------------------------
class Hand extends Story {
  List<List<Map<String, dynamic>>> _program = [
    [
      {'p': 'createObject', 'name': 'hand', 'space': '1', 'number': '1'},
      {'p': 'setTrigger', 'trigger': 'Find'},
      {'p': 'showStory', 'stories': '''["うわ、キモ..."]'''},
      {'p': 'startChase', 'speed': '30', 'collider': '0.2'},
      {'p': 'setAnim', 'num': '1'},
      {'p': 'toggleShowGauge'},
      {'p': 'await'},
      {'p': 'showStory', 'stories': '''["地面から生えた手に足をつかまれたが\\nなんとか振り切って逃げた"]'''},
    ],
    [
      {'p': 'createObject', 'name': 'hand', 'space': '2', 'number': '20'},
      {'p': 'setTrigger', 'trigger': 'Find'},
      {'p': 'showStory', 'stories': '''["増えてる......\\nてか、かこまれた！！"]'''},
      {'p': 'startChase', 'speed': '30', 'collider': '0.2'},
      {'p': 'setAnim', 'num': '1'},
      {'p': 'toggleShowGauge'},
      {'p': 'await'},
      {'p': 'showStory', 'stories': '''["気づいたら道端に倒れ込んでいた。", "もう、あのたくさんの手はなくなっていた。", "気味が悪い\\nはやく家に帰ろう"]'''},
    ],
    [
      {'p': 'createObject', 'name': 'hand', 'space': '3', 'number': '50'},
      {'p': 'setTrigger', 'trigger': 'Find'},
      {'p': 'showStory', 'stories': '''["うわあああああああぁあぁ！！！！！！"]'''},
      {'p': 'startChase', 'speed': '40', 'collider': '0.2'},
      {'p': 'setAnim', 'num': '1'},
      {'p': 'toggleShowGauge'},
      {'p': 'await'},
      {'p': 'showStory', 'stories': '''["またひとり\\n行方のわからない人間が増えてしまいました"]'''},
    ],
  ];
}