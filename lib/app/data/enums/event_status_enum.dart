enum EventStatus {
  scheduled,
  ongoing,
  completed,
  canceled,
  postponed,
  notScheduled;

  factory EventStatus.fromString(String type) {
    if (type == 'Agendado') {
      return EventStatus.scheduled;
    } else if (type == 'Em andamento') {
      return EventStatus.ongoing;
    } else if (type == 'Finalizado') {
      return EventStatus.completed;
    } else if (type == 'Cancelado') {
      return EventStatus.canceled;
    } else if (type == 'Adiado') {
      return EventStatus.postponed;
    } else {
      return EventStatus.notScheduled;
    }
  }

  String get text {
    switch (this) {
      case EventStatus.scheduled:
        return 'Agendado';
      case EventStatus.ongoing:
        return 'Em andamento';
      case EventStatus.completed:
        return 'Finalizado';
      case EventStatus.canceled:
        return 'Cancelado';
      case EventStatus.postponed:
        return 'Adiado';
      case EventStatus.notScheduled:
        return 'Não agendado';
    }
  }
}
