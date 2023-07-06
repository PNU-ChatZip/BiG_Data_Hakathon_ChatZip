import 'package:flutter/material.dart';
import 'package:notification_listener_service/notification_listener_service.dart';

class NotificationSetting extends StatelessWidget {
  const NotificationSetting({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat zip'),
      ),
      body: Center(
        child: TextButton(
          onPressed: () async {
            final res = await NotificationListenerService.requestPermission();
          },
          child: const Text("알림 권한 설정하기"),
        ),
      ),
    );
  }
}
