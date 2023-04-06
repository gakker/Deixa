import 'dart:io';
import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:deixa/data/model/chat_models/chat_channels_md.dart';
import 'package:deixa/data/model/chat_models/chat_message_md.dart';
import 'package:deixa/data/repository/remote/api/cms_api.dart';
import 'package:deixa/data/repository/remote/api/deixa_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../core/failure/failure.dart';
import '../../../helpers/encryption_data.dart';
import '../../../presentation/res/colors.dart';
import '../../../presentation/screens/chats/chat_updated/live_chat.dart';
import '../../../utils/crop_image.dart';
import '../../constant/http_method.dart';
import '../../constant/strings.dart';

final chatMessagesProvider =
    ChangeNotifierProvider((ref) => ChatMessagesRepoImpl());

class ChatMessagesRepoImpl extends ChangeNotifier {
  bool isMessagesLoading = false;
  bool isRepliesLoading = false;
  bool isLikesLoading = false;
  bool isInboxLoading = false;
  bool isUsersLoading = false;
  bool userPaginationLoading = false;
  bool messagesPaginationLoading = false;
  bool repliesPaginationLoading = false;
  bool loading = false;
  var userBox = Hive.box(USERS);
  List<MessageModel> messages = [];
  List<MessageModel> replies = [];
  List<ChatUserModel>? likes;
  List<ChatUserModel> users = [];
  List<ChatUserModel> groupMembers = [];
  int page = 1;
  int replyPage = 1;
  int userPage = 1;
  late IO.Socket socket;
  int updateCounter = 0;
  CroppedFile? croppedFile;
  CroppedFile? croppedFileReply;

  callMessages(String cid) async {
    final result = await getAllMessages(cid);
    result.fold((l) => print(l), (r) {
      if (r.isEmpty) {
        // Fluttertoast.showToast(msg: 'No more messages');
      } else {
        for (int i = 0; i < r.length; i++) {
          // if(page == 1){
          //   messages.add(r[i]);
          // }else{
          messages.insert(0, r[i]);
          // }
        }
        notifyListeners();
      }
    });
    notifyListeners();
  }

  callLikes(String messageId) async {
    final result = await getLikes(messageId);
    result.fold((l) => print(l), (r) => likes = r);
    notifyListeners();
  }

  callCreateChannel(ChatUserModel opponent, BuildContext context,
      {List<ChatUserModel>? opponents, String? groupName}) async {
    final result = await createChannel(opponent,
        opponents: opponents, groupName: groupName);
    result.fold((l) => print(l), (r) async {
      if (opponents == null) {
        ChatChannelModel channelModel = ChatChannelModel(channel: r);
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => LiveChat(channelModel)));
      } else {
        await goBackSelectionScreen(context);
        await goBackUsersScreen(context);
        Fluttertoast.showToast(msg: 'Group has been created successfully');
      }
    });
    notifyListeners();
  }

  callReplies(String messageId) async {
    final result = await getReplies(messageId);
    result.fold((l) => print(l), (r) {
      if (r.isEmpty) {
        // Fluttertoast.showToast(msg: 'No more replies');
      } else {
        for (int i = 0; i < r.length; i++) {
          // if(replyPage == 1){
          //   replies.add(r[i]);
          // }else{
          replies.insert(0, r[i]);
          // }
        }
        notifyListeners();
      }
    });
    notifyListeners();
  }

  callSendMessage(Map bodyParams, ScrollController scrollController,
      TextEditingController textEditingController, String channelName) async {
    final result = await sendMessage(
        bodyParams, scrollController, textEditingController, channelName);
    result.fold((l) => print(l), (r) {
      print(r);
    });
  }

  callSendLike(Map bodyParams, int index, bool isChatMessage) async {
    final result = await sendLike(bodyParams, index, isChatMessage);
    result.fold((l) => print(l), (r) {
      print(r);
    });
  }

  callUsers() async {
    final result = await getUsers();
    result.fold((l) => print(l), (r) {
      if (r.isEmpty) {
        Fluttertoast.showToast(msg: 'No more users');
      } else {
        for (int i = 0; i < r.length; i++) {
          users.add(r[i]);
        }
        notifyListeners();
      }
    });
    notifyListeners();
  }

  Future<Either<Failure, List<MessageModel>>> getAllMessages(String cid) async {
    if (page == 1) {
      isMessagesLoading = true;
    }
    Map bodyMap = {
      "page": EncryptionData.encryptData("$page"),
      "size": EncryptionData.encryptData("30")
    };
    try {
      final res = await DeixaApi().request(
          HttpMethod.post, '${CmsApi.getChannelMessages}/$cid',
          body: bodyMap);
      // final response = await http.post(
      //     Uri.parse('${CmsApi.chatBaseUrl}${CmsApi.getChannelMessages}/$cid'),
      //     body: bodyMap);
      // var body = response.body;
      // Map data = jsonDecode(body);
      // if (res.statusCode == 200) {
      if (res.data[STATUS] == SUCCESS) {
        List<MessageModel> messagesList = [];
        List tempList = res.data['data'];
        for (int i = 0; i < tempList.length; i++) {
          MessageModel messageModel = MessageModel.fromMap(tempList[i]);
          messagesList.add(messageModel);
        }
        isMessagesLoading = false;
        loading = false;
        messagesPaginationLoading = false;
        notifyListeners();
        return Right(messagesList);
      }
      // }
      isMessagesLoading = false;
      loading = false;
      messagesPaginationLoading = false;
      notifyListeners();
      return Left(Failure(message: 'Something went wrong'));
    } catch (e) {
      isMessagesLoading = false;
      loading = false;
      messagesPaginationLoading = false;
      notifyListeners();
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, List<MessageModel>>> getReplies(
      String messageId) async {
    if (replyPage == 1) {
      isRepliesLoading = true;
    }
    Map bodyMap = {
      "page": EncryptionData.encryptData("$replyPage"),
      "size": EncryptionData.encryptData("30")
    };
    print('----Map$bodyMap + $messageId');
    try {
      final res = await DeixaApi().request(
          HttpMethod.post, '${CmsApi.getReplies}/$messageId',
          body: bodyMap);
      // final response = await http.post(
      //     Uri.parse('${CmsApi.chatBaseUrl}${CmsApi.getReplies}/$messageId'),
      //     body: bodyMap);
      // var body = response.body;
      // Map data = jsonDecode(body);
      // print('----data:$data');
      if (res.statusCode == 200) {
        if (res.data[STATUS] == 'success') {
          List<MessageModel> messagesList = [];
          List tempList = res.data['data'];
          for (int i = 0; i < tempList.length; i++) {
            MessageModel messageModel = MessageModel.fromMap(tempList[i]);
            messagesList.add(messageModel);
          }
          isRepliesLoading = false;
          repliesPaginationLoading = false;
          notifyListeners();
          return Right(messagesList);
        }
      }
      isRepliesLoading = false;
      repliesPaginationLoading = false;
      notifyListeners();
      return Left(Failure(message: 'Something went wrong'));
    } catch (e) {
      isRepliesLoading = false;
      repliesPaginationLoading = false;
      notifyListeners();
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, List<ChatUserModel>>> getLikes(
      String messageId) async {
    isLikesLoading = true;
    try {
      final res = await DeixaApi().request(
        HttpMethod.get,
        '${CmsApi.getLikes}/$messageId',
      );
      // final response = await http.get(
      //   Uri.parse('${CmsApi.chatBaseUrl}${CmsApi.getLikes}/$messageId'),
      // );
      // var body = response.body;
      // Map data = jsonDecode(body);
      if (res.statusCode == 200) {
        if (res.data[STATUS] == 'success') {
          List<ChatUserModel> likesList = [];
          List tempList = res.data['data'];
          for (int i = 0; i < tempList.length; i++) {
            ChatUserModel messageModel =
                ChatUserModel.fromMap(tempList[i], true);
            likesList.add(messageModel);
          }
          isLikesLoading = false;
          notifyListeners();
          updateState();
          return Right(likesList);
        }
      }
      isLikesLoading = false;
      notifyListeners();
      return Left(Failure(message: 'Something went wrong'));
    } catch (e) {
      isLikesLoading = false;
      notifyListeners();
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, String>> sendMessage(
      Map bodyParams,
      ScrollController scrollController,
      TextEditingController textEditingController,
      String channelName) async {
    int messageCount = messages.length;
    int replyCount = replies.length;
    try {
      int randomNumber = Random().nextInt(100000);
      if (bodyParams['types'] == 'chatMessage' ||
          bodyParams['types'] == 'chat') {
        messages.add(MessageModel(
            user: ChatUserModel(
              firstName: userBox.get('getcurrentUser')['firstName'],
              lastName: userBox.get('getcurrentUser')['lastName'],
              profilePic: userBox.get('getcurrentUser')['profilePic'],
            ),
            cid: int.parse(bodyParams['cid']),
            id: randomNumber,
            uid: userBox.get('getcurrentUser')['uid'],
            message: bodyParams['message'],
            filePath: croppedFile == null ? '' : croppedFile!.path,
            replyCount: 0,
            likesCount: 0));
        notifyListeners();
      } else {
        replies.add(MessageModel(
            id: randomNumber,
            cid: int.parse(bodyParams['cid']),
            uid: userBox.get('getcurrentUser')['uid'],
            message: bodyParams['message'],
            replyCount: 0,
            filePath: croppedFileReply == null ? '' : croppedFileReply!.path,
            user: ChatUserModel(
              firstName: userBox.get('getcurrentUser')['firstName'],
              lastName: userBox.get('getcurrentUser')['lastName'],
              profilePic: userBox.get('getcurrentUser')['profilePic'],
            ),
            likesCount: 0));
        notifyListeners();
      }
      textEditingController.text = '';
      Future.delayed(Duration(milliseconds: 50), () {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 1),
          curve: Curves.fastOutSlowIn,
        );
      });
      notifyListeners();
      if (croppedFile != null) {
        String imgName = APP_NAME + '_' + randomString(8) + '.jpg';

        Map dt = {
          'imgPath': croppedFile!.path,
          'imgName': imgName,
        };

        var value = await uploadChatImage(dt);
        if (value.isNotEmpty) {
          bodyParams['url'] = value;
        }
      }
      if (croppedFileReply != null) {
        String imgName = APP_NAME + '_' + randomString(8) + '.jpg';

        Map dt = {
          'imgPath': croppedFileReply!.path,
          'imgName': imgName,
        };

        var value = await uploadChatImage(dt);
        if (value.isNotEmpty) {
          bodyParams['url'] = value;
        }
      }
      Map params = {
        "parentId": EncryptionData.encryptData(bodyParams['parentId']),
        "cid": EncryptionData.encryptData(bodyParams['cid']),
        "uid": EncryptionData.encryptData(bodyParams['uid']),
        "message": EncryptionData.encryptData(bodyParams['message']),
        "types": EncryptionData.encryptData(bodyParams['types']),
        "views": EncryptionData.encryptData(bodyParams['views']),
        "url": EncryptionData.encryptData(bodyParams['url']),
        "replyCount": EncryptionData.encryptData(bodyParams['replyCount']),
        "likesCount": EncryptionData.encryptData(bodyParams['likesCount']),
        "shareCount": EncryptionData.encryptData(bodyParams['shareCount']),
        "tokenEarned": EncryptionData.encryptData(bodyParams['tokenEarned']),
        "createdAt": EncryptionData.encryptData(bodyParams['createdAt']),
        "updatedAt": EncryptionData.encryptData(bodyParams['updatedAt'])
      };
      final res = await DeixaApi()
          .request(HttpMethod.post, '${CmsApi.sendMessage}', body: params);
      // final response = await http.post(
      //     Uri.parse('${CmsApi.chatBaseUrl}${CmsApi.sendMessage}'),
      //     body: bodyParams);
      // var body = response.body;
      // Map data = jsonDecode(body);
      // print('----data:$data');
      if (res.statusCode == 200) {
        if (res.data[STATUS] == 'success') {
          MessageModel messageModel = MessageModel.fromMap(res.data['data']);
          messageModel.room = channelName;
          messageModel.user = ChatUserModel(
            firstName: userBox.get('getcurrentUser')['firstName'],
            lastName: userBox.get('getcurrentUser')['lastName'],
            profilePic: userBox.get('getcurrentUser')['profilePic'],
          );
          if (messageCount != messages.length) {
            messageModel.index =
                messages.indexWhere((element) => element.id == randomNumber);
          }
          if (replyCount != replies.length) {
            messageModel.index =
                replies.indexWhere((element) => element.id == randomNumber);
          }
          croppedFile = null;
          croppedFileReply = null;
          socket.emit("createMessage", messageModel.toMap());
          // messages.removeWhere((element) => element.id == randomNumber);
          // replies.removeWhere((element) => element.id == randomNumber);
          notifyListeners();
          updateState();
          return Right('Message sent successfully');
        }
      }
      return Left(Failure(message: 'Something went wrong'));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, String>> sendLike(
      Map bodyParams, int index, bool isChatMessage) async {
    Map params = {
      "messageId": EncryptionData.encryptData(bodyParams['messageId']),
      "cid": EncryptionData.encryptData(bodyParams['cid']),
      "uid": EncryptionData.encryptData(bodyParams['uid']),
      "createdAt": EncryptionData.encryptData(bodyParams['createdAt']),
      "updatedAt": EncryptionData.encryptData(bodyParams['updatedAt'])
    };
    loading = true;
    notifyListeners();
    try {
      final res = await DeixaApi()
          .request(HttpMethod.post, '${CmsApi.sendLike}', body: params);
      // final response = await http.post(
      //     Uri.parse('${CmsApi.chatBaseUrl}${CmsApi.sendLike}'),
      //     body: bodyParams);
      // var body = response.body;
      // Map data = jsonDecode(body);
      if (res.statusCode == 200) {
        if (res.data[STATUS] == 'success') {
          if (isChatMessage) {
            messages[index].isLiked = true;
            if (messages[index].isLiked) {
              messages[index].likesCount = messages[index].likesCount! + 1;
            }
          } else {
            replies[index].isLiked = true;
            if (replies[index].isLiked) {
              replies[index].likesCount = replies[index].likesCount! + 1;
            }
          }
          loading = false;
          notifyListeners();
          return Right('Message liked successfully');
        } else if (res.data[STATUS] == 'conflict') {
          if (isChatMessage) {
            messages[index].isLiked = false;
            if (!messages[index].isLiked) {
              messages[index].likesCount = messages[index].likesCount! - 1;
            }
          } else {
            replies[index].isLiked = false;
            if (!replies[index].isLiked) {
              replies[index].likesCount = replies[index].likesCount! - 1;
            }
          }
          loading = false;
          notifyListeners();
          updateState();
          return Right('Message unliked successfully');
        }
      }
      loading = false;
      notifyListeners();
      return Left(Failure(message: 'Something went wrong'));
    } catch (e) {
      loading = false;
      notifyListeners();
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, ChannelModel>> createChannel(ChatUserModel opponent,
      {List<ChatUserModel>? opponents, groupName}) async {
    String name;
    String firstName = opponent.firstName ?? '';
    String lastName = opponent.lastName ?? '';
    name = firstName + ' ' + lastName;
    Map params;
    if (opponents == null) {
      params = {
        "channel": {
          "ownerid":
              EncryptionData.encryptData(userBox.get('getcurrentUser')['uid']),
          "name":
              EncryptionData.encryptData(name.trim().isEmpty ? 'Anon' : name),
          "description":
              EncryptionData.encryptData(name.trim().isEmpty ? 'Anon' : name),
          "types": EncryptionData.encryptData('chat'),
          "thumbnailUrl": EncryptionData.encryptData(opponent.profilePic),
          "messageCount": EncryptionData.encryptData('0'),
          "views": EncryptionData.encryptData('0'),
          "createdAt": EncryptionData.encryptData('${DateTime.now()}'),
          "updatedAt": EncryptionData.encryptData('${DateTime.now()}')
        },
        "participant": [
          {
            "uid": EncryptionData.encryptData(opponent.uid),
            "isAdmin": EncryptionData.encryptData('false'),
            "createdAt": EncryptionData.encryptData('${DateTime.now()}'),
            "updatedAt": EncryptionData.encryptData('${DateTime.now()}')
          }
        ]
      };
    } else {
      params = {
        "channel": {
          "ownerid":
              EncryptionData.encryptData(userBox.get('getcurrentUser')['uid']),
          "name": EncryptionData.encryptData(groupName),
          "description": EncryptionData.encryptData(groupName),
          "types": EncryptionData.encryptData('groupChat'),
          "thumbnailUrl": EncryptionData.encryptData(opponents[0].profilePic),
          "messageCount": EncryptionData.encryptData('0'),
          "views": EncryptionData.encryptData('0'),
          "createdAt": EncryptionData.encryptData('${DateTime.now()}'),
          "updatedAt": EncryptionData.encryptData('${DateTime.now()}')
        },
        "participant": [
          for (int i = 0; i < opponents.length; i++)
            {
              "uid": EncryptionData.encryptData(opponents[i].uid),
              "isAdmin": EncryptionData.encryptData('false'),
              "createdAt": EncryptionData.encryptData('${DateTime.now()}'),
              "updatedAt": EncryptionData.encryptData('${DateTime.now()}')
            }
        ]
      };
    }
    loading = true;
    notifyListeners();
    try {
      final res = await DeixaApi().request(
          HttpMethod.post, '${CmsApi.createOneOnOneChat}',
          body: params);

      // final response = await http.post(
      //     Uri.parse('${CmsApi.chatBaseUrl}${CmsApi.sendLike}'),
      //     body: bodyParams);
      // var body = response.body;
      // Map data = jsonDecode(body);
      if (res.statusCode == 200) {
        if (res.data[STATUS] == 'success') {
          loading = false;
          notifyListeners();
          return Right(ChannelModel.fromMap(res.data['data']));
        } else if (res.data[STATUS] == 'conflict') {
          loading = false;
          notifyListeners();
          return Right(ChannelModel.fromMap(res.data['data']));
        }
      }
      loading = false;
      notifyListeners();
      return Left(Failure(message: 'Something went wrong'));
    } catch (e) {
      loading = false;
      notifyListeners();
      return Left(Failure(message: e.toString()));
    }
  }

  goBack(BuildContext context) {
    messages.clear();
    replies.clear();
    socket.dispose();
    page = 1;
    croppedFile = null;
    socket.disconnect();
    notifyListeners();
    Navigator.pop(context);
  }

  goBackReplyScreen(BuildContext context) {
    replies.clear();
    replyPage = 1;
    croppedFileReply = null;
    notifyListeners();
    Navigator.pop(context);
  }

  void initSocket(ScrollController scrollController, String channelName,
      {int messageIndex = -1}) {
    try {
      socket = IO.io(dotenv.env['DEIXA_ENDPOINT_URL']!, <String, dynamic>{
        "transports": ["websocket"],
        "autoConnect": false,
      });
      socket.connect();
      socket.onConnect((_) {
        print('Socket connected');
        //  User Info Sending
        socket.emit('join', {
          'username':
              "${userBox.get('getcurrentUser')['firstName']} ${userBox.get('getcurrentUser')['lastName']}",
          'room': channelName,
        });

        socket.on(
            'userList',
            (data) => {
                  print('User List = > $data'),
                });
        //  Receiving Messages
        socket.on('createMessage', (receivedMessage) {
          print('Received Message: $receivedMessage');
          MessageModel chatMessageModel = MessageModel.fromMap(receivedMessage);
          if (chatMessageModel.types == 'chatMessage') {
            // messages.add(chatMessageModel);
            messages[chatMessageModel.index!] = chatMessageModel;
          } else {
            replies[chatMessageModel.index!] = chatMessageModel;
            // replies.add(chatMessageModel);
            // messages[messageIndex].message!.replyCount =
            //     messages[messageIndex].message!.replyCount! + 1;
            // notifyListeners();
            // updateState();
          }
          Future.delayed(Duration(milliseconds: 50), () {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 1),
              curve: Curves.fastOutSlowIn,
            );
          });
          updateState();
          notifyListeners();
        });
        updateState();
      });
    } catch (e) {
      print(e);
    }
  }

  updateState() {
    updateCounter = updateCounter + 1;
    notifyListeners();
  }

  Future<Either<Failure, List<ChatUserModel>>> getUsers() async {
    if (userPage == 1) {
      isUsersLoading = true;
    }
    Map bodyMap = {
      "page": EncryptionData.encryptData("$userPage"),
      "size": EncryptionData.encryptData("25")
    };
    try {
      final res = await DeixaApi()
          .request(HttpMethod.post, '${CmsApi.getUsers}', body: bodyMap);
      // final response = await http.post(
      //     Uri.parse('${CmsApi.chatBaseUrl}${CmsApi.getUsers}'),
      //     body: bodyMap);
      // var body = response.body;
      // Map data = jsonDecode(body);
      if (res.statusCode == 200) {
        if (res.data[STATUS] == 'success') {
          List<ChatUserModel> userList = [];
          List tempList = res.data['data'];
          for (int i = 0; i < tempList.length; i++) {
            ChatUserModel user = ChatUserModel.fromMap(tempList[i], false);
            if (user.uid != userBox.get('getcurrentUser')['uid']) {
              userList.add(user);
            }
          }
          isUsersLoading = false;
          userPaginationLoading = false;
          notifyListeners();
          return Right(userList);
        }
      }
      isUsersLoading = false;
      userPaginationLoading = false;
      notifyListeners();
      return Left(Failure(message: 'Something went wrong'));
    } catch (e) {
      isUsersLoading = false;
      userPaginationLoading = false;
      notifyListeners();
      return Left(Failure(message: e.toString()));
    }
  }

  goBackUsersScreen(BuildContext context) {
    users.clear();
    userPage = 1;
    notifyListeners();
    Navigator.pop(context);
  }

  goBackSelectionScreen(BuildContext context) {
    groupMembers.clear();
    for (int i = 0; i < users.length; i++) {
      users[i].isSelected = false;
      notifyListeners();
    }
    notifyListeners();
    updateState();
    Navigator.pop(context);
  }

  userPageIncrement() {
    userPage++;
    userPaginationLoading = true;
    notifyListeners();
  }

  messagesPageIncrement() {
    page++;
    messagesPaginationLoading = true;
    notifyListeners();
    updateState();
  }

  repliesPageIncrement() {
    replyPage++;
    repliesPaginationLoading = true;
    notifyListeners();
    updateState();
  }

  Widget bottomSheet(BuildContext context, bool isReply) {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Text(
            "Select photo",
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  _pickImage(ImageSource.camera, context, isReply);
                },
                splashColor: kTransparent,
                highlightColor: kTransparent,
                child: Row(
                  children: [
                    Icon(Icons.camera),
                    SizedBox(
                      width: 2,
                    ),
                    Text("Camera")
                  ],
                ),
              ),
              SizedBox(
                width: 7,
              ),
              InkWell(
                onTap: () {
                  _pickImage(ImageSource.gallery, context, isReply);
                },
                splashColor: kTransparent,
                highlightColor: kTransparent,
                child: Row(
                  children: [
                    Icon(Icons.image),
                    SizedBox(
                      width: 3,
                    ),
                    Text("Gallery")
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //? Pick Image
  _pickImage(
      ImageSource imageSource, BuildContext context, bool isReply) async {
    File? _imageFile;
    final pickedImage = await ImagePicker().pickImage(source: imageSource);
    _imageFile = pickedImage != null ? File(pickedImage.path) : null;
    if (_imageFile == null) return null;
    File? file = await cropImage(_imageFile);
    if (isReply) {
      croppedFileReply = CroppedFile(file!.path);
    } else {
      croppedFile = CroppedFile(file!.path);
    }
    notifyListeners();
    updateState();
    Navigator.pop(context, true);
  }

  Future<String> uploadChatImage(Map data) async {
    bool status = false;
    try {
      String imgPath = data['imgPath'];
      String imgName = data['imgName'];

      final formData = FormData.fromMap({
        'image_path': await MultipartFile.fromFile(imgPath,
            filename: imgName,
            contentType: MediaType("image", p.extension(imgPath)))
      });
      print(data);
      final response = await DeixaApi.instance.request(
          HttpMethod.post, '/${DeixaApi.ACTIVITIES_PATH}/chat-image',
          body: formData);
      final imageUrl = response.data['imageUrl'];
      print('URL: $imageUrl');
      status = true;
      return imageUrl;
    } catch (e) {
      print(e.toString());
    }
    return '';
  }

  makeUserSelected(int index) {
    if (users[index].isSelected!) {
      groupMembers.remove(users[index]);
      users[index].isSelected = false;
    } else {
      groupMembers.add(users[index]);
      users[index].isSelected = true;
    }
    notifyListeners();
    updateState();
  }
}
