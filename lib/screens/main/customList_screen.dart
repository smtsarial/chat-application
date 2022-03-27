import 'package:flutter/material.dart';

class CustomListView extends StatefulWidget {
  const CustomListView({Key? key, required this.appbarName, required this.list})
      : super(key: key);
  final List list;
  final String appbarName;
  @override
  State<CustomListView> createState() => _CustomListViewState();
}

class _CustomListViewState extends State<CustomListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            child: Column(
          children: [
            Expanded(
                child: widget.list.isNotEmpty
                    ? ListView.builder(
                        itemCount: widget.list.length,
                        itemBuilder: (context, position) {
                          List item = widget.list[position];
                          return Card(
                            margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
                            child: Column(
                              children: [
                                ListTile(
                                    onTap: () => {},
                                    leading: Container(
                                      height: double.infinity,
                                      child: Icon(Icons.car_repair_sharp),
                                    ),
                                    title: Text(
                                      item.toString(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    trailing: Wrap(
                                      spacing: 12,
                                      children: [
                                        Container(
                                          child: Column(
                                            children: [
                                              Text("item.year"),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text("Araç Bulunamadı !",
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold)),
                      ))
          ],
        )),
      ),
    );
  }
}
