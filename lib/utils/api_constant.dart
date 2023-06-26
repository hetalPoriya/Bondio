class ApiConstant {
  //apis
  static String buildUrl(String endpoint) {
    // String host =
    //     'http://sh021.hostgator.tempwebhost.net/~synraiar/bondio/api/v1/';
    String host = 'https://bondiomeet.com/';

    final apiPath = host + endpoint;
    return apiPath;
  }

  //api
  //static String registerOtpApi = 'register-otp';
  static String imageBaseUrl = 'https://bondiomeet.com/storage/app/';
  static String registerOtpApi = 'api/v1/registration-otp';

  //static String registerApi = 'api/v1/register';
  static String registerApi = 'api/v1/register-user';
  static String isRegisterApi = 'api/v1/is-registered';
  static String loginApi = 'api/v1/login';
  static String logoutApi = 'api/v1/logout';
  static String customerDetailApi = 'api/v1/customer-detail';
  static String updateProfileApi = 'api/v1/update-profile';
  static String updatePasswordApi = 'api/v1/change-password';
  static String forgotPasswordOtpApi = 'api/v1/forget-password-otp';
  static String forgotPasswordVerifyOtpApi =
      'api/v1/forget-password-verify-otp';
  static String forgotPasswordUpdateApi = 'api/v1/forget-password-update';
  static String getEventApi = 'api/v1/get-event';
  static String createEventApi = 'api/v1/create-event';
  static String updateEventApi = 'api/v1/update-event';

  //firebase collections
  static String userCollection = 'user';
  static String manageContactCollection = 'users_contacts';
  static String personalChatRoomCollection = 'personal_chat_room';
  static String personalChatListCollection = 'personal_chat_list';
  static String chatRoomCollection = 'chat_room';
  static String groupChatListCollection = 'group_chat_list';
  static String groupChatRoomCollection = 'group_chat_room';

  //group model
  static String groupName = 'group_name';
  static String groupIcon = 'group_icon';
  static String members = 'members';
  static String membersId = 'members_id';
  static String isAdmin = 'isAdmin';
  static String groupId = 'group_id';
  static String lastMessage = 'last_message';
  static String lastMessageSender = 'last_message_sender';
  static String timestamp = 'timestamp';
  static String eventDate = 'event_date';
  static String isEvent = 'isEvent';
  static String isPinned = 'isPinned';
  static String isArchive = 'isArchive';
  static String userToken = 'userToken';

  //contact model
  static String phoneNumber = 'phone_number';
  static String userName = 'user_name';
  static String status = 'status';
  static String fcmToken = 'fcm_token';
  static String id = 'id';

  //message
  static String idFrom = 'idFrom';
  static String deletedUserList = 'deletedBy';
  static String idTo = 'idTo';
  static String isRead = 'isRead';
  static String isReadFGroup = 'isRead_group';
  static String senderName = 'sender_name';

  static String user1 = 'user1';
  static String user2 = 'user2';
  static String chatPersonList = 'chatPersonList';
  static String peerId = 'peerId';
  static String peerName = 'peerName';
  static String image = 'image';

  //event
  static String eventName = 'Event Name: ';
  static String eventDes = 'Event Description: ';
  static String totalMembers = 'Total Members: ';
  static String invitedBy = 'Invited By: ';
  static String eventTime = 'Event Time: ';
  static String eveDate = 'Event Date: ';
  static String eventLocation = 'Event Location: ';

  //user
  static String name = 'name';
  static String photo = 'photo';
  static String photoSocial = 'photo_social';
  static String onlineStatus = 'online_status';
  static String deviceToken = 'device_token';
  static String isUser2Archived = 'isUser2Archived';
  static String isUser1Archived = 'isUser1Archived';
}