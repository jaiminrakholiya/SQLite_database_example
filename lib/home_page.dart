import 'package:flutter/material.dart';
import 'package:database_example/data/local/db_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  List<Map<String, dynamic>> allNotes = [];
  DBHelper? dbRef;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    dbRef = DBHelper.getInstance;
    getNotes();
  }

  void getNotes() async {
    setState(() => isLoading = true);
    allNotes = await dbRef!.getAllNotes();
    setState(() => isLoading = false);
  }

  void _showUpdateDialog(Map<String, dynamic> note) {
    titleController.text = note[DBHelper.COLUMN_NOTE_TITLE];
    descController.text = note[DBHelper.COLUMN_NOTE_DESC];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: BottomSheetView(
            titleController: titleController,
            descController: descController,
            dbRef: dbRef,
            refreshNotes: getNotes,
            isUpdate: true,
            sno: note[DBHelper.COLUMN_NOTE_SNO],
          ),
        );
      },
    ).then((_) {
      titleController.clear();
      descController.clear();
    });
  }

  void _showDeleteConfirmation(int sno) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              bool success = await dbRef!.deleteNote(sno: sno);
              if (success) {
                getNotes();
                if (mounted) Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Note deleted successfully')),
                );
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'My Notes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : allNotes.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.note_rounded,
              size: 60,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No Notes Yet!',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: allNotes.length,
        itemBuilder: (_, index) {
          final note = allNotes[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              title: Text(
                note[DBHelper.COLUMN_NOTE_TITLE],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  note[DBHelper.COLUMN_NOTE_DESC],
                  style: TextStyle(
                    color: Colors.grey[600],
                    height: 1.3,
                  ),
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _showUpdateDialog(note),
                    icon: Icon(
                      Icons.edit_rounded,
                      color: Colors.blue[700],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showDeleteConfirmation(
                        note[DBHelper.COLUMN_NOTE_SNO]),
                    icon: const Icon(
                      Icons.delete_rounded,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          titleController.clear();
          descController.clear();
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: BottomSheetView(
                  titleController: titleController,
                  descController: descController,
                  dbRef: dbRef,
                  refreshNotes: getNotes,
                  isUpdate: false,
                ),
              );
            },
          );
        },
        label: const Row(
          children: [
            Icon(Icons.add),
            SizedBox(width: 8),
            Text('Add Note'),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }
}

class BottomSheetView extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController descController;
  final DBHelper? dbRef;
  final VoidCallback refreshNotes;
  final bool isUpdate;
  final int? sno;

  const BottomSheetView({
    Key? key,
    required this.titleController,
    required this.descController,
    required this.dbRef,
    required this.refreshNotes,
    this.isUpdate = false,
    this.sno,
  }) : super(key: key);

  @override
  State<BottomSheetView> createState() => _BottomSheetViewState();
}

class _BottomSheetViewState extends State<BottomSheetView> {
  String errorMsg = "";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Title
              Text(
                widget.isUpdate ? 'Update Note' : 'Add New Note',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Title Field
              TextField(
                controller: widget.titleController,
                decoration: InputDecoration(
                  hintText: "Enter title",
                  labelText: 'Title',
                  prefixIcon: const Icon(Icons.title),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Description Field
              TextField(
                controller: widget.descController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Enter description",
                  labelText: 'Description',
                  alignLabelWithHint: true,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 60),
                    child: Icon(Icons.description),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Error Message
              if (errorMsg.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    errorMsg,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () async {
                        var title = widget.titleController.text.trim();
                        var desc = widget.descController.text.trim();

                        if (title.isEmpty || desc.isEmpty) {
                          setState(() {
                            errorMsg =
                            'Please fill all the required fields';
                          });
                          return;
                        }

                        setState(() {
                          isLoading = true;
                          errorMsg = '';
                        });

                        try {
                          bool success;
                          if (widget.isUpdate) {
                            success = await widget.dbRef!.updateNote(
                              mTitle: title,
                              mDesc: desc,
                              sno: widget.sno!,
                            );
                          } else {
                            success = await widget.dbRef!.addNote(
                              mTitle: title,
                              mDesc: desc,
                            );
                          }

                          if (success) {
                            widget.refreshNotes();
                            if (mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    widget.isUpdate
                                        ? 'Note updated successfully'
                                        : 'Note added successfully',
                                  ),
                                ),
                              );
                            }
                          } else {
                            setState(() {
                              errorMsg = widget.isUpdate
                                  ? 'Failed to update note'
                                  : 'Failed to add note';
                            });
                          }
                        } finally {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : Text(
                        widget.isUpdate ? 'Update Note' : 'Add Note',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}