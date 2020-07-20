import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yonaki/components/edit_story_sheet.dart';

class EditStories extends StatefulWidget {
  final String strStories;
  final Function disposed;

  EditStories({
    @required this.strStories,
    @required this.disposed,
  });

  @override
  _EditStoriesState createState() => _EditStoriesState();
}

class _EditStoriesState extends State<EditStories> {
  List<dynamic> stories;

  @override
  void initState() {
    super.initState();
    stories = json.decode(widget.strStories);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _buildStoriesList(context),
    );
  }

  List<Widget> _buildStoriesList(BuildContext context) {
    List<Widget> tiles = [];

    stories.asMap().forEach((index, story) {
      tiles.add(ListTile(
        title: Text(story),
        trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context)
                        .viewInsets
                        .bottom),
                child: EditStorySheet(
                  story: story,
                  onChanged: (String newValue) {
                    setState(() {
                      stories[index] = newValue;
                    });
                  },
                  dispose: () {
                    widget.disposed(stories.toString());
                  },
                ),
              ),
            ),
          ),
        ),
      ));
    });

    return ListTile.divideTiles(context: context, tiles: tiles).toList();
  }
}
