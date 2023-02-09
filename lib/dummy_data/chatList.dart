class MyChatList{
  static List<ChatModel> getList(){
    List<ChatModel> list =[];
    list.add(ChatModel(photo: "https://rukminim1.flixcart.com/image/1024/1024/kzsqykw0/top/f/k/1/xxl-lp22btps-lripsome-original-imagbqkuzpt926ad.jpeg?q=70",userName: "Md. User Name",sms: "is a text messaging service component of most telephone, Internet, and mobile device systems. It uses standardized communication",isActive: true));
    list.add(ChatModel(photo: "https://cdn.pixabay.com/photo/2013/05/11/08/28/sunset-110305__480.jpg",userName: "Images may be subject to copyright",sms: "kkkkkk",isActive: true));
    list.add(ChatModel(photo: "https://st.depositphotos.com/2309453/3449/i/600/depositphotos_34490345-stock-photo-confident-casual-unshaven-young-man.jpg",userName: "What are SMS and MMS and How do They Differ",sms: "is a text messaging service component of most telephone, Internet, and mobile device systems. It uses standardized communication",isActive: true));
    list.add(ChatModel(photo: "https://cdn.pixabay.com/photo/2013/05/11/08/28/sunset-110305__480.jpg",userName: "What",sms: "Meet Messages, Google's official app for texting (SMS, MMS) and chat (RCS). Message anyone",isActive: true));
    list.add(ChatModel(photo: "https://iheartcraftythings.com/wp-content/uploads/2021/04/Man-DRAWING-%E2%80%93-STEP-10.jpg",userName: "W",sms: "Google SMS applications. Use Google applications via SMS text message. Calendar SMS. Check your calendar when you're on the go. Google Voice Text messages.",isActive: false));
    list.add(ChatModel(photo: "https://st.depositphotos.com/2309453/3449/i/600/depositphotos_34490345-stock-photo-confident-casual-unshaven-young-man.jpg",userName: "What are SMS and MMS",sms: "Meet Messages, Google's official app for texting (SMS, MMS) and chat (RCS). Message anyone",isActive: true));
    list.add(ChatModel(photo: "https://iheartcraftythings.com/wp-content/uploads/2021/04/Man-DRAWING-%E2%80%93-STEP-10.jpg",userName: "W",sms: "Meet Messages,",isActive: true));
    list.add(ChatModel(photo: "https://cdn.pixabay.com/photo/2013/05/11/08/28/sunset-110305__480.jpg",userName: "Google SMS applications",sms: "Google SMS applications. Use Google applications via SMS text message. Calendar SMS. Check your calendar when you're on the go. Google Voice Text messages.",isActive: false));
    list.add(ChatModel(photo: "https://assets-in.bmscdn.com/iedb/movies/images/extra/vertical_logo/mobile/thumbnail/xxlarge/spider-man-no-way-home-et00310790-15-03-2022-10-22-50.jpg",userName: "and How do They",sms: "M",isActive: false));
    list.add(ChatModel(photo: "https://st.depositphotos.com/2309453/3449/i/600/depositphotos_34490345-stock-photo-confident-casual-unshaven-young-man.jpg",userName: "Google SMS applications",sms: "Google SMS applications. Use Google applications via SMS text message. Calendar SMS. Check your calendar when you're on the go. Google Voice Text messages.",isActive: true));
    return list;
  }
}

class ChatModel{
  String photo,userName,sms;
  bool isActive;

  ChatModel({this.photo,this.userName, this.sms,this.isActive});
}