import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

import 'package:lichess_mobile/src/common/http.dart';
import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/features/auth/data/auth_repository.dart';
import 'package:lichess_mobile/src/features/user/ui/perf_stats_screen.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import '../../../utils.dart';
import '../../auth/data/fake_auth_repository.dart';

class MockClient extends Mock implements http.Client {}

class MockApiClient extends Mock implements ApiClient {}

class MockLogger extends Mock implements Logger {}

void main() {
  final mockClient = MockClient();
  final mockLogger = MockLogger();

  final uriString = '$kLichessHost/api/user/$testUserId/perf/${testPerf.name}';

  setUpAll(() {
    when(() => mockClient.get(Uri.parse(uriString)))
        .thenAnswer((_) => mockResponse(userPerfStatsResponse, 200));
  });

  group('PerfStatsScreen', () {
    testWidgets('meets accessibility guidelines', (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();

      final app =
          await buildTestApp(tester, home: Consumer(builder: (context, ref, _) {
        return const PerfStatsScreen(
            username: testUserId, perf: testPerf, loggedInUser: null);
      }));

      await tester.pumpWidget(ProviderScope(overrides: [
        // Don't need a logged in user to test this screen.
        authRepositoryProvider.overrideWithValue(FakeAuthRepository(null)),
        apiClientProvider.overrideWithValue(ApiClient(mockLogger, mockClient)),
      ], child: app));

      // wait for auth state and perf stats
      await tester.pump(const Duration(milliseconds: 50));

      await meetsTapTargetGuideline(tester);
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

      if (debugDefaultTargetPlatformOverride == TargetPlatform.android) {
        await expectLater(tester, meetsGuideline(textContrastGuideline));
      }
      handle.dispose();
    }, variant: kPlatformVariant);

    testWidgets('screen loads, required stats are shown',
        (WidgetTester tester) async {
      final app =
          await buildTestApp(tester, home: Consumer(builder: (context, ref, _) {
        return const PerfStatsScreen(
            username: testUserId, perf: testPerf, loggedInUser: null);
      }));

      await tester.pumpWidget(ProviderScope(overrides: [
        // Don't need a logged in user to test this screen.
        authRepositoryProvider.overrideWithValue(FakeAuthRepository(null)),
        apiClientProvider.overrideWithValue(ApiClient(mockLogger, mockClient)),
      ], child: app));

      // wait for auth state and perf stats
      await tester.pump(const Duration(milliseconds: 50));

      final requiredStatsValues = [
        '1500.42', // Rating
        '50.24', // Deviation
        '5', // Total games
        '20', // Progression in last 12 games
        '0', // Berserked games
        '0', // Tournament games
        '3', // Rated games
        '2', // Won games
        '2', // Lost games
        '1', // Drawn games
        '1' // Disconnections
      ];

      for (final val in requiredStatsValues) {
        expect(find.widgetWithText(PlatformCard, val), findsAtLeastNWidgets(1));
      }
    }, variant: kPlatformVariant);
  });
}

const testUserId = 'fakeUsername';
const testPerf = Perf.rapid;
const userPerfStatsResponse = '''
{
  "user": {
    "name": "testOpponentName"
  },
  "perf": {
    "glicko": {
      "rating": 1500.42,
      "deviation": 50.24,
      "provisional": false
    },
    "nb": 5,
    "progress": 20
  },
  "rank": 1000,
  "percentile": 50.0,
  "stat": {
    "count": {
      "berserk": 0,
      "win": 2,
      "all": 5,
      "seconds": 1000,
      "opAvg": 1400.63,
      "draw": 1,
      "tour": 0,
      "disconnects": 1,
      "rated": 3,
      "loss": 2
    },
    "resultStreak": {
      "win": {
        "cur": {
          "v": 9,
          "from": {
            "at": "2023-01-12T03:36:37.842Z",
            "gameId": "ABcDeFgH"
          },
          "to": {
            "at": "2023-01-20T16:25:56.430Z",
            "gameId": "ABcDeFgH"
          }
        },
        "max": {
          "v": 9,
          "from": {
            "at": "2023-01-12T03:36:37.842Z",
            "gameId": "ABcDeFgH"
          },
          "to": {
            "at": "2023-01-20T16:25:56.430Z",
            "gameId": "ABcDeFgH"
          }
        }
      },
      "loss": {
        "cur": {
          "v": 0
        },
        "max": {
          "v": 3,
          "from": {
            "at": "2023-01-11T05:57:14.547Z",
            "gameId": "ABcDeFgH"
          },
          "to": {
            "at": "2023-01-11T06:52:05.350Z",
            "gameId": "ABcDeFgH"
          }
        }
      }
    },
    "lowest": {
      "int": 1336,
      "at": "2022-11-26T20:09:57.711Z",
      "gameId": "ABcDeFgH"
    },
    "_id": "danteculaciati/6",
    "worstLosses": {
      "results": [
        {
          "opRating": 1300,
          "opId": {
            "id": "testOpponent",
            "name": "testOpponentName",
            "title": null
          },
          "at": "2022-12-22T06:08:21.870Z",
          "gameId": "ABcDeFgH"
        },
        {
          "opRating": 1303,
          "opId": {
            "id": "testOpponent",
            "name": "testOpponentName",
            "title": null
          },
          "at": "2022-11-09T13:54:12.015Z",
          "gameId": "ABcDeFgH"
        },
        {
          "opRating": 1309,
          "opId": {
            "id": "testOpponent",
            "name": "testOpponentName",
            "title": null
          },
          "at": "2022-11-18T03:12:53.063Z",
          "gameId": "ABcDeFgH"
        },
        {
          "opRating": 1310,
          "opId": {
            "id": "testOpponent",
            "name": "testOpponentName",
            "title": null
          },
          "at": "2022-11-26T20:09:57.711Z",
          "gameId": "ABcDeFgH"
        },
        {
          "opRating": 1321,
          "opId": {
            "id": "testOpponent",
            "name": "testOpponentName",
            "title": null
          },
          "at": "2023-01-04T22:14:53.251Z",
          "gameId": "ABcDeFgH"
        }
      ]
    },
    "perfType": {
      "key": "rapid",
      "name": "testOpponentName"
    },
    "bestWins": {
      "results": [
        {
          "opRating": 1553,
          "opId": {
            "id": "testOpponent",
            "name": "testOpponentName",
            "title": null
          },
          "at": "2023-01-12T04:40:28.644Z",
          "gameId": "ABcDeFgH"
        },
        {
          "opRating": 1532,
          "opId": {
            "id": "testOpponent",
            "name": "testOpponentName",
            "title": null
          },
          "at": "2023-01-10T07:24:30.636Z",
          "gameId": "ABcDeFgH"
        },
        {
          "opRating": 1509,
          "opId": {
            "id": "testOpponent",
            "name": "testOpponentName",
            "title": null
          },
          "at": "2023-01-12T05:10:05.648Z",
          "gameId": "ABcDeFgH"
        },
        {
          "opRating": 1496,
          "opId": {
            "id": "testOpponent",
            "name": "testOpponentName",
            "title": null
          },
          "at": "2023-01-08T20:48:46.087Z",
          "gameId": "ABcDeFgH"
        },
        {
          "opRating": 1496,
          "opId": {
            "id": "testOpponent",
            "name": "testOpponentName",
            "title": null
          },
          "at": "2023-01-12T03:51:59.617Z",
          "gameId": "ABcDeFgH"
        }
      ]
    },
    "userId": {
      "id": "$testUserId",
      "name": "$testUserId",
      "title": null
    },
    "playStreak": {
      "nb": {
        "cur": {
          "v": 0
        },
        "max": {
          "v": 7,
          "from": {
            "at": "2023-01-12T03:28:45.629Z",
            "gameId": "ABcDeFgH"
          },
          "to": {
            "at": "2023-01-12T05:10:05.648Z",
            "gameId": "ABcDeFgH"
          }
        }
      },
      "time": {
        "cur": {
          "v": 0
        },
        "max": {
          "v": 5237,
          "from": {
            "at": "2023-01-11T05:37:11.306Z",
            "gameId": "ABcDeFgH"
          },
          "to": {
            "at": "2023-01-11T07:23:22.095Z",
            "gameId": "ABcDeFgH"
          }
        }
      },
      "lastDate": "2023-01-20T16:25:56.430Z"
    },
    "highest": {
      "int": 1515,
      "at": "2023-01-20T16:25:56.430Z",
      "gameId": "ABcDeFgH"
    }
  }
}
''';
