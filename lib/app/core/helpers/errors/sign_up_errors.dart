class SignUpError {
  final String message;

  SignUpError._(this.message);

  // Erros específicos
  static final emailAlreadyExists =
      SignUpError._("Este e-mail já está em uso.");
  static final noPermission =
      SignUpError._("Você não tem permissão para se cadastrar.");
  static final unknown =
      SignUpError._("Ocorreu um erro desconhecido. Tente novamente.");

  @override
  String toString() => message;
}
