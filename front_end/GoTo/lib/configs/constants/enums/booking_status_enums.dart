enum ClientBookingStatusEnums {
  none, showBookingInfo, finding, driverFound, canceled, driverCanceled,
}
enum DriverBookingStatusEnums {
  none, accepted, rejected, notAvailable, waitToConfirmAcceptation, finished,
  clientCanceled, clientFound, clientPickedUp,
}