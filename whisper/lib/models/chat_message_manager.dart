import 'package:flutter/material.dart';
import 'package:whisper/cubit/messages_state.dart';
import 'package:whisper/cubit/messages_state.dart';
import 'package:whisper/models/chat_message.dart';

class ChatMessageManager {
  List<ChatMessage> messages = [];

  // Add a message
  void addMessage(ChatMessage message) {
    messages.insert(0, message);
  }

  // Add a list of messages
  void addMessages(List<ChatMessage> newMessages) {
    messages.addAll(newMessages);
    messages = messages.reversed.toList();
  }

  // Get a message by ID
  ChatMessage? getMessageById(int id) {
    return messages.firstWhere((message) => message.id == id);
  }

  // Remove a message by ID
  void removeMessagesByIds(List<int> ids) {
    messages.removeWhere((msg) => ids.contains(msg.id));
  }

  // Edit a message's content by ID
  bool editMessageContentById(int id, String newContent) {
    ChatMessage? message = getMessageById(id);
    if (message != null) {
      message.content = newContent;
      return true;
    }
    return false;
  }

  @override
  String toString() {
    return 'ChatMessageManager(messages: $messages)';
  }

  void handleMessagesState(
      BuildContext context,
      MessagesState state,
      int chatId,
      String userName,
      int senderId,
      Function handleCancelReply,
      Function handleCancelEditing,
      Function handleEditingMessage) {
    if (state is MessagesLoading) {
      print("loading");
    } else if (state is MessageFetchedSuccessfully) {
      addMessages(state.messages);
    } else if (state is MessageFetchedWrong) {
      print("error");
    } else if (state is MessageSent) {
      if (state.message.chatId == chatId) {
        addMessage(state.message);
      }
    } else if (state is MessageReceived) {
      print("received");
      handleCancelReply();
      DateTime receivedTime = state.message.time!.toLocal();
      int index = messages.indexWhere((msg) => msg.sentAt == receivedTime);
      if (state.message.chatId == chatId) {
        if (index != -1) {
          messages[index] = state.message;
        } else {
          addMessage(state.message);
        }
      }
    } else if (state is MessagesDeletedSuccessfully) {
      removeMessagesByIds(state.deletedIds);
    } else if (state is MessagesDeleteError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting message: ${state.error}')),
      );
    } else if (state is MessageEditing) {
      handleEditingMessage(state.content, state.messageId);
      handleCancelReply();
    } else if (state is MessageEdited) {
      editMessageContentById(state.messageId, state.content);
      handleCancelEditing();
    }
  }
}
