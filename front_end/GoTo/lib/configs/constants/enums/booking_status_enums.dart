enum ClientBookingStatusEnums {
  none, showBookingInfo, finding, driverFound, driverArrived, finished,
}
enum DriverBookingStatusEnums {
  none, accepted, rejected, notAvailable, waitToConfirmAcceptation, finished,
  clientCanceled, clientFound, clientPickedUp,
}