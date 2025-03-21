void main(){
  print("kalkulator sederhana");
  print("1. Penjumlahan");
  print("2. Pengurangan");
  print("3. perkalian")

  stdout.write("Pilih operasi(1-4)");
  int pilihan =
  int.parse(stdin.readLineSync()!);

  stdout.write("masukkan angka pertama:");
  double angka1 = double.parse(stdinreadLineSync()!);

    stdout.write("masukkan angka kedua:");
  double angka2 = double.parse(stdinreadLineSync()!);

  switch (pilihan){
    case 1:
      print("$angka1 + $angka2 = $ {angka1 + Angka2}");
      break;
    case 2:
      print("$angka1 - $angka2 = $ {angka1 - Angka2}");
      break;
    case 3:
      print("$angka1 * $angka2 = $ {angka1 * Angka2}");
      break;
    case 4:
      if (angka2 != 0) {print("$angka1 / $angka2 = $ {angka1 / Angka2}"):
      } else {
        print("Error: Pilihan Pembagian dengan nol!");
      }
      break;
      default:
        print("Error : Pilihan operasi tidak valid!");
  }

}
