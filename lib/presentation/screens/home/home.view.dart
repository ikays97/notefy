import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morphosis_flutter_demo/presentation/shared/widgets/error_widget.dart';

import 'search.bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _searchTextField;
  late SearchBloc searchBloc;

  @override
  void initState() {
    searchBloc = BlocProvider.of<SearchBloc>(context);
    _searchTextField = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _searchTextField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [],
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CupertinoSearchTextField(
              controller: _searchTextField,
              placeholder: "Search",
              onSubmitted: (v) async {
                if (v.isNotEmpty) {
                  await searchBloc.searchPosts(v);
                }
              },
            ),
            const SizedBox(height: 16),
            if (searchBloc.state.queries.isNotEmpty)
              Wrap(
                children: searchBloc.state.queries
                    .map((e) => Chip(label: Text(e)))
                    .toList(),
              ),
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                bloc: searchBloc,
                builder: (context, state) {
                  if (state.status == SearchStatus.searching) {
                    return Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  } else if (state.error != null) {
                    return ErrorMessage(
                      message: state.error!,
                      buttonTitle: "RETRY",
                      onTap: () {
                        searchBloc.searchPosts(_searchTextField.text);
                      },
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.results.length,
                          itemBuilder: (context, index) {
                            var post = state.results[index];
                            return InkWell(
                              onTap: () {},
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: CircleAvatar(
                                  radius: 22,
                                  backgroundColor: Colors.black12,
                                  child: Center(
                                    child: Text(
                                      post.title.substring(0, 1).toUpperCase(),
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  post.title,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
