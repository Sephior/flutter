import 'package:flutter/material.dart';
import 'package:flutter_application_1/task.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //제목
      title: 'To Do List',
      theme: ThemeData(
        //제목창 기본 색상
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //제목
      home: const MyHomePage(title: 'To Do List'),
    );
  }
}

//stateful widget
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  //변수 = text입력창
  final _textController = TextEditingController();
  
  //오늘의 날짜 불러오기
  String getToday(){
    DateTime now = DateTime.now();
    String strToday;
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    strToday = formatter.format(now);
    return strToday;
  }
  
  //옆에 만든 task.dart에서 import해서 리스트 생성
  List<Task> tasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //제목을 센터에
        centerTitle: true,
        //색상을 stateful widget의 테마(context, 내용)으로
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        //자식 생성
        child: Column(
          //메인 축 정렬
          mainAxisAlignment: MainAxisAlignment.start,
          //자식의 자식 생성
          children: [
            //텍스트
            Text(getToday()),
            //padding, 감싸기
            Padding(
              padding: const EdgeInsets.all(8.0),
              //한 열에 여러 개의 자식을 생성
              child: Row(
                children:[
                  //flexible 세팅
                  Flexible(
                    //텍스트 필드(텍스트 입력창 생성)
                    child: TextField(
                      controller: _textController,
                      ),
                    ),
                  //버튼 생성
                  ElevatedButton(
                    onPressed: () {
                      //버튼의 효과 설정
                      if (_textController.text != '') {
                        setState(() {
                          var task = Task(_textController.text);
                          tasks.add(task);
                          _textController.clear();
                        });
                      }
                    },
                    //버튼 내부 데이터 설정
                    child: const Text("Add"
                      ),
                    )
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                LinearPercentIndicator(
                  //현재 기기의 설정 불러오기 context
                  width: MediaQuery.of(context).size.width - 50,
                  lineHeight: 14,
                  percent: 0.5,
                )
              ]),
            ),

            for (var i = 0; i < tasks.length; i++)

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  //텍스트 버튼 생성
                  Flexible(child: TextButton(
                    style: TextButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.zero)
                      )
                    ),
                    onPressed: () {},
                    child: Row(
                      children: [
                        const Icon(Icons.check_box_outline_blank_rounded),
                        Text(tasks[i].work)
                      ],
                    ),
                  ),
                ),
                TextButton(onPressed: (){
                  setState(() {
                    if (_textController.text != '') {
                      var task = Task(_textController.text);
                      tasks[i] = task;
                      _textController.clear();
                    }
                  });
                }, child: const Text("revise"),),

                TextButton(onPressed: (){
                  setState(() {
                    tasks.remove(tasks[i]);
                  });
                }, child: const Text("remove"),),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}