import 'package:firebase_booklist/add_book/add_book_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../domain/book.dart';
import '../edit_book/edit_book_page.dart';
import 'book_list_model.dart';

class BookListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return (ChangeNotifierProvider<BookListModel>(
      create: (_) => BookListModel()..fetchBookList(),
      child: Scaffold(
          appBar: AppBar(
            title: Text('本一覧'),
          ),
          body: Center(
            child: Consumer<BookListModel>(builder: (context, model, child) {
              final List<Book>? books = model.books;

              if (books == null) {
                return CircularProgressIndicator();
              }

              final List<Widget> widgets = books
                  .map(
                    (book) => Slidable(
                      endActionPane: ActionPane(
                        motion: DrawerMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (value) async {
                              //編集画面に遷移
                              final String? title = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditBookPage(book),
                                  ));

                              if (title != null) {
                                final snackBar = SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text("$titleを本を編集しました"),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                              model.fetchBookList();
                            },
                            backgroundColor: Colors.greenAccent,
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: '編集',
                          ),
                          SlidableAction(
                            onPressed: (value) {
                              //削除しますか？聞いて、はいなら削除
                            },
                            backgroundColor: Colors.red,
                            icon: Icons.delete,
                            label: '削除',
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(book.title),
                        subtitle: Text(book.author),
                      ),
                    ),
                  )
                  .toList();
              return ListView(
                children: widgets,
              );
            }),
          ),
          floatingActionButton:
              Consumer<BookListModel>(builder: (context, model, child) {
            return FloatingActionButton(
              onPressed: () async {
                final bool? added = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddBookPage(),
                      fullscreenDialog: true,
                    ));

                if (added != null && added) {
                  final snackBar = SnackBar(
                    backgroundColor: Colors.green,
                    content: Text("本を追加しました"),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                model.fetchBookList();
              },
              tooltip: 'Increment',
              child: Icon(Icons.add),
            );
          })),
    ));
  }
}
