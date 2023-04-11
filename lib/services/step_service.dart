class StepService {
  static String loadStepManagementText(int step) {
    switch (step) {
      case 0:
        return 'Inzio';
      case 1:
        return 'Modulo con informazioni';
      case 2:
        return 'Hotel e logistica';
      case 3:
        return 'Completato';
    }
    return 'Nessuna operazione esistente';
  }

  static String loadStepCoachingTitle(int step) {
    switch (step) {
      case 0:
        return 'Inizio';
      case 1:
        return 'Primo incontro';

      case 2:
        return 'Preparazione discorso';
      case 3:
        return 'Secondo incontro';
      case 4:
        return 'Revisione';
      case 5:
        return 'Completato';
    }
    return 'Nessuna operazione esistente';
  }

  static String loadStepCoachingDescription(int step) {
    switch (step) {
      case 0:
        return 'Inizio';
      case 1:
        return 'Primo incontro con lo speaker coach e il team di TEDx';
      case 2:
        return 'Secondo Incontro con lo speaker coach e il team di TEDx';
      case 3:
        return 'Incontro di revisione finale con lo speaker coach e il team di TEDx';
    }
    return 'Nessuna operazione esistente';
  }
}
