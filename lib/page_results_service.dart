class PageResultsService {
  int currentPage;


  String nextPage(String currentPage) {
    var curr = int.tryParse(currentPage);
    if (curr == null) {
      return "";
    }
    return (curr + 30).toString();
  }

  String prevPage(String currentPage) {
    var curr = int.tryParse(currentPage);
    if (curr == null) {
      return "";
    }
    if (curr < 30) {
      return "0";
    }
    return (curr - 30).toString();
  }
}