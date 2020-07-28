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
];

//-目無し------------------------------------------------------------------------
class Menasi extends Story {
  List<List<Map<String, dynamic>>> _program = [
    [
      {'p': 'createObject', 'name': 'Eyeball', 'space': '0'},
      {'p': 'setTrigger', 'trigger': 'Find'},
      {'p': 'showStory', 'stories': '''["なんだこの目玉、本物かな(笑)", "面白いから持って帰ろう。"]'''},
      {'p': 'resetGauge'},
      {'p': 'setTrigger', 'trigger': 'PickUp'},
    ],
    [
      {'p': 'createObject', 'name': 'Menasi', 'space': '3'},
      {'p': 'setTrigger', 'trigger': 'Find'},
      {'p': 'showStory', 'stories': '''["なんだあいつ"]'''},
      {'p': 'toggleShowGauge'},
      {'p': 'startChase', 'tag': 'Menasi', 'speed': '60', 'collider': '0.5'},
      {'p': 'setAnim', 'name': 'Menasi', 'num': '1'},
      {'p': 'await'},
      {'p': 'destroyObject', 'tag': 'Menasi'},
      {'p': 'showStory', 'stories': '''["変な奴におそわれた", "目玉を拾ったから怒ったのだろうか"]'''},
    ],
  ];
}

//-市松人形----------------------------------------------------------------------
class Ichimatu extends Story {
  List<List<Map<String, dynamic>>> _program = [
    [
      {'p': 'createObject', 'name': 'Ichimatu', 'space': '0'},
      {'p': 'showStory', 'stories': '''["近くに何か落ちている..."]'''},
      {'p': 'setTrigger', 'trigger': 'Find'},
      {'p': 'showStory', 'stories': '''["気味の悪い人形だな", "放っておこう、"]'''},
    ],
    [
      {'p': 'createObject', 'name': 'Ichimatu', 'space': '0'},
      {'p': 'setTrigger', 'trigger': 'Find'},
      {'p': 'showStory', 'stories': '''["また落ちてる......", "ハハっ、、\\nどうせ偶然だよ。。たまたま、"]'''},
    ],
    [
      {'p': 'createObject', 'name': 'Ichimatu', 'space': '1'},
      {'p': 'setTrigger', 'trigger': 'Find'},
      {'p': 'showStory', 'stories': '''["嘘だろ..."]'''},
      {'p': 'resetGauge'},
      {'p': 'setTrigger', 'trigger': 'Find'},
      {'p': 'toggleShowGauge'},
      {'p': 'startChase', 'tag': 'Ichimatu', 'speed': '30', 'collider': '0.5'},
      {'p': 'setAnim', 'name': 'Ichimatu', 'num': '1'},
      {'p': 'await'},
      {'p': 'destroyObject', 'tag': 'Ichimatu'},
      {'p': 'showStory', 'stories': '''["道に落ちている日本人形には気をつけよう..."]'''},
    ],
  ];
}