class EmergencyModel {
  int id, status;
  String userName,
      phone,
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
    this.phone,
    this.photo,
    this.date,
    this.country,
    this.countryCode,
    this.state,
    this.city,
    this.road,
    this.latitude,
    this.longitude,
    this.status,
    this.notificationCount,
    this.massageCount,
  });
}
