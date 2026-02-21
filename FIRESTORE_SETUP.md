# Firestore Security Rules & Data Structure

## Overview
This document describes the Firestore security rules and data structure for backing up user progress, level, XP, and stats.

## Security Rules Location
The Firestore security rules are defined in `firestore.rules`. Deploy them using:

```bash
firebase deploy --only firestore:rules
```

## Data Structure

### Users Collection (`/users/{userId}`)

Main user document containing authentication and profile information.

**Fields:**
- `uid` (string, required): User's Firebase Auth UID
- `email` (string, required): User's email address
- `emailLower` (string, optional): Lowercase email for queries
- `displayName` (string, optional): User's display name
- `phoneNumber` (string, optional): User's phone number
- `photoURL` (string, optional): User's profile photo URL
- `emailVerified` (boolean, optional): Email verification status
- `createdAt` (timestamp, required): Account creation timestamp
- `updatedAt` (timestamp, required): Last update timestamp

### User Score Subcollection (`/users/{userId}/score/{scoreId}`)

Stores the user's current level and XP progress.

**Fields:**
- `totalXp` (int, required): Total XP accumulated by the user
- `level` (int, required): Current user level (derived from totalXp)
- `xpIntoLevel` (int, optional): XP progress within current level
- `xpNextLevel` (int, optional): Total XP required for next level

**Example:**
```json
{
  "totalXp": 1500,
  "level": 3,
  "xpIntoLevel": 500,
  "xpNextLevel": 2000
}
```

### User XP Entries Subcollection (`/users/{userId}/xpEntries/{entryId}`)

Stores individual XP award entries for history tracking.

**Fields:**
- `id` (string, required): Unique entry ID (must match document ID)
- `at` (timestamp, required): When XP was awarded
- `mode` (string, required): Mode where XP was earned (e.g., "practice", "challenge")
- `amount` (int, required): XP amount awarded
- `synced` (boolean, required): Whether entry has been synced to cloud
- `sessionId` (string, optional): Associated session ID

**Example:**
```json
{
  "id": "uuid-here",
  "at": "2024-01-15T10:30:00Z",
  "mode": "practice",
  "amount": 50,
  "synced": true,
  "sessionId": "session-uuid"
}
```

### User Stats Subcollection (`/users/{userId}/stats/{statId}`)

Stores user statistics and achievements.

**Fields:**
- `wpm` (number, optional): Words per minute average
- `accuracy` (number, optional): Accuracy percentage
- `totalSessions` (int, optional): Total practice sessions
- `totalWordsTyped` (int, optional): Total words typed
- `bestWpm` (number, optional): Best WPM achieved
- `bestAccuracy` (number, optional): Best accuracy achieved
- `streak` (int, optional): Current streak count
- `lastActive` (timestamp, optional): Last active timestamp
- `updatedAt` (timestamp, required): Last update timestamp

**Example:**
```json
{
  "wpm": 45.5,
  "accuracy": 92.3,
  "totalSessions": 150,
  "totalWordsTyped": 50000,
  "bestWpm": 65.0,
  "bestAccuracy": 98.5,
  "streak": 7,
  "lastActive": "2024-01-15T10:30:00Z",
  "updatedAt": "2024-01-15T10:30:00Z"
}
```

### User Sessions Subcollection (`/users/{userId}/sessions/{sessionId}`)

Stores individual typing session data.

**Fields:**
- `sessionId` (string, required): Unique session ID
- `mode` (string, required): Session mode (e.g., "practice", "challenge")
- `difficulty` (string, optional): Difficulty level
- `startedAt` (timestamp, required): Session start time
- `endedAt` (timestamp, optional): Session end time
- `typed` (int, optional): Total characters typed
- `correct` (int, optional): Correct characters
- `errors` (int, optional): Error count
- `elapsedMs` (int, optional): Session duration in milliseconds
- `wpm` (number, optional): Words per minute for this session
- `accuracy` (number, optional): Accuracy for this session

**Example:**
```json
{
  "sessionId": "session-uuid",
  "mode": "practice",
  "difficulty": "medium",
  "startedAt": "2024-01-15T10:00:00Z",
  "endedAt": "2024-01-15T10:05:00Z",
  "typed": 250,
  "correct": 230,
  "errors": 20,
  "elapsedMs": 300000,
  "wpm": 46.0,
  "accuracy": 92.0
}
```

## Security Rules Summary

1. **Authentication Required**: All operations require user authentication
2. **Ownership Validation**: Users can only access their own data
3. **Data Validation**: Rules validate data structure before allowing writes
4. **Immutable Fields**: Critical fields like `uid` and `email` cannot be changed after creation
5. **XP Entry Protection**: XP entry amounts cannot be modified after creation (only `synced` flag can be updated)

## Usage in App

### Syncing User Score to Firestore

```dart
// After awarding XP, sync to Firestore
final scoreController = ref.read(scoreControllerProvider.notifier);
await scoreController.award(amount: 50, mode: 'practice');

// Sync score to Firestore
final user = FirebaseAuth.instance.currentUser;
if (user != null) {
  await Firestore.instance
    .collection('users')
    .doc(user.uid)
    .collection('score')
    .doc('current')
    .set({
      'totalXp': scoreController.state.totalXp,
      'level': scoreController.state.level,
      'xpIntoLevel': scoreController.state.xpIntoLevel,
      'xpNextLevel': scoreController.state.xpNextLevel,
    }, SetOptions(merge: true));
}
```

### Syncing XP Entries

```dart
// After creating an XP entry locally, sync to Firestore
final entry = ScoreEntry(
  id: uuid,
  at: DateTime.now(),
  mode: 'practice',
  amount: 50,
  synced: false,
);

// Save locally first
await localRepo.addEntryToDB(entry);

// Then sync to Firestore
await Firestore.instance
  .collection('users')
  .doc(user.uid)
  .collection('xpEntries')
  .doc(entry.id)
  .set(entry.toJson());

// Mark as synced
await localRepo.markSynced([entry.id]);
```

### Syncing User Stats

```dart
// Update user stats after session completion
await Firestore.instance
  .collection('users')
  .doc(user.uid)
  .collection('stats')
  .doc('current')
  .set({
    'wpm': averageWpm,
    'accuracy': averageAccuracy,
    'totalSessions': totalSessions + 1,
    'totalWordsTyped': totalWordsTyped + wordsTyped,
    'bestWpm': max(bestWpm, currentWpm),
    'bestAccuracy': max(bestAccuracy, currentAccuracy),
    'streak': currentStreak,
    'lastActive': FieldValue.serverTimestamp(),
    'updatedAt': FieldValue.serverTimestamp(),
  }, SetOptions(merge: true));
```

## Deployment

1. **Install Firebase CLI** (if not already installed):
   ```bash
   npm install -g firebase-tools
   ```

2. **Login to Firebase**:
   ```bash
   firebase login
   ```

3. **Initialize Firebase** (if not already done):
   ```bash
   firebase init firestore
   ```

4. **Deploy Rules**:
   ```bash
   firebase deploy --only firestore:rules
   ```

## Testing Rules

Use the Firebase Console to test your rules:
1. Go to Firebase Console > Firestore Database > Rules
2. Click "Rules Playground"
3. Test various scenarios (read, write, update, delete)

## Notes

- Rules use `request.auth.uid` to verify ownership
- Server timestamps are used for `createdAt` and `updatedAt` to prevent client-side tampering
- XP entry amounts are immutable to prevent cheating
- All collections require authentication
- Users can only access their own data
