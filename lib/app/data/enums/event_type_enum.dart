enum EventType {
  congress,
  retreat,
  cult,
  bibleStudy,
  cinema,
  scavengerHunt,
  social,
  exchange;

  factory EventType.fromString(String type) {
    if (type == 'Congresso') {
      return EventType.congress;
    } else if (type == 'Retiro') {
      return EventType.retreat;
    } else if (type == 'Culto') {
      return EventType.cult;
    } else if (type == 'Estudo bíblico') {
      return EventType.bibleStudy;
    } else if (type == 'Cinema') {
      return EventType.cinema;
    } else if (type == 'Gincana') {
      return EventType.scavengerHunt;
    } else if (type == 'Social') {
      return EventType.social;
    } else {
      return EventType.exchange;
    }
  }

  String get text {
    switch (this) {
      case EventType.congress:
        return 'Congresso';
      case EventType.retreat:
        return 'Retiro';
      case EventType.cult:
        return 'Culto';
      case EventType.bibleStudy:
        return 'Estudo bíblico';
      case EventType.cinema:
        return 'Cinema';
      case EventType.scavengerHunt:
        return 'Gincana';
      case EventType.social:
        return 'Social';
      case EventType.exchange:
        return 'Intercâmbio';
    }
  }
}
