class User {
  final String firstName;
  final String status;
  final int rollNo;

  const User({
 this.firstName,
     this.status,
    this.rollNo,
  });

  User copy({
    String firstName,
    String status,
    int rollNo,
  }) =>
      User(
        firstName: firstName ?? this.firstName,
        status: status ?? this.status,
        rollNo: rollNo ?? this.rollNo,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          firstName == other.firstName &&
          status == other.status &&
          rollNo == other.rollNo;

  @override
  int get hashCode => firstName.hashCode ^ status.hashCode ^ rollNo.hashCode;
}
