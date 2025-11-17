import 'package:fluttertoast/fluttertoast.dart';

class ToastService {
    void show(String message) {
        Fluttertoast.showToast(
            msg: message,
            gravity: ToastGravity.BOTTOM,
            toastLength: Toast.LENGTH_LONG
        );
    }
}