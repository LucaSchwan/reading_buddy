import 'package:reading_buddy/models/user_stats.dart';

class StatsService {
  
  double newAvg(UserStats stats, int add, bool week, bool pages) {
    double avg;
    int time;
    int newTime;

    if(week && pages) {
      avg = stats.pagesPerWeek;
    } else if(!week && pages) {
      avg = stats.pagesPerDay;
    } else if(week && !pages) {
      avg = stats.booksPerWeek;
    }
    
    // TODO time getting logic

    return (time * avg + add) / time + newTime;
  }

}
