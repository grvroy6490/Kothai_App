/// SharedPreferences keys for in-app notification feed and daily reminder time.
const String kInAppNotificationsKey = 'in_app_notifications.v1';

const String kDailyReminderHourKey = 'daily_reminder_hour.v1';
const String kDailyReminderMinuteKey = 'daily_reminder_minute.v1';

/// Evening hour for streak-at-risk local reminder (24h clock).
const int kStreakAtRiskHour = 19;
const int kStreakAtRiskMinute = 0;

/// Payload strings for routing / local notification taps.
const String kNotificationPayloadPractice = 'practice';
const String kNotificationPayloadAchievementGallery = 'achievement_gallery';
const String kNotificationPayloadStreakBoard = 'streak_board';
const String kNotificationPayloadXpMilestones = 'xp_milestones';

/// Android notification channel ids.
const String kDailyReminderChannelId = 'daily_practice_reminder';
const String kStreakChannelId = 'streak_alerts';
const String kAchievementChannelId = 'achievement_alerts';
const String kProductUpdatesChannelId = 'product_updates';

/// FCM topic for product / content announcements.
const String kFcmAnnouncementsTopic = 'announcements';

/// Notification IDs (local).
const int kDailyReminderNotificationId = 10001;
const int kStreakAtRiskNotificationId = 10002;
const int kComebackNotificationId = 10003;
const int kBadgeUnlockNotificationId = 10010;
const int kLevelUpNotificationId = 10011;
const int kRemoteForegroundNotificationId = 10020;
const int kDebugScheduleNotificationId = 10099;
