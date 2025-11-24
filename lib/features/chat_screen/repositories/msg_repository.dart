import 'package:danielabake/core/network/network_result.dart';
import 'package:danielabake/features/Order_screen/models/request/place_order_request_model.dart';
import 'package:danielabake/features/Order_screen/models/response/place_order_response_model.dart';
import 'package:danielabake/features/chat_screen/models/request/create_conversation_request_model.dart';
import 'package:danielabake/features/chat_screen/models/request/send_msg_request_model.dart';
import 'package:danielabake/features/chat_screen/models/response/create_conversation_response_model.dart';
import 'package:danielabake/features/chat_screen/models/response/get_admin_response_model.dart';

import '../models/response/send_msg_respoonse_model.dart';



abstract class MsgRepository{

  //Auth
  NetworkResult<List<SendMsgResponseModel>> sendMsg(SendMessageRequest request, String conversationId);
  NetworkResult<CreateConversationResponseModel> createConversation(CreateConversationRequestModel request);
  NetworkResult<List<GetAdminResponseModel>> getAdmin();
  NetworkResult<List<SendMsgResponseModel>> getAllMsg(String conversationId);
}
