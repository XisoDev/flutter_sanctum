import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sanctum/auth.dart';
import 'dart:convert';
import 'utils/constants.dart';

class Book {
  final int id;
  final String title;
  final String author;
  Book({required this.id, required this.title, required this.author});
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
    );
  }
}

class BookList extends StatefulWidget {
  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  late Future<List<Book>> futureBooks;

  @override
  void initState() {
    super.initState();
    futureBooks = fetchBooks();
  }

  Future<List<Book>> fetchBooks() async {
    List<Book> books = [];
    String token = await Provider.of<AuthProvider>(context, listen: false).getToken() ?? '';
    final response = await http.get(Uri.parse('$API_URL/book'), headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      for (int i = 0; i < data.length; i++) {
        books.add(Book.fromJson(data[i]));
      }
      return books;
    } else {
      throw Exception('Problem loading books');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ElevatedButton(
          child: const Text('Logout'),
          onPressed: () {
            Provider.of<AuthProvider>(context, listen: false).logout();
          },
        ),
        BookListBuilder(futureBooks: futureBooks),
      ],
    );
  }
}

class BookListBuilder extends StatelessWidget {
  const BookListBuilder({super.key,
    required this.futureBooks,
  });

  final Future<List<Book>> futureBooks;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Book>>(
        future: futureBooks,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Expanded(child: ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                Book book = snapshot.data![index];
                return ListTile(
                  title: Text(book.title),
                  subtitle: Text(book.author),
                );
              },
            ));
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return const CircularProgressIndicator();
        }
    );
  }
}