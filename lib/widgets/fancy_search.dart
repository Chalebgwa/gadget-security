import 'package:flutter/material.dart';

class FancySearch extends StatefulWidget {
  final onPressed;
  final TextEditingController controller;

  const FancySearch({
    Key key,
    this.onPressed,
    this.controller,
  }) : super(key: key);

  @override
  _FancySearchState createState() => _FancySearchState();
}

class _FancySearchState extends State<FancySearch>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  TextEditingController _editingController;
  FocusNode _focusNode = new FocusNode();

  var focusIcon = Icons.search;

  @override
  void initState() {
    super.initState();
    _editingController = widget.controller;
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    _controller.addListener(() {
      setState(() {});
    });
    _focusNode.addListener(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onSearchPress() {
    if (_controller.isCompleted) {
      _controller.reverse();
      _focusNode.unfocus();
      setState(() {
        focusIcon = Icons.search;
        _editingController.clear();
      });
    } else {
      _controller.forward();
      FocusScope.of(context).requestFocus(_focusNode);
      setState(() {
        focusIcon = Icons.close;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        buildTextField(),
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: FloatingActionButton(
            onPressed: onSearchPress,
            child: Icon(
              focusIcon,
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
          ),
        )
      ],
    );
  }

  Widget buildTextField() {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      width: _controller.value * 270,
      child: TextField(
        scrollPhysics: BouncingScrollPhysics(),
        //onEditingComplete: onSearchPress,
        keyboardAppearance: Brightness.dark,
        textInputAction: TextInputAction.search,
        controller: _editingController,
        focusNode: _focusNode,
        onSubmitted: widget.onPressed,
        decoration: InputDecoration(
          hintText: "Device SSN",
          fillColor: Colors.white.withOpacity(.6),
          filled: true,
          focusColor: Colors.red,
          prefixIcon: Icon(Icons.search),
          hintStyle: TextStyle(
            color: Colors.black.withOpacity(
              0.3,
            ),
          ),
        ),
      ),
    );
  }
}
