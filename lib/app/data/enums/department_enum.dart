import 'package:connect_umadim_app/app/data/enums/congregation_enum.dart';

enum Department {
  juvTC,
  juvCMS,
  juvCLV,
  juvCRS,
  juvCVB,
  juvCJ,
  juvCNJ,
  juvCAR,
  juvCMO,
  juvCE,
  juvCM,
  juvCMM,
  umadim;

  factory Department.fromString(String type) {
    if (type == 'Juv. Templo central') {
      return Department.juvTC;
    } else if (type == 'Juv. Monte Sinai') {
      return Department.juvCMS;
    } else if (type == 'Juv. Lírio dos vales') {
      return Department.juvCLV;
    } else if (type == 'Juv. Rosa de Saron') {
      return Department.juvCRS;
    } else if (type == 'Juv. Vale de bençãos') {
      return Department.juvCVB;
    } else if (type == 'Juv. Judá') {
      return Department.juvCJ;
    } else if (type == 'Juv. Nova Jerusalém') {
      return Department.juvCNJ;
    } else if (type == 'Juv. Alto refúgio') {
      return Department.juvCAR;
    } else if (type == 'Juv. Monte das Oliveiras') {
      return Department.juvCMO;
    } else if (type == 'Juv. Ebenézer') {
      return Department.juvCE;
    } else if (type == 'Juv. Maranata') {
      return Department.juvCM;
    } else if (type == 'Juv. Monte Moriá') {
      return Department.juvCMM;
    } else {
      return Department.umadim;
    }
  }

  factory Department.fromByCongregation(Congregation type) {
    if (type == Congregation.temploCentral) {
      return Department.juvTC;
    } else if (type == Congregation.monteSinai) {
      return Department.juvCMS;
    } else if (type == Congregation.lirioDosVales) {
      return Department.juvCLV;
    } else if (type == Congregation.rosaDeSaron) {
      return Department.juvCRS;
    } else if (type == Congregation.valeDeBencaos) {
      return Department.juvCVB;
    } else if (type == Congregation.juda) {
      return Department.juvCJ;
    } else if (type == Congregation.novaJerusalem) {
      return Department.juvCNJ;
    } else if (type == Congregation.altoRefugio) {
      return Department.juvCAR;
    } else if (type == Congregation.monteDasOliveiras) {
      return Department.juvCMO;
    } else if (type == Congregation.ebenezer) {
      return Department.juvCE;
    } else if (type == Congregation.maranata) {
      return Department.juvCM;
    } else if (type == Congregation.monteMoria) {
      return Department.juvCMM;
    } else {
      return Department.umadim;
    }
  }

  String get text {
    switch (this) {
      case Department.juvTC:
        return 'Juv. Templo central';
      case Department.juvCMS:
        return 'Juv. Monte Sinai';
      case Department.juvCLV:
        return 'Juv. Lírio dos vales';
      case Department.juvCRS:
        return 'Juv. Rosa de Saron';
      case Department.juvCVB:
        return 'Juv. Vale de bençãos';
      case Department.juvCJ:
        return 'Juv. Judá';
      case Department.juvCNJ:
        return 'Juv. Nova Jerusalém';
      case Department.juvCAR:
        return 'Juv. Alto refúgio';
      case Department.juvCMO:
        return 'Juv. Monte das oliveiras';
      case Department.juvCE:
        return 'Juv. Ebenézer';
      case Department.juvCM:
        return 'Juv. Maranata';
      case Department.juvCMM:
        return 'Juv. Monte Moriá';
      case Department.umadim:
        return 'Umadim';
    }
  }
}
