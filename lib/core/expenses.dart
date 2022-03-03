class SaveExpenses {
  final int userId;
  final double amount;
  final String title;
  final String description;

  SaveExpenses(
      {required this.amount,
      required this.userId,
      required this.description,
      required this.title});

  factory SaveExpenses.fromJson(Map<String, dynamic> json) {
    return SaveExpenses(
        amount: json["amount"],
        userId: json["user_id"],
        description: json["description"],
        title: json["title"]);
  }
}
