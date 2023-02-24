class EnglishToday{
  String? id;
  String? noun;
  String? quote;
  bool isFavorite;
  EnglishToday(
    {
      this.id,
      this.noun,
      this.isFavorite = false,
      this.quote,
    }
  );
}