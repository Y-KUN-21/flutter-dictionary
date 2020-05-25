import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String _url = "https://owlbot.info/api/v4/dictionary/";
  String _token = "YOUR_TOKEN";
  TextEditingController _controller = TextEditingController();
  Stream _stream;
  StreamController _streamController;
  Color bg = Color(0xffE6E6E6);

  _search() async {
    if (_controller.text == null || _controller.text.length == 0) {
      _streamController.add(null);
    }
    _streamController.add("loading");
    Response response = await get(_url + _controller.text.trim(),
        headers: {"Authorization": "Token " + _token});
    _streamController.add(jsonDecode(response.body));
  }

  @override
  void initState() {
    _streamController = StreamController();
    _stream = _streamController.stream;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          elevation: 0.0,
          title: RichText(
            text: TextSpan(
              text: 'Shabda',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.w700,
                fontFamily: "OpenSans",
                color: Colors.blue,
                letterSpacing: 1.0,
              ),
              children: <TextSpan>[
                TextSpan(
                    text: 'kosh',
                    style: TextStyle(
                      fontSize: 35,
                      fontFamily: "OpenSans",
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      letterSpacing: 1.0,
                    )),
              ],
            ),
          ),
          backgroundColor: Colors.white,
          expandedHeight: size.height * .20,
          centerTitle: true,
          pinned: true,
          stretch: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: Colors.white,
              height: size.height * .15,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 80, 20, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              color: bg,
                              borderRadius: BorderRadius.circular(30)),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Center(
                              child: GestureDetector(
                                onTap: () => FocusScope.of(context)
                                    .requestFocus(new FocusNode()),
                                child: TextFormField(
                                    textAlign: TextAlign.center,
                                    autofocus: true,
                                    controller: _controller,
                                    decoration: InputDecoration(
                                        hintText: "Search",
                                        fillColor: Colors.white,
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.search),
                                          onPressed: () {
                                            _search();
                                            _controller.clear();
                                          },
                                          color: Colors.black,
                                          iconSize: 35,
                                        ),
                                        border: InputBorder.none)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SliverFillRemaining(
          child: Scaffold(
              backgroundColor: Colors.white,
              body: StreamBuilder(
                  stream: _stream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return Center(
                          child: Text(
                            "Enter something.",
                            style: TextStyle(
                                fontFamily: "OpenSans",
                                fontWeight: FontWeight.w600,
                                fontSize: 30),
                          ));
                    }
                    if (snapshot.data == "loading") {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                        itemCount: snapshot.data["definitions"].length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 10, 10, 20),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: bg,
                                    borderRadius: BorderRadius.circular(20)),
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        snapshot.data["definitions"][index]
                                                    ["image_url"] ==
                                                null
                                            ? CircleAvatar(
                                                radius: 100,
                                                backgroundColor:
                                                    Color(0xffF8F7F9),
                                                backgroundImage: NetworkImage(
                                                    "https://static.thenounproject.com/png/1211233-200.png"),
                                              )
                                            : CircleAvatar(
                                                radius: 100,
                                                backgroundImage: NetworkImage(
                                                    snapshot.data["definitions"]
                                                        [index]["image_url"]),
                                              ),
                                        Spacer(),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 30.0),
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                snapshot.data["word"],
                                                textScaleFactor: 2.5,
                                                style: TextStyle(
                                                    fontFamily: "OpenSans",
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "(" +
                                                    snapshot.data["definitions"]
                                                        [index]["type"] +
                                                    ")",
                                                textScaleFactor: 1.2,
                                                style: TextStyle(
                                                    fontFamily: "OpenSans",
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8, 20, 8, 8),
                                      child: Text(
                                        "Defination",
                                        textAlign: TextAlign.left,
                                        textScaleFactor: 1.5,
                                        style: TextStyle(
                                            fontFamily: "OpenSans",
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 8, 8, 8),
                                      child: Text(
                                        snapshot.data["definitions"][index]
                                            ["definition"],
                                        textScaleFactor: 1.5,
                                        style: TextStyle(
                                            fontFamily: "OpenSans",
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                ),
                              ));
                        });
                  })),
        )
      ],
    );
  }
}
