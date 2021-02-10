String japaneseWeekday(int year, int month, int date) {
  var weekday = DateTime(year, month, date).weekday;
  switch (weekday) {
    case 0:
      return '日';
    case 1:
      return '月';
    case 2:
      return '火';
    case 3:
      return '水';
    case 4:
      return '木';
    case 5:
      return '金';
    case 6:
      return '土';
    case 7:
      return '日';
    default:
      return '-';
  }
}
