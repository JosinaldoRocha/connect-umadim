import 'package:connect_umadim_app/app/data/enums/department_enum.dart';
import 'package:connect_umadim_app/app/data/enums/funciton_type_enum.dart';

class FunctionModel {
  FunctionType title;
  Department department;

  FunctionModel({
    required this.title,
    required this.department,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title.text,
      'department': department.text,
    };
  }

  factory FunctionModel.fromMap(Map<String, dynamic> map) {
    return FunctionModel(
      title: FunctionType.fromString(map['title'] as String),
      department: Department.fromString(map['department'] as String),
    );
  }
}
