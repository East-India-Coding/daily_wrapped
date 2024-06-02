class GeminiOutput {
  final String title;
  final String description;

  const GeminiOutput(this.title, this.description);

  factory GeminiOutput.fromJson(Map<String, dynamic> json) =>
      GeminiOutput(json['title'] ?? "", json['description'] ?? "");

  @override
  String toString() {
    return 'GeminiOutput{title: $title, description: $description}';
  }
}
