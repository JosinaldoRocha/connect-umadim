import 'package:brasil_fields/brasil_fields.dart';
import 'package:intl/intl.dart';

class InputValidators {
  static String? phone(String? text) {
    if (text!.length < 11) {
      return 'Informe um número válido';
    }
    return null;
  }

  static String? cpf(String? text) {
    if (!CPFValidator.isValid(text)) {
      return 'Informe um CPF válido';
    }
    return null;
  }

  // static String? cnpj(String? text) {
  //   if (!CNPJValidator.isValid(text)) {
  //     return 'CNPJ inválido';
  //   }
  //   return null;
  // }

  static String? email(String? text) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(text ?? '');
    if (!emailValid) {
      return "Email inválido";
    }
    return null;
  }

  static String parseDate(String text) {
    final date = DateFormat('dd/MM/yyyy').parse(text);
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String? date(String? text, {int howManyYears = 0}) {
    try {
      final date = DateFormat.yMd().parse(text!);

      if (date.isAfter(
          DateTime.now().subtract(Duration(days: 365 * howManyYears)))) {
        return 'Apenas maiores de $howManyYears anos';
      }
      return null;
    } catch (e) {
      return 'Data Inválida';
    }
  }

  static String? fullName(String? name) {
    if (name!.isEmpty) {
      return 'Por favor, insira um nome.';
    }
    List<String> nameParts = name.split(' ');
    if (nameParts.length < 2) {
      return 'Por favor, insira um nome completo.';
    }

    return null;
  }
}
