import 'dart:io';

void main() {

  List<Tarefa> listaDeTarefas = [];

  final arquivo = File('tarefas.txt');

  if(arquivo.existsSync()) {
    List<String> linhas = arquivo.readAsLinesSync();
    for(var linha in linhas) {
      if(linha.trim().isNotEmpty) {
        listaDeTarefas.add(Tarefa.fromArquivo(linha));
      }
    }
  }

  


  print('1. Adicionar tarefa');
  print('2. Remover tarefa');
  print('3. Marcar tarefa como concluída');
  print('4. Listar tarefas (todas/pendentes/concluídas');
  print('5. Sair');

  String? leitura = stdin.readLineSync();

  switch (leitura) {
    case '1': 

    print('Digite a descrição da tarefa');

    String? descricaoDigitada = stdin.readLineSync();

    if(descricaoDigitada != null && descricaoDigitada.isNotEmpty) {
          Tarefa novaTarefa = Tarefa(descricaoDigitada);
          listaDeTarefas.add(novaTarefa);
          salvarTarefas(listaDeTarefas, arquivo);
    }
      break;

    case '2' :

    if(listaDeTarefas.isEmpty) {
      print('Nenhuma tarefa para remover');
    } else {
      print('Tarefas');
      for (int i = 0;i < listaDeTarefas.length; i++) {
        print('$i - ${listaDeTarefas[i].descricao}');
      }
      print('Digite o índice da tarefa que deseja remover:');
      String? indiceSrt = stdin.readLineSync();
      int? indice = int.tryParse(indiceSrt ?? '');
      if(indice != null && indice >= 0 && indice < listaDeTarefas.length) {
        listaDeTarefas.removeAt(indice);
        salvarTarefas(listaDeTarefas, arquivo);
        print('Tarefa removida com sucesso!');
      } else {
        print('Índice inválido');
      }
    }
      break;

      case '3' :

    if(listaDeTarefas.isEmpty) {
      print('Nenhuma tarefa para marcar como concluída.');
    } else {
      for(int i = 0; i < listaDeTarefas.length; i++) {
        print('$i - ${listaDeTarefas[i].descricao}');
      }
      print('Digite o índice da tarefa para marcar como concluído');
      String? indiceStr = stdin.readLineSync();
      int? indice = int.tryParse(indiceStr ?? '');
      if(indice != null && indice >= 0 && indice < listaDeTarefas.length && !listaDeTarefas[indice].concluida) {
        listaDeTarefas[indice].concluida = true;
        salvarTarefas(listaDeTarefas, arquivo);
                  print('Tarefa marcada concluída');
      } else {
        print('Índice inválido ou tarefa concluída');
      }
        }
        break;

      case '4' :

    if(listaDeTarefas.isEmpty) {
      print('Nenhuma tarefa cadastrada');
    } else {
      print('Escolha o filtro');
      print('1. Todas');
      print('2. Pendentes');
      print('3. Concluídas');

      String? filtro = stdin.readLineSync();

      if(filtro == '1') {
        for(int i = 0; i < listaDeTarefas.length; i++) {
          String status = listaDeTarefas[i].concluida ? 'Concluída' : 'Pendente';
          print('$i - ${listaDeTarefas[i].descricao} [$status]');
           }
        } else if (filtro == '2') {
          for(int i = 0; i < listaDeTarefas.length; i++) {
            if(!listaDeTarefas[i].concluida) {
              print('$i - ${listaDeTarefas[i].descricao} [Pendente]');
            }
          }
        } else if (filtro == '3'){
          for(int i = 0; i < listaDeTarefas.length;i++) {
            if(listaDeTarefas[i].concluida) {
              print('$i - ${listaDeTarefas[i].descricao} [Concluída]');
            }
          }
        } else {
          print('Filtro inválido');
        }
      }
         break;
         case '5' :
            print('Saindo do programa...');
              return;

              default:
              print('Tente novamente');
    }      
  
       }
      

class Tarefa {
  String descricao;
  bool concluida;


  Tarefa(this.descricao, {this.concluida = false});

  String toArquivo() {
    return '$descricao;${concluida.toString()}';
  }

  static Tarefa fromArquivo(String linha) {
    var partes = linha.split(';');
    return Tarefa (
      partes[0],
      concluida: partes.length > 1 ? partes [1] == 'true' : false,
    );
  }
}


void salvarTarefas(List<Tarefa> lista, File arquivo) {
  final linhas = lista.map((t) => t.toArquivo()).toList();
  arquivo.writeAsStringSync(linhas.join('\n'));
}

