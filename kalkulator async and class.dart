import 'dart:async';

class Kalkulator {
  Future<double> tambah(double a, double) async {
    return await _simuLateDelay(a + b);
  }
    Future<double> kurang(double a, double) async {
    return await _simuLateDelay(a - b);
  }
    Future<double> kali(double a, double) async {
    return await _simuLateDelay(a * b);
  }
    Future<double> bagi(double a, double) async {
      if (b == 0) {
        throw Exception("Pembagian dengan nol tidak diperbolehkan");
      }
    return await _simuLateDelay(a / b);
  }
    Future<double> _simuLateDelay(double result) async {
    await future.Delayed(Duration(seconds:1));
    return result;
  }
}

void main() async {
  Kalkulator kalkulator = Kalkulator();

  try {
    print ('5 + 2 = ${await,kalkulator.tambah(5, 2)}');
    print ('5 - 2 = ${await,kalkulator.kurang(5, 2)}');
    print ('5 * 2 = ${await,kalkulator.kali(5, 2)}');
    print ('5 / 2 = ${await,kalkulator.bagi(5, 2)}');
  } catch (e) {
    print("Error: $e")
  }
}
