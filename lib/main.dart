import 'package:flutter/material.dart';
import 'package:mynotesapp/dbhelper.dart';
import 'package:mynotesapp/notes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbHelper.instance.initDatabase();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Notes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Note> notes = [];
  final dbHelper = DbHelper.instance;

  @override
  void initState() {
    loadNotes();
    super.initState();
  }

  void loadNotes() async {
    List<Note> mynotes = await dbHelper.fetchAllNotes();
    setState(() {
      notes = mynotes;
    });
  }

  void addNote() async {
    Note newNote = Note(
      name: "New Note",
      description: "Use a Controller",
    );
    int id = await dbHelper.insertNote(newNote);

    setState(() {
      newNote.id = id;
      notes.add(newNote);
    });
  }

  void updateNote(int index) async {
    Note updatedNote = Note(
        id: notes[index].id, name: "New Name", description: "New Description");
    await dbHelper.updateNote(updatedNote);
    setState(() {
      notes[index] = updatedNote;
    });
  }

  void deleteNote(int index) async {
    await dbHelper.deleteNote(notes[index].id!);
    setState(() {
      notes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  addNote();
                },
                icon: const Icon(
                  Icons.add,
                  size: 40,
                ))
          ],
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("My Notes"),
        ),
        body: notes.isEmpty
            ? const Center(
                child: Text("No Notes Added Yet"),
              )
            : ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(notes[index].name),
                    subtitle: Text(notes[index].description),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            deleteNote(index);
                          },
                          icon: const Icon(Icons.delete),
                        ),
                        IconButton(
                            onPressed: () {
                              updateNote(index);
                            },
                            icon: const Icon(Icons.edit))
                      ],
                    ),
                  );
                },
              ));
  }
}
