
import 'package:danielabake/core/network/api_client.dart';
import 'package:danielabake/core/network/constants/api_constants.dart';
import 'package:danielabake/core/network/network_result.dart';
import 'package:danielabake/features/chat_screen/repositories/msg_repository.dart';

import '../models/request/create_conversation_request_model.dart';
import '../models/request/send_msg_request_model.dart';
import '../models/response/create_conversation_response_model.dart';
import '../models/response/get_admin_response_model.dart';
import '../models/response/send_msg_respoonse_model.dart';


class MessageRepoImpl implements MsgRepository {
  final ApiClient _apiClient;

  MessageRepoImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  NetworkResult<List<SendMsgResponseModel>> sendMsg(SendMessageRequest request, String conversationId){
    return _apiClient.post(
      endpoint: ApiConstants.chat.sendMsg(conversationId),
      data: request.toJson(),
      fromJsonT: (json) => (json as List).map((item) => SendMsgResponseModel.fromJson(item)).toList(),
    );
  }
  @override
  NetworkResult<CreateConversationResponseModel> createConversation(CreateConversationRequestModel request){
    return _apiClient.post(
      endpoint: ApiConstants.chat.createConversation,
      data: request.toJson(),
      fromJsonT: (json) => CreateConversationResponseModel.fromJson(json),
    );
  }

  @override
  NetworkResult<List< GetAdminResponseModel>> getAdmin(){
    return _apiClient.get(
      endpoint: ApiConstants.chat.getAdmin,
      fromJsonT: (json) => (json as List).map((item) => GetAdminResponseModel.fromJson(item)).toList() ,
    );
  }

  @override
  NetworkResult<List<SendMsgResponseModel>> getAllMsg(String conversationId){
    return _apiClient.get(
      endpoint: ApiConstants.chat.getAllMsg(conversationId),
      queryParameters: {"page" : 1, 'limit' : 20},
      fromJsonT: (json) => (json as List).map((item) => SendMsgResponseModel.fromJson(item)).toList() ,
    );
  }
}
