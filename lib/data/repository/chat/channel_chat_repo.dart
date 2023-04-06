import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:deixa/data/model/chat_models/chat_channels_md.dart';
import 'package:deixa/data/repository/remote/api/cms_api.dart';
import 'package:deixa/utils/crop_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/failure/failure.dart';
import '../../../helpers/encryption_data.dart';
import '../../../presentation/res/colors.dart';
import '../../constant/http_method.dart';
import '../../constant/strings.dart';

import '../remote/api/deixa_api.dart';
import 'package:path/path.dart' as p;

final channelProvider = ChangeNotifierProvider((ref) => ChannelsChatRepoImpl());

class ChannelsChatRepoImpl extends ChangeNotifier {
  bool isAllChannelsLoading = false;
  bool isTrendingChannelsLoading = false;
  bool isMyChannelsLoading = false;
  bool inboxLoading = false;
  bool loading = false;
  List<ChatChannelModel>? channels;
  List<ChatChannelModel>? trendingChannels;
  List<ChatChannelModel>? myChannels;
  List<ChannelModel>? inboxes;
  var userBox = Hive.box(USERS);
  int updateCounter = 0;
  File groupImage = File('');

  callAllChannels() async {
    final result = await getAllChannels();
    result.fold((l) => print(l), (r) => channels = r);
    notifyListeners();
  }

  callTrendingChannels() async {
    final result = await getTrendingChannels();
    result.fold((l) => print(l), (r) => trendingChannels = r);
    notifyListeners();
  }

  callMyChannels() async {
    final result = await getMyChannels();
    result.fold((l) => print(l), (r) => myChannels = r);
    notifyListeners();
  }

  callInboxes() async {
    final result = await getInboxes();
    result.fold((l) => print(l), (r) => inboxes = r);
    notifyListeners();
  }

  callMarkFav(String cid, int index, bool isTrending) async {
    final result = await markFav(cid, index, isTrending);
    result.fold((l) {
      Fluttertoast.showToast(msg: l.toString());
    }, (r) {
      Fluttertoast.showToast(msg: r);
    });
  }

  callMarkUnFav(String cid) async {
    final result = await markUnFav(cid);
    result.fold((l) {
      Fluttertoast.showToast(msg: l.toString());
    }, (r) {
      Fluttertoast.showToast(msg: r);
    });
  }

  callUpdateGroup(String groupName, groupImage, String channelId) async {
    final result = await updateGroup(groupName, groupImage, channelId);
    result.fold((l) {
      Fluttertoast.showToast(msg: l.toString());
    }, (r) {
      Fluttertoast.showToast(msg: r);
    });
  }

  Future<Either<Failure, List<ChatChannelModel>>> getAllChannels() async {
    isAllChannelsLoading = true;
    try {
      final res = await DeixaApi().request(
        HttpMethod.get,
        '${CmsApi.allChannelsPath}/${userBox.get('getcurrentUser')['uid']}',
      );
      // final response = await http
      //     .get(Uri.parse('${CmsApi.chatBaseUrl}${CmsApi.allChannelsPath}'));
      // var body = response.body;
      // Map data = jsonDecode(body);
      // print(data);
      // print(response.statusCode);
      if (res.statusCode == 200) {
        if (res.data[STATUS] == 'success') {
          List<ChatChannelModel> channels = [];
          List tempList = res.data['data'];
          for (int i = 0; i < tempList.length; i++) {
            ChatChannelModel channelModel =
                ChatChannelModel.fromMap(tempList[i]);
            channels.add(channelModel);
          }
          isAllChannelsLoading = false;
          notifyListeners();
          return Right(channels);
        }
      }
      isAllChannelsLoading = false;
      notifyListeners();
      return Left(Failure(message: 'Something went wrong'));
    } catch (e) {
      isAllChannelsLoading = false;
      notifyListeners();
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, List<ChatChannelModel>>> getMyChannels() async {
    isMyChannelsLoading = true;
    try {
      final res = await DeixaApi().request(
        HttpMethod.get,
        '${CmsApi.getMyChannels}/${userBox.get('getcurrentUser')['uid']}',
      );
      // final response = await http.get(Uri.parse(
      //     '${CmsApi.chatBaseUrl}${CmsApi.getMyChannels}/${userBox.get('getcurrentUser')['uid']}'));
      // var body = response.body;
      // Map data = jsonDecode(body);
      if (res.statusCode == 200) {
        if (res.data[STATUS] == 'success') {
          List<ChatChannelModel> channels = [];
          List tempList = res.data['data'];
          for (int i = 0; i < tempList.length; i++) {
            ChatChannelModel channelModel =
                ChatChannelModel.fromMap(tempList[i], isMyChannels: true);
            channels.add(channelModel);
          }
          isMyChannelsLoading = false;
          notifyListeners();
          return Right(channels);
        }
      }
      isMyChannelsLoading = false;
      notifyListeners();
      return Left(Failure(message: 'Something went wrong'));
    } catch (e) {
      isMyChannelsLoading = false;
      notifyListeners();
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, List<ChatChannelModel>>> getTrendingChannels() async {
    isTrendingChannelsLoading = true;
    try {
      final res = await DeixaApi().request(
        HttpMethod.get,
        '${CmsApi.getTrendingChannels}/${userBox.get('getcurrentUser')['uid']}',
      );
      // final response = await http
      //     .get(Uri.parse('${CmsApi.chatBaseUrl}${CmsApi.getTrendingChannels}'));
      // var body = response.body;
      // Map data = jsonDecode(body);
      if (res.statusCode == 200) {
        if (res.data[STATUS] == 'success') {
          List<ChatChannelModel> channels = [];
          List tempList = res.data['data'];
          for (int i = 0; i < tempList.length; i++) {
            ChatChannelModel channelModel =
                ChatChannelModel.fromMap(tempList[i]);
            channels.add(channelModel);
          }
          isTrendingChannelsLoading = false;
          notifyListeners();
          return Right(channels);
        }
      }
      isTrendingChannelsLoading = false;
      notifyListeners();
      return Left(Failure(message: 'Something went wrong'));
    } catch (e) {
      isTrendingChannelsLoading = false;
      notifyListeners();
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, List<ChannelModel>>> getInboxes() async {
    inboxLoading = true;
    try {
      final res = await DeixaApi().request(
        HttpMethod.get,
        '${CmsApi.getInboxes}/${userBox.get('getcurrentUser')['uid']}',
      );
      // final response = await http.get(Uri.parse(
      //     '${CmsApi.chatBaseUrl}${CmsApi.getInboxes}/${userBox.get('getcurrentUser')['uid']}'));
      // var body = response.body;
      // Map data = jsonDecode(body);
      if (res.statusCode == 200) {
        if (res.data[STATUS] == 'success') {
          List<ChannelModel> inboxList = [];
          List tempList = res.data['data'];
          for (int i = 0; i < tempList.length; i++) {
            ChannelModel channelModel = ChannelModel.fromMap(tempList[i]);
            inboxList.add(channelModel);
          }
          inboxLoading = false;
          loading = false;
          notifyListeners();
          return Right(inboxList);
        }
      }
      inboxLoading = false;
      loading = false;
      notifyListeners();
      return Left(Failure(message: 'Something went wrong'));
    } catch (e) {
      inboxLoading = false;
      loading = false;
      notifyListeners();
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, String>> markFav(
      String cid, int index, bool isTrending) async {
    loading = true;
    notifyListeners();
    try {
      Map bodyMap = {
        "cid": EncryptionData.encryptData(cid),
        "uid": EncryptionData.encryptData(userBox.get('getcurrentUser')['uid']),
        "createdAt": EncryptionData.encryptData("${DateTime.now().year}"),
        "updatedAt": EncryptionData.encryptData("${DateTime.now().year}")
      };
      final res = await DeixaApi()
          .request(HttpMethod.post, '${CmsApi.markFav}', body: bodyMap);
      // final response = await http.post(
      //     Uri.parse('${CmsApi.chatBaseUrl}${CmsApi.markFav}'),
      //     body: bodyMap);
      // var body = response.body;
      // Map data = jsonDecode(body);
      if (res.statusCode == 200) {
        String message = '';
        if (res.data[STATUS] == 'success') {
          if (isTrending) {
            trendingChannels![index].isLiked = true;
          } else {
            channels![index].isLiked = true;
          }
          message = 'Successfully added to favorites';
        } else if (res.data[STATUS] == 'conflict') {
          if (isTrending) {
            trendingChannels![index].isLiked = false;
          } else {
            channels![index].isLiked = false;
          }
          message = 'Successfully removed from favorites';
        }
        loading = false;
        notifyListeners();
        updateState();
        return Right(message);
      } else if (res.statusCode == 409) {
        loading = false;
        notifyListeners();
        updateState();
        return Right(res.data['message']);
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

  Future<Either<Failure, String>> markUnFav(String cid) async {
    loading = true;
    notifyListeners();
    try {
      Map bodyMap = {
        "cid": EncryptionData.encryptData(cid),
        "uid": EncryptionData.encryptData(userBox.get('getcurrentUser')['uid']),
        "createdAt": EncryptionData.encryptData("${DateTime.now().year}"),
        "updatedAt": EncryptionData.encryptData("${DateTime.now().year}")
      };
      print(bodyMap);
      final res = await DeixaApi()
          .request(HttpMethod.post, '${CmsApi.markUnFav}', body: bodyMap);
      // final response = await http.post(
      //     Uri.parse('${CmsApi.chatBaseUrl}${CmsApi.markUnFav}'),
      //     body: bodyMap);
      // var body = response.body;
      // Map data = jsonDecode(body);
      // print(data);
      if (res.statusCode == 200) {
        if (res.data[STATUS] == 'success') {
          loading = false;
          notifyListeners();
          return Right('Successfully removed from favorites');
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

  removeFromFav(int index) {
    myChannels!.removeAt(index);
    notifyListeners();
  }

  updateState() {
    updateCounter = updateCounter + 1;
    notifyListeners();
  }

  Future<Either<Failure, String>> updateGroup(
      String groupName, image, String channelId) async {
    Map params;
    params = {
      "channel": {
        // "ownerid":
        //     EncryptionData.encryptData(userBox.get('getcurrentUser')['uid']),
        "name": EncryptionData.encryptData(groupName),
        "description": EncryptionData.encryptData(groupName),
        "types": EncryptionData.encryptData('groupChat'),
        "thumbnailUrl": EncryptionData.encryptData(image),
        // "messageCount": EncryptionData.encryptData('0'),
        // "views": EncryptionData.encryptData('0'),
        "createdAt": EncryptionData.encryptData('${DateTime.now()}'),
        "updatedAt": EncryptionData.encryptData('${DateTime.now()}')
      },
    };
    loading = true;
    notifyListeners();
    try {
      final res = await DeixaApi().request(
          HttpMethod.patch, '${CmsApi.createOneOnOneChat}/$channelId',
          body: params);
      if (res.statusCode == 200) {
        if (res.data[STATUS] == 'success') {
          loading = false;
          groupImage = File('');
          notifyListeners();
          updateState();
          return Right('Group info has been updated successfully');
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

  Widget bottomSheet(BuildContext context) {
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
                  _pickImage(ImageSource.camera, context);
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
                  _pickImage(ImageSource.gallery, context);
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

  _pickImage(ImageSource imageSource, BuildContext context) async {
    File? _imageFile;
    final pickedImage = await ImagePicker().pickImage(source: imageSource);
    _imageFile = pickedImage != null ? File(pickedImage.path) : null;
    if (_imageFile == null) return null;
    File? file = await cropImage(_imageFile);
    if (file != null) {
      groupImage = file;
    }
    notifyListeners();
    updateState();
    Navigator.pop(context, true);
  }

  Future<String> uploadChatImage(Map data) async {
    bool status = false;
    loading = true;
    notifyListeners();
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
      status = true;
      loading = false;
      notifyListeners();
      return imageUrl;
    } catch (e) {
      loading = false;
      notifyListeners();
      print(e.toString());
    }
    loading = false;
    notifyListeners();
    return '';
  }
  removeImage(){
    groupImage = File('');
    updateState();
    notifyListeners();
  }
}
