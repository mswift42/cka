class PageResultsService {
  int currentPage;


  String nextPage(String currentPage) {
    var curr = int.tryParse(currentPage);
    if (curr == null) {
      return "";
    }
    return (curr + 30).toString();
  }

}