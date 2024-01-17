
import 'package:image_picker/image_picker.dart';

PickImage(ImageSource source) async {

  final ImagePicker _imagePicker = ImagePicker();
  XFile? file = await _imagePicker.pickImage(source: source);
  


}