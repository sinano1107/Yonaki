import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yonaki/components/edit_story_sheet.dart';

class EditStories extends StatefulWidget {
  final String strStories;
  final Function edit;

  EditStories({
    @required this.strStories,
    @required this.edit,
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
      children: _buildStoriesList(context) + [
        MaterialButton(
          child: Icon(Icons.add),
          onPressed: () {
            setState(() {
              stories.add("[新規ストーリー]");
            });
          },
        ),
      ],
    );
  }

  List<Widget> _buildStoriesList(BuildContext context) {
    List<Widget> tiles = [];

    stories.asMap().forEach((index, story) {
      tiles.add(Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) {
          setState(() {
            stories.removeAt(index);
          });
          widget.edit(stories);
        },
        child: ListTile(
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
                    dispose: () => widget.edit(stories),
                  ),
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
