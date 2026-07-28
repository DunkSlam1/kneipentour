import '../models/achievement.dart';
import '../../bars/models/bar.dart';

class AchievementDefinitions {
  static List<Achievement> visitedBarAchievements(int totalBars) {
    return [
      Achievement(
        id: 'visited_1',
        title: 'Erste Runde',
        description: 'Besuche deine erste Kneipe.',
        icon: '1',
        category: AchievementCategory.progress,
        requiredValue: 1,
      ),

      Achievement(
        id: 'visited_5',
        title: 'Stadtneuling',
        description: 'Besuche 5 verschiedene Kneipen.',
        icon: '5',
        category: AchievementCategory.progress,
        requiredValue: 5,
      ),

      Achievement(
        id: 'visited_10',
        title: 'Kneipenanfänger',
        description: 'Besuche 10 verschiedene Kneipen.',
        icon: '10',
        category: AchievementCategory.progress,
        requiredValue: 10,
      ),

      Achievement(
        id: 'visited_15',
        title: 'Stammgast',
        description: 'Besuche 15 verschiedene Kneipen.',
        icon: '15',
        category: AchievementCategory.progress,
        requiredValue: 15,
      ),

      Achievement(
        id: 'visited_20',
        title: 'Kneipenkenner',
        description: 'Besuche 20 verschiedene Kneipen.',
        icon: '20',
        category: AchievementCategory.progress,
        requiredValue: 20,
      ),

      Achievement(
        id: 'visited_25',
        title: 'Barhopper',
        description: 'Besuche 25 verschiedene Kneipen.',
        icon: '25',
        category: AchievementCategory.progress,
        requiredValue: 25,
      ),

      Achievement(
        id: 'visited_30',
        title: 'Thekenprofi',
        description: 'Besuche 30 verschiedene Kneipen.',
        icon: '30',
        category: AchievementCategory.progress,
        requiredValue: 30,
      ),

      Achievement(
        id: 'visited_35',
        title: 'Nachtschwärmer',
        description: 'Besuche 35 verschiedene Kneipen.',
        icon: '35',
        category: AchievementCategory.progress,
        requiredValue: 35,
      ),

      Achievement(
        id: 'visited_40',
        title: 'Studentenlegende',
        description: 'Besuche 40 verschiedene Kneipen.',
        icon: '40',
        category: AchievementCategory.progress,
        requiredValue: 40,
      ),

      Achievement(
        id: 'visited_all',
        title: 'Kneipenlegende',
        description: 'Besuche alle Kneipen.',
        icon: '🏆',
        category: AchievementCategory.progress,
        requiredValue: totalBars,
      ),
    ];
  }

  static List<Achievement> categoryAchievements(List<Bar> bars) {
    final achievements = <Achievement>[];

    final categories = [
      (
        type: BarType.pub,
        id: 'all_pubs',
        title: 'Kneipenkenner',
        description: 'Besuche alle klassischen Kneipen.',
        icon: '🍺',
      ),
      (
        type: BarType.bar,
        id: 'all_bars',
        title: 'Cocktailkenner',
        description: 'Besuche alle Bars und Cocktail-Locations.',
        icon: '🍸',
      ),
      (
        type: BarType.sportsbar,
        id: 'all_sportsbars',
        title: 'Spieltagsprofi',
        description: 'Besuche alle Sportsbars.',
        icon: '⚽',
      ),
      (
        type: BarType.winebar,
        id: 'all_winebars',
        title: 'Weinentdecker',
        description: 'Besuche alle Weinbars.',
        icon: '🍷',
      ),
    ];

    for (final category in categories) {
      final categoryBars = bars
          .where((bar) => bar.type == category.type)
          .toList();

      achievements.add(
        Achievement(
          id: category.id,
          title: category.title,
          description: category.description,
          icon: category.icon,
          requiredValue: categoryBars.length,
          currentValue: categoryBars.where((bar) => bar.visited).length,
          category: AchievementCategory.explorer,
        ),
      );
    }

    return achievements;
  }

  static List<Achievement> personalAchievements(List<Bar> bars) {
    final achievements = <Achievement>[];

    final ratedBars = bars.where((bar) => bar.rating > 0).length;

    final favorites = bars.where((bar) => bar.favorite).length;

    final visitedBars = bars
        .where((bar) => bar.visited && bar.visitedAt != null)
        .toList();

    // ⭐ Erste Einschätzung

    achievements.add(
      Achievement(
        id: 'first_rating',
        title: 'Erste Einschätzung',
        description: 'Bewerte deine erste Kneipe.',
        icon: '⭐',
        category: AchievementCategory.collector,
        requiredValue: 1,
        currentValue: ratedBars,
      ),
    );

    // ⚖️ Kritischer Gast

    final ratings = bars
        .where((bar) => bar.rating > 0)
        .map((bar) => bar.rating)
        .toSet()
        .length;

    achievements.add(
      Achievement(
        id: 'critical_guest',
        title: 'Kritischer Gast',
        description: 'Nutze drei verschiedene Bewertungen.',
        icon: '⚖️',
        category: AchievementCategory.collector,
        requiredValue: 3,
        currentValue: ratings,
      ),
    );

    // ❤️ Favoriten

    achievements.add(
      Achievement(
        id: 'first_favorite',
        title: 'Erster Favorit',
        description: 'Markiere deine erste Lieblingskneipe.',
        icon: '❤️',
        category: AchievementCategory.collector,
        requiredValue: 1,
        currentValue: favorites,
      ),
    );

    achievements.add(
      Achievement(
        id: 'favorite_collector',
        title: 'Stammplatz',
        description: 'Sammle fünf Lieblingskneipen.',
        icon: '👑',
        category: AchievementCategory.collector,
        requiredValue: 5,
        currentValue: favorites,
      ),
    );

    // 🌙 Zeit-Erfolge

    int nightVisits = 0;
    int earlyVisits = 0;
    int weekendVisits = 0;

    for (final bar in visitedBars) {
      final date = bar.visitedAt!;

      // vor 20 Uhr
      if (date.hour < 20) {
        earlyVisits++;
      }

      // nach Mitternacht
      if (date.hour < 5) {
        nightVisits++;
      }

      // Freitag oder Samstag
      if (date.weekday == DateTime.friday ||
          date.weekday == DateTime.saturday) {
        weekendVisits++;
      }
    }

    achievements.add(
      Achievement(
        id: 'early_start',
        title: 'Frühstarter',
        description: 'Besuche eine Kneipe vor 20 Uhr.',
        icon: '🌅',
        category: AchievementCategory.special,
        requiredValue: 1,
        currentValue: earlyVisits,
      ),
    );

    achievements.add(
      Achievement(
        id: 'night_owl',
        title: 'Nachtschwärmer',
        description: 'Besuche eine Kneipe nach Mitternacht.',
        icon: '🌙',
        category: AchievementCategory.special,
        requiredValue: 1,
        currentValue: nightVisits,
      ),
    );

    achievements.add(
      Achievement(
        id: 'weekend_guest',
        title: 'Wochenendgast',
        description: 'Besuche eine Kneipe am Wochenende.',
        icon: '📆',
        category: AchievementCategory.special,
        requiredValue: 1,
        currentValue: weekendVisits,
      ),
    );

    return achievements;
  }
}
