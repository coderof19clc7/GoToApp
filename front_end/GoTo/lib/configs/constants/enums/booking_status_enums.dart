enum ClientBookingStatusEnums {
  none, showBookingInfo, finding, driverFound, canceled, driverCanceled,
}
enum DriverBookingStatusEnums {
  none, accepted, rejected, notAvailable, finished,
  clientCanceled, clientFound, clientPickedUp,
}