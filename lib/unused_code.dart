// // addNurse(){
// //   // Create a new user with a name
// //   final user = <String, dynamic>{
// //     'id': 'NU002',
// //     'name': 'Elizabeth',
// //     'email': 'el@yopmail.com',
// //     'address': 'North town',
// //     'contactNo' : '+1 505-644-2601',
// //     'secretLoginKey' : EncryptData().encryptData('el@123')
// //   };
// //
// // // Add a new document with a generated ID
// //   db.collection("users").add(user).then((DocumentReference doc) =>
// //       print('DocumentSnapshot added with ID: ${doc.id}'));
// // }
//
//
//
// // db.collection('todos').snapshots().listen((event) {
// //    event.docs.forEach((DocumentSnapshot docSnapshot) {
// //      final Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;
// //      if (data == null) {
// //        return;
// //      }
// //      _todoList.add(Todo.fromDocumentSnapshot(docSnapshot.id, data));
// //   });
// //   print(event.docs.toString());
// // });
//
//
//
// void _isTaskInCurrentShift(Timestamp timestamp) {
//   var dateTime = timestamp.toDate();
//   Shift currentShift = _shiftsList.firstWhere((element) {
//
//     var hour = dateTime.formatDateTo24HourFormat;
//     var minute = dateTime.formatDateToMinuteFormat;
//
//
//     var startHour = element.startTime!.toDate().formatDateTo24HourFormat;
//     var startMinute = element.startTime!.toDate().formatDateToMinuteFormat;
//
//     var endHour = element.endTime!.toDate().formatDateTo24HourFormat;
//     var endMinute = element.endTime!.toDate().formatDateToMinuteFormat;
//
//     if(startHour <= hour && endHour <= hour ) {
//       if(startHour == hour && startMinute >= minute || endHour == hour && endMinute <= minute) {
//         return false;
//       }
//       return true;
//     } else if(startHour <= hour && endHour >= hour ) {
//       if(startHour == hour && startMinute <= minute || endHour == hour && endMinute >= minute) {
//         return false;
//       }
//       return true;
//     } else {
//       return false;
//     }
//   }, orElse: () => Shift());
//
//   debugPrint(currentShift.name);
// }