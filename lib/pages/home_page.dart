import 'package:flutter/material.dart';
import 'package:lista_tarefa/repositories/repositorio.dart';

import '../model/tarefa.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Tarefa> tarefas=[];
  TextEditingController controllerTarefa = new TextEditingController();

  @override
  void initState() {
    Repositorio.recuperarTudo().then((dados){
      setState(() {
        tarefas=dados;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de tarefas"),
        centerTitle: true,
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(child: TextField(
                  controller: controllerTarefa,
                  decoration: InputDecoration(label: Text("Nova tarefa",),
                  )),
                IconButton(onPressed: () {
                  if (controllerTarefa.text.isEmpty){
                    setState(() {
                      Tarefa tarefa = new Tarefa(nome: controllerTarefa.text, realizado: false);
                      tarefas.add(tarefa);
                    });
                  Repositorio.salvarTudo(tarefas);
                  controllerTarefa.clear();
                }, icon: Icon(Icons.add_box,))
                }
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: _construtorLista,
              itemCount: tarefas.length,),
          ),
        ],
      ),
    );
  }

  Widget _construtorLista(BuildContext context, int index) {
    return Dismissible(
      key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
      child: CheckboxListTile(
        title: Text(tarefas[index].nome),
        value: tarefas[index].realizado,
        ? Text(

      )
        onChanged: (checked) {
          setState(() {
            tarefas[index].realizado = checked!;
          });
          Repositorio.salvarTudo(tarefas);
        },
        secondary: tarefas[index].realizado ? Icon(Icons.verified, color: Colors.green,) : Icon()
        Icon(Icons.verified):
        Icon(Icons.error),
        ),
      onDismissed: (direction){
        tarefas.remove(tarefas[index]);
        Repositorio.salvarTudo(tarefas);
      },
      background: Container(
        child: Icon(Icons.delete
        size: 50,color: Colors.red,
        alignment: Alignment.centerRight,),
        
      ),
    );
  }
}


