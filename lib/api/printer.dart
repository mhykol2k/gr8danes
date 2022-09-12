import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';

class Printer {
  late final NetworkPrinter printer;
  NetworkPrinter get print => printer;

  Future<int> connectPrinter() async {
    final CapabilityProfile profile = await CapabilityProfile.load();
    final PaperSize paper = PaperSize.mm80;
    printer = NetworkPrinter(paper, profile);
    final PosPrintResult r = await printer.connect('10.51.1.100', port: 9100);

    if (r.msg != 'Success') return 0;
    return 1;
  }

  void disconnect() {
    printer.disconnect();
  }
}