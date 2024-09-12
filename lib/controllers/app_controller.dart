import 'package:get/get.dart';

class AppController {
  static String? _accessToken;
  static String? _message;
  static int? _meetingId;
  static int? _participantId;
  static int? _mainUid;
  static String? _role;
  static String? _userName;
  static String? _email;
  static String? _mobile;
  static int? _isVerified;
  static int? _isManager;
  static String? _depName;
  static int? _depId;
  static int? _depVerified;
  static int? _depActive;
  static String? _noMatched; //*****
  static String? _noName;
  static String? _whomToMeetName;
  static String? _countryCode;
  static String? _firebaseKey;
  static int? _visitorId;
  static int? _verification;
  static int? _visitorInviteStatus;
  static int? _callUpdateMethod;
  static int? _isvalidKey = 0;
  static int? _faceMatched = 0;
  static String? _dateFromBackend;
  static int? _mobNoMatchedButFirebaseKeyNull = 0; //***new */
  static int? _mobNoMatchedButFirebaseKeyExistsButNotInFirestore =
      0; //***new */

  static get dateFromBackend => _dateFromBackend;
  static setDateFromBackend(value) {
    _dateFromBackend = value;
  }

  static get faceMatched => _faceMatched;
  static setFaceMatched(value) {
    _faceMatched = value;
  }

  static get mobNoMatchedButFirebaseKeyNull => _mobNoMatchedButFirebaseKeyNull;
  static setMobNoMatchedButFirebaseKeyNull(value) {
    _mobNoMatchedButFirebaseKeyNull = value;
  }

  static get mobNoMatchedButFirebaseKeyExistsButNotInFirestore =>
      _mobNoMatchedButFirebaseKeyExistsButNotInFirestore;
  static setmobNoMatchedButFirebaseKeyExistsButNotInFirestore(value) {
    _mobNoMatchedButFirebaseKeyExistsButNotInFirestore = value;
  }

  static get verification => _verification;
  static setVerification(value) {
    _verification =
        value; // for verify my timesheet's data with value as 1 and 0
  }

  static get isValidKey => _isvalidKey;
  static setValidKey(value) {
    _isvalidKey = value;
  }

  static get callUpadateMethod => _callUpdateMethod;
  static setCallUpadteMethod(value) {
    _callUpdateMethod = value;
  }

  static get depName => _depName;
  static setdepName(value) {
    _depName = value;
  }

  static get visitorId => _visitorId;
  static setVisitorId(value) {
    _visitorId = value;
  }

  static get visitorInviteStatus => _visitorInviteStatus;
  static setVisitorInviteStatus(value) {
    _visitorInviteStatus = value;
  }

  static get firebaseKey => _firebaseKey;
  static setFirebaseKey(value) {
    _firebaseKey = value;
  }

  static get depId => _depId;
  static setdepId(value) {
    _depId = value;
  }

  static get depVerified => _depVerified;
  static setdepVerified(value) {
    _depVerified = value;
  }

  static get depActive => _depActive;
  static setdepActive(value) {
    _depActive = value;
  }

  static get isManager => _isManager;
  static setisManager(value) {
    _isManager = value;
  }

  static get isVerified => _isVerified;
  static setisVerified(value) {
    _isVerified = value;
  }

  static get mobile => _mobile;
  static setMobile(value) {
    _mobile = value;
  }

  static get userName => _userName;
  static setUserName(value) {
    _userName = value;
  }

  static get email => _email;
  static setEmail(value) {
    _email = value;
  }

  static get role => _role;
  static setRole(value) {
    _role = value;
  }

  //For meeting Participants list
  static get meetingId => _meetingId;
  static setmeetingId(value) {
    _meetingId = value;
  }

  //for participant id
  static get participantId => _participantId;
  static setParticipantId(value) {
    _participantId = value;
  }

  //For mainUid

  static get mainUid => _mainUid;
  static setMainUid(value) {
    _mainUid = value;
  }

  static get accessToken => _accessToken;
  static setaccessToken(value) {
    _accessToken = value;
  }

  static get message => _message;
  static setmessage(value) {
    _message = value;
  }

  static get noMatched => _noMatched;
  static setnoMatched(Value) {
    _noMatched = Value;
  }

  static get noName => _noName;
  static setnoName(Value) {
    _noName = Value;
  }

  static get whomToMeetName => _whomToMeetName;
  static setwhomToMeetName(Value) {
    _whomToMeetName = Value;
  }

  static get countryCode => _countryCode;
  static setCountryCode(Value) {
    _countryCode = Value;
  }
}
