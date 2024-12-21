import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whisper/components/custom_access_button.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/keys/call_page_keys.dart';
import 'package:whisper/services/calls_service.dart';
import 'package:whisper/services/shared_preferences.dart';
class CallStateManager {
  static final CallStateManager _instance = CallStateManager._internal();

  bool isInCall = false;

  factory CallStateManager() {
    return _instance;
  }

  CallStateManager._internal();
}



class Call extends StatefulWidget {
  Call();

  static const id = '/callPage';

  @override
  State<Call> createState() => _CallState();
}

class _CallState extends State<Call> {
  int? _remoteUid;
  bool _localUserJoined = false;
  bool _isMuted = false;
  bool someoneElseJoined = false;
  late RtcEngine _engine;

  @override
  void dispose() {
    super.dispose();
    _dispose();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    print("args: $args");

    await initAgora(args['token'], args['chatId']);
    CallStateManager().isInCall = true;
  }

  @override
  @pragma("vm:entry-point")
  void initState() {
    super.initState();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  Future<void> initAgora(String token, String chatId) async {
    print("TOKEN: $token");
    print("chat ID: $chatId");
    int? userId = await getId();
    // Retrieve microphone permission
    await [Permission.microphone].request();

    // Create the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: '7e7c547af0cc4c089b3472dff17acce5',
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            someoneElseJoined = true;
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    // Set client role for audio-only
    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

    // Enable audio only
    await _engine.enableAudio();
    print("BEFORE THE CALL");
    // Join the channel
    await _engine.joinChannel(
      token: token,
      channelId: chatId,
      uid: userId!,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: firstNeutralColor,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _remoteAudio(),
            SizedBox(
              height: 20,
            ),
            CustomAccessButton(
              key: Key(CallPageKeys.muteButton),
              label: _isMuted ? 'Unmute' : 'Mute',
              onPressed: () {
                _toggleMute();
              },
            ),
            SizedBox(
              height: 20,
            ),
            CustomAccessButton(
              key: Key(CallPageKeys.endCallButton),
              label: "End Call",
              onPressed: () async {
                await _endCall();
              },
            ),
            // ElevatedButton(
            //   onPressed: _endCall,
            //   child: const Text('End Call'),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _remoteAudio() {
    if (_remoteUid != null) {
      return Text(
        'Remote user $_remoteUid is speaking...',
        textAlign: TextAlign.center,
        style: TextStyle(color: secondNeutralColor),
      );
    } else if (_localUserJoined) {
      return const Text(
        'Waiting for remote user to join...',
        textAlign: TextAlign.center,
        style: TextStyle(color: secondNeutralColor),
      );
    } else {
      return const Text(
        'Wait while connecting you',
        textAlign: TextAlign.center,
        style: TextStyle(color: secondNeutralColor),
      );
    }
  }

  @pragma("vm:entry-point")
  static Future<void> onActionNotificationMethod(ReceivedAction action) async {
    if (action.buttonKeyPressed == 'Reject') {
      print("Call Rejected");
      await AwesomeNotifications().cancel(123);
    } else if (action.buttonKeyPressed == 'Accept') {
      print("Call Accepted");
    }
  }

  void _toggleMute() async {
    setState(() {
      _isMuted = !_isMuted;
    });

    if (_isMuted) {
      await _engine.muteLocalAudioStream(true);
    } else {
      await _engine.muteLocalAudioStream(false);
    }
  }

  Future<void> _endCall() async {
    await _dispose();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    RegExp regex = RegExp(r'-(\d+)');
    Match? match = regex.firstMatch(args['chatId']);
    int chatId = int.parse(match!.group(1)!);
    if (someoneElseJoined) {
      await CallsService.leaveCall(chatId, "JOINED", context);
    } else {
      await CallsService.leaveCall(chatId, "CANCELED", context);
    }
    setState(() {
      _localUserJoined = false;
      _remoteUid = null;
    });
    CallStateManager().isInCall = false;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Call ended")),
    );
  }
}
