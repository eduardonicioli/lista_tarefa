import 'package:flutter/material.dart';
import 'package:lista_tarefa/repositories/repositorio.dart';

import '../model/tarefa.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Tarefa> tarefas = [];
  TextEditingController controllerTarefa = new TextEditingController();

  @override
  void initState() {
    Repositorio.recuperarTudo().then((dados) {
      setState(() {
        tarefas = dados;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Lista de tarefas",
          style: TextStyle(
            fontSize: 24, // Tamanho da fonte
            fontWeight: FontWeight.bold, // Espessura da fonte
            color: Colors.white, // Cor da fonte
            fontFamily: 'Roboto', // Fonte personalizada (certifique-se de que a fonte esteja no projeto)
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                      controller: controllerTarefa,
                      decoration: InputDecoration(
                          hintText: "Digite sua tarefa aqui"),
                    )),
                IconButton(
                    onPressed: () {
                      if (controllerTarefa.text.isNotEmpty) {
                        setState(() {
                          Tarefa tarefa = new Tarefa(
                              nome: controllerTarefa.text, realizado: false);
                          tarefas.add(tarefa);
                        });
                        Repositorio.salvarTudo(tarefas);
                        controllerTarefa.clear();
                      }
                      else{
                        SnackBar snack = SnackBar(
                          content: Text("Favor inserir uma tarefa!"),
                          duration: Duration(seconds: 5),
                          backgroundColor: Colors.red,);
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(snack);
                      }
                    },
                    icon: Icon(
                      Icons.add_circle_rounded,
                      size: 30,
                    ))
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: _construtorLista,
              itemCount: tarefas.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _construtorLista(BuildContext context, int index) {
    return Dismissible(
      key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
      child: CheckboxListTile(
        title: tarefas[index].realizado
            ? Text(
          tarefas[index].nome,
          style: TextStyle(decoration: TextDecoration.lineThrough),
        )
            : Text(
          tarefas[index].nome,
        ),
        value: tarefas[index].realizado,
        onChanged: (checked) {
          setState(() {
            tarefas[index].realizado = checked!;
          });
          Repositorio.salvarTudo(tarefas);
        },
        secondary: tarefas[index].realizado
            ? Icon(
          Icons.verified,
          color: Colors.green,
        )
            : Icon(
          Icons.verified_outlined,
          color: Colors.red,
        ),
      ),
      onDismissed: (direction) {
        Tarefa tarefaRemovida=tarefas[index];
        int indiceTarefaRemovida=index;
        tarefas.remove(tarefas[index]);
        Repositorio.salvarTudo(tarefas);
        SnackBar snack = SnackBar(
          backgroundColor: Colors.green,
          content: Text("Tarefa ${tarefaRemovida.nome} removida"),
          action: SnackBarAction(label: "Desfazer", textColor: Colors.white,
            onPressed: () {
              setState(() {
                tarefas.insert(indiceTarefaRemovida, tarefaRemovida);
              });
              Repositorio.salvarTudo(tarefas);
            },
          ),
        );
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(snack);
      },
      background: Container(
        child: Align(
          child: Icon(
            Icons.delete,
            size: 35,
            color: Colors.white,
          ),
          alignment: Alignment.centerRight,
        ),
        decoration: BoxDecoration(color: Colors.red),
      ),
      direction: DismissDirection.endToStart,
    );
  }
}