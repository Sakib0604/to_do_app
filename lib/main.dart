import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:to_do/db_provider.dart';
import 'package:to_do/toDoModel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

var _colors = [
  Colors.amber.shade300,
  Colors.lightGreen.shade200,
  Colors.lightBlue.shade200,
  Colors.orange.shade300,
  Colors.lime.shade300,
  Colors.purple.shade200
];

var _details = [
  Colors.amber.shade50,
  Colors.lightGreen.shade50,
  Colors.lightBlue.shade50,
  Colors.orange.shade50,
  Colors.lime.shade50,
  Colors.purple.shade50
];


class _MyHomePageState extends State<MyHomePage> {

  TextEditingController titleCon = TextEditingController();
  TextEditingController descriptionCon = TextEditingController();

  int? id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context,scroll) => [
          SliverAppBar(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(15)
              )
            ),
            floating: true,
            pinned: true,
            backgroundColor: Colors.teal.shade300,
          )
        ],
        body: Center(
          child: FutureBuilder<List<ToDo>>(
            future: DatabaseHelper.instance.getList(),
            builder: (BuildContext context,
                AsyncSnapshot<List<ToDo>> snapshot){
              if(!snapshot.hasData){
                return const Center(child: Text('Loading...'),);
              }
              return snapshot.data!.isEmpty ?
              const Center(child: Text('Nothing to do'),)
                  : StaggeredGridView.countBuilder(
                  itemCount: snapshot.data!.length,
                  padding: EdgeInsets.all(8),
                  staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
                  crossAxisCount: 4,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
                  itemBuilder: (BuildContext context, int index){
                    return Card(
                      color: _colors[index % _colors.length],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          constraints: BoxConstraints(
                              minHeight: getMin(index)
                          ),
                          child: InkWell(
                            onTap: (){
                              showDialog(context: context, builder: (BuildContext context){
                                return Dialog(
                                    backgroundColor: _details[index % _details.length],
                                    insetPadding: EdgeInsets.all(10),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Container(
                                        height: MediaQuery.of(context).size.height/1.40,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Center(
                                              child: Icon(Icons.description,size: 90,color: Colors.black26,),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Text(snapshot.data![index].title,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                letterSpacing: 1
                                            ),),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(snapshot.data![index].description,
                                              textAlign: TextAlign.justify,
                                              textDirection: TextDirection.ltr,
                                              style: const TextStyle(
                                                  fontSize: 15
                                              ),),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context).size.width,
                                              child: Text(snapshot.data![index].date,
                                                textAlign: TextAlign.end,
                                                style: const TextStyle(
                                                    fontSize: 17
                                                ),),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                );
                              });
                            },
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(snapshot.data![index].title,
                                    style: const TextStyle(
                                    fontSize: 18,
                                    letterSpacing: 1.5
                                  ),),
                                ),
                                Positioned(
                                    top: 20,
                                    child: SizedBox(
                                      width: 120,
                                      child: Text(snapshot.data![index].description,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.justify,
                                        textDirection: TextDirection.ltr,
                                        style: const TextStyle(
                                        fontSize: 15
                                      ),),
                                    )),
                                Positioned(
                                    bottom: 0,
                                    child: Text(snapshot.data![index].date)),
                                Positioned(
                                    bottom: 0,
                                    right: 30,
                                    child: InkWell(child: const Icon(Icons.edit),onTap: (){
                                      if(id == null){
                                        id = snapshot.data![index].id;
                                        titleCon.text = snapshot.data![index].title;
                                        descriptionCon.text = snapshot.data![index].description;
                                      }
                                      showDialog(barrierDismissible: false, context: context, builder: (BuildContext context){
                                        return Dialog(
                                            insetPadding: EdgeInsets.all(10),
                                            child: Padding(
                                              padding: const EdgeInsets.all(15.0),
                                              child: Container(
                                                height: 500,
                                                child: Column(
                                                  children: [
                                                    const Center(
                                                      child: Icon(Icons.update,size: 90,color: Colors.teal,),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    TextField(
                                                      controller: titleCon,
                                                      keyboardType: TextInputType.text,
                                                      decoration: const InputDecoration(
                                                          hintText: 'Title',
                                                          border: OutlineInputBorder()
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    TextField(
                                                      controller: descriptionCon,
                                                      keyboardType: TextInputType.multiline,
                                                      maxLines: 10,
                                                      decoration: const InputDecoration(
                                                          hintText: 'Description',
                                                          border: OutlineInputBorder()
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),

                                                    SizedBox(
                                                        width: MediaQuery. of(context). size. width,
                                                        child: ElevatedButton(
                                                          style: ButtonStyle(
                                                            backgroundColor: MaterialStateProperty.all(Colors.teal)
                                                          ),
                                                            onPressed: () async{
                                                          DateTime dateToday = DateTime.now();
                                                          String date = dateToday.toString().substring(0,10);

                                                          await DatabaseHelper.instance.update(ToDo(
                                                              id: id,
                                                              title: titleCon.text,
                                                              description: descriptionCon.text,
                                                              date: date));

                                                          Navigator.of(context).pop();

                                                          setState(() {
                                                            id = null;
                                                            titleCon.clear();
                                                            descriptionCon.clear();
                                                          });

                                                        }, child: const Text('Update')))
                                                  ],
                                                ),
                                              ),
                                            )
                                        );
                                      });
                                    },)),
                                Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: InkWell(child: const Icon(Icons.delete),onTap: (){
                                      setState(() {
                                        DatabaseHelper.instance.remove(snapshot.data![index].id!);
                                      });
                                    },))
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: (){
          showDialog(barrierDismissible: false, context: context, builder: (BuildContext context){
            return Dialog(
                insetPadding: EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  height: 480,
                  child: Column(
                    children: [
                      const Center(
                        child: Icon(Icons.save,size: 90,color: Colors.teal,),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: titleCon,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            hintText: 'Title',
                            border: OutlineInputBorder()
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: descriptionCon,
                        keyboardType: TextInputType.multiline,
                        maxLines: 10,
                        decoration: const InputDecoration(
                            hintText: 'Description',
                            border: OutlineInputBorder()
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                          width: MediaQuery. of(context). size. width,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.teal)
                            ),
                              onPressed: () async{
                            DateTime dateToday =new DateTime.now();
                            String date = dateToday.toString().substring(0,10);

                            await DatabaseHelper.instance.add(ToDo(
                                title: titleCon.text,
                                description: descriptionCon.text,
                                date: date));

                            Navigator.of(context).pop();

                            setState(() {
                              titleCon.clear();
                              descriptionCon.clear();
                            });
                          }, child: const Text('Save')))
                    ],
                  ),
                ),
              )
            );
          });
        },
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  double getMin(int index) {
    switch(index % 4){
      case 0:
        return 100;
      case 1:
        return 120;
      case 2:
        return 140;
      case 3:
        return 160;
      case 4:
        return 180;
      default:
        return 100;
    }
  }
}
