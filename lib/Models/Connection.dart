class Connection{
  bool isAccepted = false;
  bool isActive = false;
  late String studentID;
  late String TeacherID;

  Connection.Response(
      this.isAccepted, this.isActive, this.studentID, this.TeacherID);

  Connection.Send(this.studentID, this.TeacherID);
}