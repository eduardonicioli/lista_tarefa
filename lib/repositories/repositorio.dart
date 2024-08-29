import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../model/tarefa.dart';

class Repositorio{

  static Future<List<Tarefa>> recuperarTudo() async {
    File arquivo = await _obterArquivo();
    List<dynamic> tarefasTemp = jsonDecode(await arquivo.readAsString());
    List<Tarefa> tarefas = [];
    for(Map<String, dynamic> tarefa in tarefasTemp){
      tarefas.add(new Tarefa(nome: tarefa["nome"], realizado: tarefa["realizado"]));
    }
    return tarefas;
  }

  static Future<void> salvarTudo(List<Tarefa> tarefas) async {
    File arquivo = await _obterArquivo();
    String tarefasGravar = jsonEncode(tarefas);
    await arquivo.writeAsString(tarefasGravar);
  }

  static Future<File> _obterArquivo() async {
    final Directory? downloadsDir = await getDownloadsDirectory();
    return File("${downloadsDir?.path}/tarefas.json");
  }
}