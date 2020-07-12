import 'dart:core';
import 'dart:math';
class DiceRoller {
  static int roll({faces, dices = 1, modifier = 0}) {
    Random rand = new Random();
    int result = 0;
    for (int i = 0; i < dices; i++) {
      result += 1 + rand.nextInt(faces);
    }
    return result + modifier;
  }

  static double binomial(int n, int k) {
    double result = 1;
    k = [k, n - k].reduce(max);
    int multiply = n;
    int divide = n - k;

    while (multiply > k || divide > 1) {
      if (multiply > k) {
        result *= multiply;
        multiply--;
      }
      if (divide > 1) {
        result /= divide;
        divide--;
      }
    }
    return result;
  }


  static double probability(int value, int faces, int dice) {
    Map<int, double> memoTableProbabilities = new Map<int, double>();
    int key = (value << 20) | ((faces & 0x3FF) << 10) | (dice & 0x3FF);
    double result = memoTableProbabilities[key];
    if (result != null) {
      return result;
    }
    double p = 0.0;
    int iterations = ((value - dice) / faces).floor();
    for (int i = 0; i <= iterations; i++) {
      double v = binomial(dice, i) * binomial(value - faces * i - 1, dice - 1);
      if (i % 2 == 0) {
        p += v;
      } else {
        p -= v;
      }
    }
    p = 100 * p * pow(faces, -dice);
    memoTableProbabilities[key] = p;
    return p;
  }


 static double probabilityAtLeast(int value, int faces, int dice) {
    Map<int, double> memoTableProbabilitiesAtLeast = new Map<int, double>();
    int key = (value << 20) | ((faces & 0x3FF) << 10) | (dice & 0x3FF);
    double result = memoTableProbabilitiesAtLeast[key];
    if (result != null) {
      return result;
    }
    double p = 100.0;

    for (int i = dice; i < value; i++) {
      p -= probability(i, faces, dice);
    }
    memoTableProbabilitiesAtLeast[key] = p;
    return p;
  }

}