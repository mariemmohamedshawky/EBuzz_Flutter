class EmergencyModel {
  int id;
  String userName,
      photo,
      date,
      country,
      countryCode,
      state,
      city,
      road,
      notificationCount,
      massageCount;
  double latitude, longitude;

  EmergencyModel({
    this.id,
    this.userName,
    this.photo,
    this.date,
    this.country,
    this.countryCode,
    this.state,
    this.city,
    this.road,
    this.latitude,
    this.longitude,
    this.notificationCount,
    this.massageCount,
  });
}
