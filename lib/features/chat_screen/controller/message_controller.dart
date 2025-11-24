import 'package:danielabake/core/base/base_controller.dart';
import 'package:danielabake/core/network/constants/key_constants.dart';
import 'package:danielabake/core/network/models/refresh_token_request_model.dart';
import 'package:danielabake/core/network/socket_client.dart';
import 'package:danielabake/features/auth/controller/remember_me_controller.dart';
import 'package:danielabake/features/auth/models/request/create_new_password_request_model.dart';
import 'package:danielabake/features/auth/models/request/forgot_password_request_model.dart';
import 'package:danielabake/features/auth/models/request/verify_otp_request_model.dart';
import 'package:danielabake/features/auth/screens/create_new_password_screen.dart';
import 'package:danielabake/features/auth/screens/verify_code_screen.dart';
import 'package:danielabake/features/chat_screen/models/request/create_conversation_request_model.dart';
import 'package:danielabake/features/chat_screen/models/request/send_msg_request_model.dart';
import 'package:danielabake/features/chat_screen/models/response/create_conversation_response_model.dart';
import 'package:danielabake/features/chat_screen/models/response/get_admin_response_model.dart';
import 'package:danielabake/features/chat_screen/repositories/msg_repository.dart';
import 'package:danielabake/features/splash_screen/screens/first_screen.dart';
import 'package:danielabake/navigation_menu.dart';
import 'package:flutx_core/core/debug_print.dart';
import 'package:danielabake/features/auth/repositories/auth_repository.dart';
import 'package:get/get.dart';
import '../../../core/network/services/auth_storage_service.dart';
import '../../../core/network/services/secure_store_services.dart';
import '../models/response/send_msg_respoonse_model.dart';


class MessageController extends BaseController {
  final _msgRepo = Get.find<MsgRepository>();
  final Rxn<GetAdminResponseModel> admin = Rxn<GetAdminResponseModel>();
  // final Rxn<CreateConversationResponseModel> conversation = Rxn<CreateConversationResponseModel>();
  final SecureStoreServices _secureStoreServices = SecureStoreServices();

  SocketClient _client = SocketClient();

  final RxList<SendMsgResponseModel> messages = RxList<SendMsgResponseModel>();

  String conversationId = "";
  String userId = '';
  //final Rxn<CreateConversationResponseModel> conversation = Rxn<GetAdminResponseModel>();

  Future<void> socketInitChat() async {
    _client.emit("join", conversationId);

    _client.on("message", (data) {
      DPrint.log("Raw socket message received: $data");

      try {
        // Socket.IO usually sends the plain message object directly
        // But sometimes it can be inside a "data" array — we handle both!
        Map<String, dynamic> messageJson;

        if (data is Map<String, dynamic>) {
          // Case 1: Direct message object (most common in real-time)
          messageJson = data;

          // Case 2: Wrapped like REST response { success: true, data: [...] }
          if (data['data'] is List && data['data'].isNotEmpty) {
            messageJson = data['data'][0];
          } else if (data['data'] is Map) {
            messageJson = data['data'];
          }
        } else if (data is List && data.isNotEmpty) {
          messageJson = data[0];
        } else {
          DPrint.error("Unexpected socket message format: $data");
          return;
        }

        // Safely extract sender & receiver with null checks
        final senderMap = messageJson['sender'] as Map<String, dynamic>?;
        final receiverMap = messageJson['receiver'] as Map<String, dynamic>?;

        final senderId = senderMap?['_id']?.toString() ?? '';
        final receiverId = receiverMap?['_id']?.toString() ?? '';

        final newMessage = SendMsgResponseModel(
          id: messageJson['_id']?.toString() ?? '',
          conversation: messageJson['conversation']?.toString() ?? conversationId,
          sender: senderId,
          receiver: receiverId,
          text: messageJson['text']?.toString() ?? '',
          createdAt: DateTime.tryParse(messageJson['createdAt']?.toString() ?? '') ?? DateTime.now(),
          updatedAt: DateTime.tryParse(messageJson['updatedAt']?.toString() ?? '') ?? DateTime.now(),
          v: messageJson['__v'] ?? 0,
        );

        // Avoid duplicates
        if (!messages.any((m) => m.id == newMessage.id ||
            (m.text == newMessage.text &&
                m.sender == newMessage.sender &&
                m.createdAt.difference(newMessage.createdAt).abs().inSeconds < 5))) {
          messages.add(newMessage);
        }

      } catch (e, stack) {
        DPrint.error("Error parsing socket message: $e\n$stack");
      }
    });
  }

  Future<void> createConversation(String adminId) async {
    final request = CreateConversationRequestModel(userId: adminId);

    final result = await _msgRepo.createConversation(request);

    result.fold(
          (fail) {
        setError(fail.message);
        DPrint.log("Register success result : ${fail.message}");
        setLoading(false);
      },
          (success) {
            conversationId = success.data.id;

            _secureStoreServices.storeData(KeyConstants.conversationId, conversationId.toString());
        DPrint.log("Register success result : ${success.data.id}");
      },
    );
  }

  Future<String> getConversationId(String adminId) async {
    conversationId = await _secureStoreServices.retrieveData(KeyConstants.conversationId) ?? '';

    if(conversationId.isEmpty) {
      await createConversation(adminId);
    }
    return conversationId;
  }


  Future<void> getAllMessage(String conversationId) async {

    final result = await _msgRepo.getAllMsg(conversationId);

    result.fold(
          (fail) {
        setError(fail.message);
        DPrint.log("Register success result : ${fail.message}");
        setLoading(false);
      },
          (success) {
            messages.assignAll(success.data);
            DPrint.log("Last message : ${success.data.last.text}");
      },
    );
  }

  Future<void> sendMsg(String text, String adminId, String conversationId) async {
    final request = SendMessageRequest(text: text, receiverId: adminId);

    userId = await _secureStoreServices.retrieveData(KeyConstants.userId) ?? "";



    final result = await _msgRepo.sendMsg(request, conversationId);

    final optimisticMessage = SendMsgResponseModel(conversation: conversationId, sender: userId, receiver: adminId, text: text, id: "", createdAt: DateTime.now() , updatedAt: DateTime.now(), v: 1);

    result.fold(
          (fail) {
        setError(fail.message);
        DPrint.log("Register success result : ${fail.message}");
        setLoading(false);
      },
          (success) {
            final conversationId = success.data.first.id;
            messages.add(optimisticMessage);

            DPrint.log("Register success result : ${success.data.first.id}");
      },
    );
  }



  Future<void> getAdmin() async {

    final result = await _msgRepo.getAdmin();

    result.fold(
          (fail) {
        setError(fail.message);
        DPrint.log('Fetch Cart failed');
      },
          (success) {
        admin.value = success.data.first;
        DPrint.log(success.message);
      },
    );
  }
}
