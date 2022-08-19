enum ClientBookingStatusEnums {
  none, showBookingInfo, finding, driverFound, driverArrived, finished,
}
enum DriverBookingStatusEnums {
  none, accepted, rejected, tripNotAvailable, waitToConfirmAcceptation,
  clientCancel, clientFound, clientPickedUp,
}