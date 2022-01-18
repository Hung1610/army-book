// constants and enums
// DonnC

const String version = 'v1.0.0';

/// sidebar signal
enum SideBarSignal {
  None,
  AddTodo,
  AddLogBook,
  EditLogBook,
  ViewLogBook,
}

/// view mode on home screen
enum ViewMode {
  None,
  List,
  Grid,
}

/// general response action
enum ResponseAction {
  None,
  Success,
  Fail,
  Error,
}

/// general response event action
enum ResponseEventAction {
  None,
  Success,
  Fail,
  Error,
  DeleteTodo,
  DeleteLogEntry,
}

/// document type as enum
enum DocType {
  GiaoTrinh,
  Others,
}

final docTypeStrings = const {
  DocType.GiaoTrinh: 'Giáo trình',
  DocType.Others: 'Khác'
};

const String logHintText = """
- Viết mô tả nội dung tài liệu.
- Mô tả ngắn gọn, đầy đủ.
""";

class EncryptionDatabaseCodec {
  // system wide encryption and decryption key
  // FIXME: !!!!!!! DISABLE ENCRYPTION, VERY SLOW PERFOMANCE !!!!!!!!!!!!!!!!!
  /// ------------------------------------------------------------------------
  ///    !!!!!!!            DONT CHANGE THESE KEYS !!!!!!!!!
  /// ------------------------------------------------------------------------
  static const String _encryptCodecSignature = 'encrypt';
  static const String _databasePassword = "_?w0Q3nX*ns%";
  static const String _externalFileKey = "h%Jq&Q_Z+QbViW";

  // internal encryption
  static const bool _enableEncryption = true;

  String get dbPwd => _databasePassword;
  String get dbCodec => _encryptCodecSignature;
  String get backUpKey => _externalFileKey;
  bool get encryptionEnabled => _enableEncryption;
}
