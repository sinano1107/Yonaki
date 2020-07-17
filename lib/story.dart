class Story {
  int _index = 0;
  final List<List<String>> _program = [];

  void next() => _index++;
  get program => _index < _program.length ? _program[_index] : null;
}

//-目無し------------------------------------------------------------------------
class Menasi extends Story {
  List<List<String>> _program = [
    [
      '''{"process": "setObject", "name": "Eyeball"}''',
      '''{"process": "createObject", "space": "0"}''',
      '''{"process": "setTrigger", "trigger": "Find"}''',
      '''{"process": "showStory", "stories": ["なんだこの目玉、本物かな(笑)", "面白いから持って帰ろう。"]}''',
      '''{"process": "setTrigger", "trigger": "PickUp"}''',
    ],
    [
      '''{"process": "setObject", "name": "Menasi"}''',
      '''{"process": "createObject", "space": "3"}''',
      '''{"process": "setTrigger", "trigger": "Find"}''',
      '''{"process": "showStory", "stories": ["なんだあいつ"]}''',
      '''{"process": "toggleShowGauge"}''',
      '''{"process": "setCollider", "collider": "0.5"}''',
      '''{"process": "setSpeed", "speed": "60"}''',
      '''{"process": "setAnimTarget", "name": "Menasi"}''',
      '''{"process": "setAnim", "num": "1"}''',
      '''{"process": "setChaser", "tag": "Menasi"}''',
      '''{"process": "await"}''',
      '''{"process": "destroyObject", "tag": "Menasi"}''',
      '''{"process": "showStory", "stories": ["変な奴におそわれた", "目玉を拾ったから怒ったのだろうか"]}''',
    ],
  ];
}