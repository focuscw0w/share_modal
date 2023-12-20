import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Zdieľanie súborov"),
        ),
        body: const BottomSheetModal(),
      ),
    );
  }
}

class BottomSheetModal extends StatefulWidget {
  const BottomSheetModal({Key? key}) : super(key: key);

  @override
  State<BottomSheetModal> createState() => _BottomSheetModalState();
}

class _BottomSheetModalState extends State<BottomSheetModal> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Text('Otvoriť modál'),
        onPressed: () {
          showModalBottomSheet(
            isDismissible: true,
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return _buildBottomSheetContent(context);
            },
          );
        },
      ),
    );
  }

  Widget _buildBottomSheetContent(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildTopRow(),
            ),
            const Divider(
              color: Colors.black,
              thickness: 1,
            ),
            Column(
              children: [
                const SizedBox(
                  height: 14,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: _buildSection("Workspace", "OP"),
                ),
                const Divider(
                  color: Colors.black,
                  thickness: 1,
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: _buildSection("Destination", "..."),
                ),
                const Divider(
                  color: Colors.black,
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: _buildFileSection(),
                ),
              ],
            ),
            Expanded(
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: MaterialButton(
                    onPressed: () {},
                    color: Colors.blue,
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                    shape: const CircleBorder(),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      size: 24,
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopRow() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /*
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close),
          color: Colors.black,
        ),
         */
        Text(
          "Zdieľajte v spokostave",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, String value) {
    // Tu bude v spoku použitý náš multiselect
    return Column(
      children: [
        _buildSectionTitle(title),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.arrow_forward_ios),
              color: Colors.black,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFileSection() {
    // Tu bude názov zdieľaného súboru
    return const Column(children: [
      Align(
        alignment: Alignment.centerLeft,
        child: TextField(
          decoration: InputDecoration.collapsed(
            hintText: "Názov súboru",
          ),
        ),
      ),
    ]);
  }
}
