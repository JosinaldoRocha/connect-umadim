enum FunctionType {
  leader,
  viceLeader,
  regent,
  media,
  receptionist,
  secretary,
  doorman,
  evangelist,
  events,
  member;

  factory FunctionType.fromString(String type) {
    if (type == 'Líder') {
      return FunctionType.leader;
    } else if (type == 'Vice-líder') {
      return FunctionType.viceLeader;
    } else if (type == 'Regente') {
      return FunctionType.regent;
    } else if (type == 'Mídia') {
      return FunctionType.media;
    } else if (type == 'Recepcionista') {
      return FunctionType.receptionist;
    } else if (type == 'Secretário(a)') {
      return FunctionType.secretary;
    } else if (type == 'Porteiro') {
      return FunctionType.doorman;
    } else if (type == 'Evangelista') {
      return FunctionType.evangelist;
    } else if (type == 'Organizador(a) de eventos') {
      return FunctionType.events;
    } else {
      return FunctionType.member;
    }
  }

  String get text {
    switch (this) {
      case FunctionType.leader:
        return 'Líder';
      case FunctionType.viceLeader:
        return 'Vice-líder';
      case FunctionType.regent:
        return 'Regente';
      case FunctionType.media:
        return 'Mídia';
      case FunctionType.receptionist:
        return 'Recepcionista';
      case FunctionType.secretary:
        return 'Secretário(a)';
      case FunctionType.doorman:
        return 'Porteiro';
      case FunctionType.evangelist:
        return 'Evangelista';
      case FunctionType.events:
        return 'Organizador(a) de eventos';
      case FunctionType.member:
        return 'Membro';
    }
  }
}
