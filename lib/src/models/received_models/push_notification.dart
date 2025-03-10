import 'package:awesome_notifications/src/definitions.dart';
import 'package:awesome_notifications/src/models/model.dart';
import 'package:awesome_notifications/src/models/notification_button.dart';
import 'package:awesome_notifications/src/models/notification_calendar.dart';
import 'package:awesome_notifications/src/models/notification_content.dart';
import 'package:awesome_notifications/src/models/notification_interval.dart';
import 'package:awesome_notifications/src/models/notification_message.dart';
import 'package:awesome_notifications/src/models/notification_schedule.dart';

/// Reference Model to create a new notification
/// [schedule] and [actionButtons] are optional
class PushNotification extends Model {
  NotificationContent? content;
  NotificationSchedule? schedule;
  List<NotificationActionButton>? actionButtons;
  List<NotificationMessage>? messages;

  PushNotification(
      {this.content, this.schedule, this.actionButtons, this.messages});

  /// Imports data from a serializable object
  PushNotification? fromMap(Map<String, dynamic> mapData) {
    try {
      assert(mapData.containsKey('content') && mapData['content'] is Map);

      Map<String, dynamic> contentData =
          Map<String, dynamic>.from(mapData[PUSH_NOTIFICATION_CONTENT]);

      this.content = NotificationContent().fromMap(contentData);
      if (content == null) return null;

      this.content!.validate();

      if (mapData.containsKey(PUSH_NOTIFICATION_SCHEDULE)) {
        Map<String, dynamic> scheduleData =
            Map<String, dynamic>.from(mapData[PUSH_NOTIFICATION_SCHEDULE]);

        if (scheduleData.containsKey(NOTIFICATION_SCHEDULE_INTERVAL)) {
          schedule = NotificationInterval().fromMap(scheduleData);
        } else {
          schedule = NotificationCalendar().fromMap(scheduleData);
        }
        schedule?.validate();
      }

      if (mapData.containsKey(PUSH_NOTIFICATION_BUTTONS)) {
        actionButtons = [];
        List<dynamic> actionButtonsData =
            List<dynamic>.from(mapData[PUSH_NOTIFICATION_BUTTONS]);

        for (dynamic buttonData in actionButtonsData) {
          Map<String, dynamic> actionButtonData =
              Map<String, dynamic>.from(buttonData);

          NotificationActionButton button = NotificationActionButton()
              .fromMap(actionButtonData) as NotificationActionButton;
          button.validate();

          actionButtons!.add(button);
        }
        assert(actionButtons!.isNotEmpty);
      }

      if (mapData.containsKey(PUSH_NOTIFICATION_MESSAGES)) {
        messages = [];
        List<dynamic> messagesData =
            List<dynamic>.from(mapData[PUSH_NOTIFICATION_MESSAGES]);

        for (dynamic messageData in messagesData) {
          Map<String, dynamic> messageDataMap =
              Map<String, dynamic>.from(messageData);

          NotificationMessage message = NotificationMessage()
              .fromMap(messageDataMap) as NotificationMessage;
          message.validate();
          messages!.add(message);
        }
        assert(messages!.isNotEmpty);
      }
    } catch (e) {
      return null;
    }

    return this;
  }

  /// Exports all content into a serializable object
  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> actionButtonsData = [];
    if (actionButtons != null) {
      for (NotificationActionButton button in actionButtons!) {
        Map<String, dynamic> data = button.toMap();
        if (data.isNotEmpty) actionButtonsData.add(data);
      }
    }

    List<Map<String, dynamic>> messagesData = [];
    if (messages != null) {
      for (NotificationMessage message in messages!) {
        Map<String, dynamic> data = message.toMap();
        if (data.isNotEmpty) messagesData.add(data);
      }
    }

    return {
      'content': content?.toMap() ?? {},
      'schedule': schedule?.toMap() ?? {},
      'actionButtons': actionButtonsData.isEmpty ? null : actionButtonsData,
      'messages': messagesData.isEmpty ? null : messagesData,
    };
  }

  @override

  /// Validates if the models has all the requirements to be considerated valid
  void validate() {
    assert(content != null);
  }
}
