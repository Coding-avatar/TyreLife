import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _tyreCodeController = TextEditingController();
  File? _image;
  String _extractedText = '';
  final _textRecognizer = TextRecognizer();
  final imagePicker = ImagePicker();


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() async{
    _textRecognizer.close();
    super.dispose();
  }

  Future _getImageFromCamera() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.camera,imageQuality: 25);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

   Future _getImageFromGallery() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery,imageQuality: 50);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future _performTextRecognition() async {
    if (_image == null) return;

    final inputImage = InputImage.fromFile(_image!);
    final recognisedText = await _textRecognizer.processImage(inputImage);

    String extractedText = '';
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          extractedText += '${element.text} ';
        }
        extractedText += '\n';
      }
    }

    setState(() {
      _extractedText = extractedText;
    });

    _textRecognizer.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tyre Life',style: TextStyle(color: Colors.white)),backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width*.75,
                  child: TextField(controller: _tyreCodeController,autocorrect: false,decoration: const InputDecoration(border: OutlineInputBorder(),labelText: 'Search a Code'),),
                ),
                const ElevatedButton(onPressed: null,style: ButtonStyle(), child: Icon(Icons.search_rounded))
              ],
            ),
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width*.8,
                  height: MediaQuery.of(context).size.height*.6,
                  color: Colors.black12,
                  child: _image==null ? const SizedBox() :Image.file(_image!,fit: BoxFit.contain),
                ),
                _image==null ? const SizedBox() : 
                Positioned(bottom: 20,left: 100,child: ElevatedButton(onPressed: _performTextRecognition, style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue)), child: const Text('Text Search'),)),
              ],
            ) ,
            Text(_extractedText),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    ElevatedButton(onPressed: _getImageFromGallery, child: const Icon(Icons.perm_media)),
                    const Text('Gallery')
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton(onPressed: _getImageFromCamera, child: const Icon(Icons.add_a_photo)),
                    const Text('Camera')
                  ],
                )
              ],
            )
        ],),
      ),
    );
  }
}