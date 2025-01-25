enum FunctionType {
  leader,
  regent,
  media,
  receptionist,
  secretary,
  concierge,
  evangelism,
  events,
  member;

  factory FunctionType.fromString(String type) {
    if (type == 'Líder') {
      return FunctionType.leader;
    } else if (type == 'Regente') {
      return FunctionType.regent;
    } else if (type == 'Mídia') {
      return FunctionType.media;
    } else if (type == 'Recepcionista') {
      return FunctionType.receptionist;
    } else if (type == 'Secretário(a)') {
      return FunctionType.secretary;
    } else if (type == 'Portaria') {
      return FunctionType.concierge;
    } else if (type == 'Evangelismo') {
      return FunctionType.secretary;
    } else if (type == 'Eventos') {
      return FunctionType.secretary;
    } else {
      return FunctionType.member;
    }
  }

  String get text {
    switch (this) {
      case FunctionType.leader:
        return 'Líder';
      case FunctionType.regent:
        return 'Regente';
      case FunctionType.media:
        return 'Mídia';
      case FunctionType.receptionist:
        return 'Recepcionista';
      case FunctionType.secretary:
        return 'Secretário(a)';
      case FunctionType.concierge:
        return 'Portaria';
      case FunctionType.evangelism:
        return 'Evangelismo';
      case FunctionType.events:
        return 'Eventos';
      case FunctionType.member:
        return 'Membro';
    }
  }
}
