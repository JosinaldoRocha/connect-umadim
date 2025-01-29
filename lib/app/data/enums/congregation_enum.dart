enum Congregation {
  temploCentral,
  monteSinai,
  lirioDosVales,
  rosaDeSaron,
  valeDeBencaos,
  juda,
  novaJerusalem,
  altoRefugio,
  monteDasOliveiras,
  ebenezer,
  maranata,
  monteMoria;

  factory Congregation.fromString(String type) {
    if (type == 'Templo central') {
      return Congregation.temploCentral;
    } else if (type == 'Monte Sinai') {
      return Congregation.monteSinai;
    } else if (type == 'Lírio dos vales') {
      return Congregation.lirioDosVales;
    } else if (type == 'Rosa de Saron') {
      return Congregation.rosaDeSaron;
    } else if (type == 'Vale de bençãos') {
      return Congregation.valeDeBencaos;
    } else if (type == 'Judá') {
      return Congregation.juda;
    } else if (type == 'Nova Jerusalém') {
      return Congregation.novaJerusalem;
    } else if (type == 'Alto refúgio') {
      return Congregation.altoRefugio;
    } else if (type == 'Monte das Oliveiras') {
      return Congregation.monteDasOliveiras;
    } else if (type == 'Ebenézer') {
      return Congregation.ebenezer;
    } else if (type == 'Maranata') {
      return Congregation.maranata;
    } else {
      return Congregation.monteMoria;
    }
  }

  String get text {
    switch (this) {
      case Congregation.temploCentral:
        return 'Templo central';
      case Congregation.monteSinai:
        return 'Monte Sinai';
      case Congregation.lirioDosVales:
        return 'Lírio dos vales';
      case Congregation.rosaDeSaron:
        return 'Rosa de Saron';
      case Congregation.valeDeBencaos:
        return 'Vale de bençãos';
      case Congregation.juda:
        return 'Judá';
      case Congregation.novaJerusalem:
        return 'Nova Jerusalém';
      case Congregation.altoRefugio:
        return 'Alto refúgio';
      case Congregation.monteDasOliveiras:
        return 'Monte das oliveiras';
      case Congregation.ebenezer:
        return 'Ebenézer';
      case Congregation.maranata:
        return 'Maranata';
      case Congregation.monteMoria:
        return 'Monte Moriá';
    }
  }
}
