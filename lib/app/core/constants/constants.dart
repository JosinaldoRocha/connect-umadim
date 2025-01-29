import 'package:connect_umadim_app/app/data/enums/congregation_enum.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

import '../../data/enums/funciton_type_enum.dart';

final functionTypeList = [
  DropDownValueModel(
    name: FunctionType.leader.text,
    value: FunctionType.leader,
  ),
  DropDownValueModel(
    name: FunctionType.regent.text,
    value: FunctionType.regent,
  ),
  DropDownValueModel(
    name: FunctionType.media.text,
    value: FunctionType.media,
  ),
  DropDownValueModel(
    name: FunctionType.receptionist.text,
    value: FunctionType.receptionist,
  ),
  DropDownValueModel(
    name: FunctionType.secretary.text,
    value: FunctionType.secretary,
  ),
  DropDownValueModel(
    name: FunctionType.concierge.text,
    value: FunctionType.concierge,
  ),
  DropDownValueModel(
    name: FunctionType.evangelism.text,
    value: FunctionType.evangelism,
  ),
  DropDownValueModel(
    name: FunctionType.events.text,
    value: FunctionType.events,
  ),
  DropDownValueModel(
    name: FunctionType.member.text,
    value: FunctionType.member,
  ),
];

final congregationsList = [
  DropDownValueModel(
    name: Congregation.temploCentral.text,
    value: Congregation.temploCentral,
  ),
  DropDownValueModel(
    name: Congregation.monteSinai.text,
    value: Congregation.monteSinai,
  ),
  DropDownValueModel(
    name: Congregation.lirioDosVales.text,
    value: Congregation.lirioDosVales,
  ),
  DropDownValueModel(
    name: Congregation.rosaDeSaron.text,
    value: Congregation.rosaDeSaron,
  ),
  DropDownValueModel(
    name: Congregation.valeDeBencaos.text,
    value: Congregation.valeDeBencaos,
  ),
  DropDownValueModel(
    name: Congregation.juda.text,
    value: Congregation.juda,
  ),
  DropDownValueModel(
    name: Congregation.novaJerusalem.text,
    value: Congregation.novaJerusalem,
  ),
  DropDownValueModel(
    name: Congregation.altoRefugio.text,
    value: Congregation.altoRefugio,
  ),
  DropDownValueModel(
    name: Congregation.monteDasOliveiras.text,
    value: Congregation.monteDasOliveiras,
  ),
  DropDownValueModel(
    name: Congregation.ebenezer.text,
    value: Congregation.ebenezer,
  ),
  DropDownValueModel(
    name: Congregation.maranata.text,
    value: Congregation.maranata,
  ),
  DropDownValueModel(
    name: Congregation.monteMoria.text,
    value: Congregation.monteMoria,
  ),
];

final genderList = [
  DropDownValueModel(
    name: 'Masculino',
    value: 'masculino',
  ),
  DropDownValueModel(
    name: 'Feminino',
    value: 'feminino',
  ),
];
