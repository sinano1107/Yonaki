class JapaneseService {
  // 日本のパーセント
  String japanesePercent(double percent) {
    if (percent > 1) {
      return '満';
    } else {
      return '${japaneseNum((percent ~/ 0.1))}割${japaneseNum((percent ~/ 0.01) % 10)}分';
    }
  }

  // 日本の古典数字
  String japaneseNum(int num) {
    switch (num) {
      case 0:
        return '零';
      case 1:
        return '壱';
      case 2:
        return '弐';
      case 3:
        return '参';
      case 4:
        return '肆';
      case 5:
        return '伍';
      case 6:
        return '陸';
      case 7:
        return '漆';
      case 8:
        return '捌';
      case 9:
        return '玖';
      case 10:
        return '拾';
      default:
        return '不';
    }
  }
}