import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer';

class DailyQuotes {
  final String apiUrl =
      'https://api.forismatic.com/api/1.0/?method=getQuote&lang=en&format=json';
  final String placeholderQuote =
      'Believe in yourself. You are braver than you think, more talented than you know, and capable of more than you imagine.';

  Future<String> fetchQuote() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final quoteText = data['quoteText'];
        final quoteAuthor = data['quoteAuthor'];
        return '$quoteText - $quoteAuthor';
      } else {
        log('Failed to load quote: ${response.statusCode}');
        return placeholderQuote;
      }
    } catch (e) {
      log('Error fetching quote: $e');
      return placeholderQuote;
    }
  }
}
