import '../models/achievement.dart';
import '../../bars/models/bar.dart';

class AchievementDefinitions {
  static List<Achievement> visitedBarAchievements(int totalBars) {
    return [
      // 1 Erste Runde
      Achievement(
        id: 'visited_1',
        title: 'Erste Runde',
        description: 'Besuche deine erste Kneipe.',
        icon: '1',
        category: AchievementCategory.progress,
        requiredValue: 1,
      ),

      // 5 Stadtneuling
      Achievement(
        id: 'visited_5',
        title: 'Stadtneuling',
        description: 'Besuche 5 verschiedene Kneipen.',
        icon: '5',
        category: AchievementCategory.progress,
        requiredValue: 5,
      ),

      // 10 Kneipenanfänger
      Achievement(
        id: 'visited_10',
        title: 'Kneipenanfänger',
        description: 'Besuche 10 verschiedene Kneipen.',
        icon: '10',
        category: AchievementCategory.progress,
        requiredValue: 10,
      ),

      // 15 Stammgast
      Achievement(
        id: 'visited_15',
        title: 'Stammgast',
        description: 'Besuche 15 verschiedene Kneipen.',
        icon: '15',
        category: AchievementCategory.progress,
        requiredValue: 15,
      ),

      // 20 Kneipenkenner
      Achievement(
        id: 'visited_20',
        title: 'Kneipenkenner',
        description: 'Besuche 20 verschiedene Kneipen.',
        icon: '20',
        category: AchievementCategory.progress,
        requiredValue: 20,
      ),

      // 25 Barhopper
      Achievement(
        id: 'visited_25',
        title: 'Barhopper',
        description: 'Besuche 25 verschiedene Kneipen.',
        icon: '25',
        category: AchievementCategory.progress,
        requiredValue: 25,
      ),

      // 30 Thekenprofi
      Achievement(
        id: 'visited_30',
        title: 'Thekenprofi',
        description: 'Besuche 30 verschiedene Kneipen.',
        icon: '30',
        category: AchievementCategory.progress,
        requiredValue: 30,
      ),

      // 35 Nachtschwärmer
      Achievement(
        id: 'visited_35',
        title: 'Nachtschwärmer',
        description: 'Besuche 35 verschiedene Kneipen.',
        icon: '35',
        category: AchievementCategory.progress,
        requiredValue: 35,
      ),

      // 40 Studentenlegende
      Achievement(
        id: 'visited_40',
        title: 'Studentenlegende',
        description: 'Besuche 40 verschiedene Kneipen.',
        icon: '40',
        category: AchievementCategory.progress,
        requiredValue: 40,
      ),

      // 🏆 Kneipenlegende
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
      // 🍺 Kneipenkenner
      (
        type: BarType.pub,
        id: 'all_pubs',
        title: 'Kneipenkenner',
        description: 'Besuche alle klassischen Kneipen.',
        icon: '🍺',
      ),

      // 🍸 Cocktailexperte
      (
        type: BarType.bar,
        id: 'all_bars',
        title: 'Cocktailexperte',
        description: 'Besuche alle Bars und Cocktail-Locations.',
        icon: '🍸',
      ),

      // ⚽ Spieltagsprofi
      (
        type: BarType.sportsbar,
        id: 'all_sportsbars',
        title: 'Spieltagsprofi',
        description: 'Besuche alle Sportsbars.',
        icon: '⚽',
      ),

      // 🍷 Weinkenner
      (
        type: BarType.winebar,
        id: 'all_winebars',
        title: 'Weinkenner',
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

    // 📝 Erfahrener Kritiker

    achievements.add(
      Achievement(
        id: 'experienced_critic',
        title: 'Erfahrener Kritiker',
        description: 'Bewerte 10 verschiedene Kneipen.',
        icon: '📝',
        category: AchievementCategory.collector,
        requiredValue: 10,
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

    // ❤️ Erster Favorit

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

    // 👑 Stammplatz
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

    // 🌅 Frühstarter

    final earlyVisits = visitedBars
        .where((bar) => bar.visitedAt!.hour < 17)
        .length;

    achievements.add(
      Achievement(
        id: 'early_start',
        title: 'Frühstarter',
        description: 'Besuche eine Kneipe vor 17 Uhr.',
        icon: '🌅',
        category: AchievementCategory.special,
        requiredValue: 1,
        currentValue: earlyVisits,
      ),
    );

    // 🌇 Feierabendbier

    final afterWorkVisits = visitedBars
        .where((bar) => bar.visitedAt!.hour >= 17)
        .length;

    achievements.add(
      Achievement(
        id: 'after_work',
        title: 'Feierabendbier',
        description: 'Besuche eine Kneipe nach 17 Uhr.',
        icon: '🌇',
        category: AchievementCategory.special,
        requiredValue: 1,
        currentValue: afterWorkVisits,
      ),
    );

    // 🌆 Sonnenuntergang

    final sunsetVisits = visitedBars
        .where((bar) => bar.visitedAt!.hour >= 21)
        .length;

    achievements.add(
      Achievement(
        id: 'sunset',
        title: 'Sonnenuntergang',
        description: 'Besuche eine Kneipe nach 21 Uhr.',
        icon: '🌆',
        category: AchievementCategory.special,
        requiredValue: 1,
        currentValue: sunsetVisits,
      ),
    );

    // 🌙 Nachtschwärmer

    final nightVisits = visitedBars
        .where((bar) => bar.visitedAt!.hour < 5)
        .length;

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

    // 🍺 Feierabend

    final weekdayVisits = visitedBars.where((bar) {
      final day = bar.visitedAt!.weekday;

      return day >= DateTime.monday && day <= DateTime.thursday;
    }).length;

    achievements.add(
      Achievement(
        id: 'weekday_guest',
        title: 'Feierabend',
        description: 'Besuche eine Kneipe von Montag bis Donnerstag.',
        icon: '🍺',
        category: AchievementCategory.special,
        requiredValue: 1,
        currentValue: weekdayVisits,
      ),
    );

    // 📆 Wochenendgast

    final weekendVisits = visitedBars.where((bar) {
      final day = bar.visitedAt!.weekday;

      return day == DateTime.friday || day == DateTime.saturday;
    }).length;

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
