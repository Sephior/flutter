import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/task.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:http/http.dart' as http;


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  // 기본적인 정보를 
  Widget build(BuildContext context) {
    return MaterialApp(
      //제목
      title: 'To Do List',
      theme: ThemeData(
        //기본 색상 설정
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
        textTheme: const TextTheme(
          //textstyle 설정 가능
          bodyMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
          labelMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
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

  // 변수 생성
  bool isModifying = false;
  int modifyingIndex = 0;
  double percent = 0.0;
  
  addTaskToServer(Task task) async {
    // Post 방식
    final response = await http.post(
      Uri.http('127.0.0.1:8000','/posting/addTask'),
      headers: {'Content-type':'application/json'},
      body: jsonEncode(task));
    print("response is = ${response.body}");
    getTasktoServer();
  }

  getTasktoServer() async {
    //get 방식
    final response = await http.get(Uri.http('127.0.0.1:8000','/posting'));
    String responseBody = utf8.decode(response.bodyBytes);
    print(responseBody);
    List<Task> list = json
      .decode(responseBody)
      .map<Task>((json) => Task.fromJson(json))
      .toList();
    print(list.length);
    setState(() {
      tasks = list;
    });
  }

  // 퍼센트 재설정 함수
  void updatePercent(){
    if (tasks.isEmpty){
      percent = 0.0;
    } else {
      var completeTaskCnt = 0;
      for (var i = 0; i<tasks.length; i++){
        if (tasks[i].isComplete){
          completeTaskCnt+=1;
        }
      }
    percent = completeTaskCnt/tasks.length;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTasktoServer();
  }

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
      body: SingleChildScrollView(
        child: Center(
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
                          // isModifying 이 true이면 ? 이후의 코드가, false면 : 이후의 코드가 실행됨
                          isModifying
                          ? setState(() {
                            tasks[modifyingIndex].work = _textController.text;
                            tasks[modifyingIndex].isComplete = false;
                            _textController.clear();
                            modifyingIndex = 0;
                            isModifying = false;
                          })
                          : setState((){
                            var task = Task(id:0, work:_textController.text, isComplete: false);
                            addTaskToServer(task);
                            _textController.clear();
                          });
                        }
                      },
                      //버튼 내부 데이터 설정
                      child: isModifying
                      ? const Text("revise")
                      : const Text("Add"),
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
                    percent: percent,
                  )
                ]),
              ),
              
              // 반복문
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
                      onPressed: () {
                        setState(() {
                        tasks[i].isComplete = !tasks[i].isComplete;
                        updatePercent();
                        });
                      },
                      child: Row(
                        children: [
                          tasks[i].isComplete
                          // ?면 True일 때 체크된 모양
                          ?  const Icon(Icons.check_box_rounded)
                          // : 이면 False일 때 체크된 모양
                          :  const Icon(Icons.check_box_outline_blank_rounded),
                          Text(tasks[i].work, style: Theme.of(context).textTheme.labelMedium)
                        ],
                      ),
                    ),
                  ),
                  TextButton(onPressed: isModifying
                    ? null
                    : (){
                      setState(() {
                        isModifying = true;
                        _textController.text = tasks[i].work;
                        modifyingIndex = i;
                        updatePercent();
                      });
                  }, child: const Text("revise"),),
                  TextButton(onPressed: (){
                    setState(() {
                      tasks.remove(tasks[i]);
                      updatePercent();
                    });
                  }, child: const Text("remove"),),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}