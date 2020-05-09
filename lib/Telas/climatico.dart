import 'package:climatico/Telas/tela_cidade.dart';
import 'package:climatico/Transacoes/pega_clima.dart';
import 'package:flutter/material.dart';

import 'package:climatico/Util/util.dart' as util;

class Climatico extends StatefulWidget {
  @override
  _ClimaticoState createState() => _ClimaticoState();
}

class _ClimaticoState extends State<Climatico> {
  String _cidadeInserida;

  Future _abrirNovaTela(BuildContext context) async {
    Map resultado = await Navigator.of(context)
        .push(MaterialPageRoute<Map>(builder: (BuildContext context) {
      return MudarCidade();
    }));
    if (resultado != null && resultado.containsKey('cidade')) {
      _cidadeInserida = resultado['cidade'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Clima"),
        centerTitle: true,
        backgroundColor: Colors.red,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => _abrirNovaTela(context),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset(
              "assets/umbrella.png",
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.all(13.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  "${_cidadeInserida == null ? util.minhaCidade : _cidadeInserida}",
                  style: styleCidade(),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Image.asset(
              "assets/light_rain.png",
            ),
          ),
          atualizaTempWidget(_cidadeInserida),
        ],
      ),
    );
  }

  Widget atualizaTempWidget(String cidade) {
    return FutureBuilder(
        future:
            pegaCLima(util.appId, cidade == null ? util.minhaCidade : cidade),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            Map conteudo = snapshot.data;
            return Container(
              margin: const EdgeInsets.fromLTRB(30.0, 250.0, 0.0, 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ListTile(
                    title: Text(conteudo['main']['temp'].toString() + "C°", style: styleTemp(),),
                    subtitle: ListTile(
                      title: Text(
                          "Humidade: ${conteudo['main']['humidity'].toString()}\n"
                          "Min: ${conteudo['main']['temp_min'].toString()} C°\n"
                          "Max: ${conteudo['main']['temp_max'].toString()} C°",
                          style: extraTemp()),
                    ),
                  )
                ],
              ),
            );
          } else {
            return Container(
              child: Text("Falhou!"),
            );
          }
        });
  }

  TextStyle extraTemp() {
    return TextStyle(
      color: Colors.white70,
      fontStyle: FontStyle.normal,
      fontSize: 20.0,
    );
  }

  TextStyle styleCidade() {
    return TextStyle(
      color: Colors.white,
      fontStyle: FontStyle.italic,
      fontSize: 30.0,
    );
  }

    TextStyle styleTemp() {
    return TextStyle(
      color: Colors.white,
      fontStyle: FontStyle.normal,
      fontSize: 40.0,
      fontWeight: FontWeight.w800
    );
  }
}
