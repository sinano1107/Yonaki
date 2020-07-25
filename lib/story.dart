class Story {
  int _index = 0;
  final List<List<Map<String, dynamic>>> _program = [];

  void next() => _index++;
  get program => _index < _program.length ? _program[_index] : null;
}

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
      {'p': 'setCollider', 'collider': '0.5'},
      {'p': 'setSpeed', 'speed': '60'},
      {'p': 'setAnim', 'name': 'Menasi', 'num': '1'},
      {'p': 'setChaser', 'tag': 'Menasi'},
      {'p': 'await'},
      {'p': 'destroyObject', 'tag': 'Menasi'},
      {'p': 'showStory', 'stories': '''["変な奴におそわれた", "目玉を拾ったから怒ったのだろうか"]'''},
    ],
  ];
}