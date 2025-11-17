

import 'package:kothai_app/features/badges/data/model/badge_entity.dart';
import 'package:kothai_app/features/badges/domain/enums/badge_type_enum.dart';

class BadgeRepository {
    static final allBadges = <BadgeEntity>[
        // BRONZE BADGES
        BadgeEntity(
            id: "first_keystroke",
            name: "First Keystroke",
            tier: "Bronze",
            type: BadgeType.general,
            condition: "Type your first Tamil character",
            toastMessage:
            "🔥 You’ve typed your first Tamil word — the journey begins!",
            imagePath: "assets/badges/bronze/First_Keystroke.png"
        ),
        BadgeEntity(
            id: "first_challenge_completed",
            name: "First Challenge Completed",
            tier: "Bronze",
            type: BadgeType.general,
            condition: "Complete your first daily challenge",
            toastMessage:
            '🏁 “Challenge completed! You’ve officially started your Kothai journey.”',
            imagePath: "assets/badges/bronze/First_Challenge_Completed.png"
        ),
        BadgeEntity(
            id: "new_learner",
            name: "New Learner",
            tier: "Bronze",
            type: BadgeType.xp,
            condition: "Reach 100 XP total",
            toastMessage:
            '📘 “100 XP achieved — steady fingers make fluent words!',
            imagePath: "assets/badges/bronze/New_Learner.png"
        ),
        BadgeEntity(
            id: "day_one_done",
            name: "Day One Done",
            tier: "Bronze",
            type: BadgeType.streak,
            condition: "Maintain a 1-day streak",
            toastMessage:
            '🌞 “Day 1 complete — small steps toward big fluency!”',
            imagePath: "assets/badges/bronze/Day_One_Done.png"
        ),
        BadgeEntity(
            id: "comeback_kid",
            name: "Comeback Kid",
            tier: "Bronze",
            type: BadgeType.general,
            condition: "Return after 3+ days of inactivity",
            toastMessage:
            '🔄 “Welcome back! Every restart is a step forward.”',
            imagePath: "assets/badges/bronze/Comeback_Kid.png"
        ),

        // SILVER BADGES
        BadgeEntity(
            id: "focused_student",
            name: "Focused Student",
            tier: "Silver",
            type: BadgeType.xp,
            condition: "Reach 500 XP total",
            toastMessage:
            '🎯 “Focused and steady! You’ve reached 500 XP.”',
            imagePath: "assets/badges/silver/Focused_Student.png"
        ),
        BadgeEntity(
            id: "accuracy_hunter",
            name: "Accuracy Hunter",
            tier: "Silver",
            type: BadgeType.general,
            condition: "Achieve 100% accuracy",
            toastMessage:
            '🧩 “Perfect shot! You nailed 100% accuracy.”',
            imagePath: "assets/badges/silver/Rectangle.png"
        ),
        BadgeEntity(
            id: "speed_sprinter",
            name: "Speed Sprinter",
            tier: "Silver",
            type: BadgeType.general,
            condition: "Reach ≥ 50 WPM",
            toastMessage:
            '⚡ “Lightning fast! You’ve crossed 50 WPM.”',
            imagePath: "assets/badges/silver/Rectangle_1.png"
        ),
        BadgeEntity(
            id: "perfectionist",
            name: "Perfectionist",
            tier: "Silver",
            type: BadgeType.general,
            condition: "Maintain 98%+ accuracy for 5 sessions",
            toastMessage:
            '✅ “Consistent and clean! You’re a certified Perfectionist.”',
            imagePath: "assets/badges/silver/Rectangle_3.png"
        ),
        BadgeEntity(
            id: "weekend_warrior",
            name: "Weekend Warrior",
            tier: "Silver",
            type: BadgeType.streak,
            condition: "Maintain a 7-day streak",
            toastMessage:
            '🔥 “7 days straight! You’re officially a Weekend Warrior.”',
            imagePath: "assets/badges/silver/Rectangle_2.png"
        ),

        // GOLD BADGES
        BadgeEntity(
            id: "typing_enthusiast",
            name: "Typing Enthusiast",
            tier: "Gold",
            type: BadgeType.xp,
            condition: "Reach 1,000 XP total",
            toastMessage:
            '✨ “1,000 XP! You’re officially a Typing Enthusiast.”',
            imagePath: "assets/badges/gold/Typing_Enthusiast.png"
        ),
        BadgeEntity(
            id: "speed_scholar",
            name: "Speed Scholar",
            tier: "Gold",
            type: BadgeType.xp,
            condition: "Reach 2,500 XP",
            toastMessage:
            '⚡ “You’ve joined the elite Speed Scholars club!”',
            imagePath: "assets/badges/gold/Speed_Scholar.png"
        ),
        BadgeEntity(
            id: "fortnight_fighter",
            name: "Fortnight Fighter",
            tier: "Gold",
            type: BadgeType.streak,
            condition: "Maintain a 14-day streak",
            toastMessage:
            '🕓 “14 days of typing! You’re a Fortnight Fighter.”',
            imagePath: "assets/badges/gold/Fortnight_Fighter.png"
        ),
        BadgeEntity(
            id: "weekend_warrior",
            name: "Month Marathoner",
            tier: "Gold",
            type: BadgeType.streak,
            condition: "Maintain a 30-day streak",
            toastMessage:
            '🗓️ “30 days non-stop — true dedication! Month Marathoner earned.”',
            imagePath: "assets/badges/gold/Month_Marathoner.png"
        ),
        BadgeEntity(
            id: "perfection_pro",
            name: "Perfection Pro",
            tier: "Gold",
            type: BadgeType.general,
            condition: "Maintain 95%+ accuracy for 10 sessions",
            toastMessage:
            '💎 “Perfection mastered! You’re now a Perfection Pro.”',
            imagePath: "assets/badges/gold/Perfection_Pro.png"
        ),

        // PLATINUM BADGES
        BadgeEntity(
            id: "master_of_keys",
            name: "Master of Keys",
            tier: "Platinum",
            type: BadgeType.xp,
            condition: "Reach 5,000 XP total",
            toastMessage:
            '🧠 “Key mastery achieved! You’re a true Master of Keys.”',
            imagePath: "assets/badges/platinum/Master_of_Keys.png"
        ),
        BadgeEntity(
            id: "tamil_titan",
            name: "Tamil Titan",
            tier: "Platinum",
            type: BadgeType.xp,
            condition: "Reach 10,000 XP total",
            toastMessage:
            '🏆 “Unmatched power — you’ve become the Tamil Titan!”',
            imagePath: "assets/badges/platinum/Tamil_Titan.png"
        ),
        BadgeEntity(
            id: "unbreakable",
            name: "Unbreakable",
            tier: "Platinum",
            type: BadgeType.streak,
            condition: "Maintain 60-day streak",
            toastMessage:
            '🔗 “60 days strong! You’re officially Unbreakable.”',
            imagePath: "assets/badges/platinum/Unbreakable.png"
        ),
        BadgeEntity(
            id: "legendary_learner",
            name: "Legendary Learner",
            tier: "Platinum",
            type: BadgeType.streak,
            condition: "Maintain 100-day streak",
            toastMessage:
            '💫 “100 days of brilliance — you’re a Legendary Learner!”',
            imagePath: "assets/badges/platinum/Legendary_Learner.png"
        ),
        BadgeEntity(
            id: "marathon_typist",
            name: "Marathon Typist",
            tier: "Platinum",
            type: BadgeType.general,
            condition: "Complete 10 practice sessions within a single day",
            toastMessage:
            '💪 “Incredible focus! You’ve completed 10 sessions today"',
            imagePath: "assets/badges/platinum/Marathon_Typist.png"
        )

    ];
}