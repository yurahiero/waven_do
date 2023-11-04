import 'package:to_do_app/bloc/item_bloc.dart';
import 'package:to_do_app/bloc/item_event.dart';
import 'package:to_do_app/data/models/item.dart';
import 'package:to_do_app/utils/constants.dart';
import 'package:to_do_app/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

class ItemFormScreen extends StatefulWidget {
  final Item? item;
  final ItemBloc bloc;

  const ItemFormScreen({Key? key, required this.bloc, this.item})
      : super(key: key);

  @override
  State<ItemFormScreen> createState() => _ItemFormScreenState();
}

class _ItemFormScreenState extends State<ItemFormScreen> {
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _bodyController;
  bool isTextFieldFocused = false;

  @override
  void initState() {
    super.initState();

    if (widget.item != null) {
      _nameController = TextEditingController(text: widget.item!.name);
      _categoryController = TextEditingController(text: widget.item!.category);
      _bodyController = TextEditingController(text: widget.item!.body);
    } else {
      _nameController = TextEditingController();
      _categoryController = TextEditingController();
      _bodyController = TextEditingController();
    }

    _nameController.addListener(updateIsTextFieldFocused);
    _categoryController.addListener(updateIsTextFieldFocused);
    _bodyController.addListener(updateIsTextFieldFocused);
  }

  void updateIsTextFieldFocused() {
    setState(() {
      isTextFieldFocused = _nameController.text.trim().isNotEmpty ||
          _categoryController.text.trim().isNotEmpty ||
          _bodyController.text.trim().isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              iconSize: size.height * 0.045,
              icon: Visibility(
                visible: isTextFieldFocused,
                child: const Icon(
                  Icons.check,
                  color: Colors.green,
                ),
              ),
              onPressed: () {
                final itemName = _nameController.text.trim();
                final category = _categoryController.text.trim();
                final body = _bodyController.text.trim();

                if (itemName.isNotEmpty) {
                  if (widget.item != null) {
                    final updatedItem = Item(
                      id: widget.item!.id,
                      name: itemName,
                      category: category,
                      body: body,
                      createdAt: widget.item!.createdAt,
                    );
                    widget.bloc.add(UpdateItemEvent(updatedItem));
                  } else {
                    const uuid = Uuid();
                    final newItem = Item(
                      id: uuid.v4(),
                      name: itemName,
                      category: category,
                      createdAt: DateTime.now(),
                      body: body,
                    );
                    widget.bloc.add(AddItemEvent(newItem));
                  }
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: kPadding(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: size.height / 10,
              child: TextField(
                maxLength: 50,
                maxLines: 1,
                style: GoogleFonts.roboto(
                  fontSize: 25,
                  textStyle: const TextStyle(
                    letterSpacing: .5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                controller: _nameController,
                decoration: InputDecoration(
                  hintStyle: GoogleFonts.roboto(
                    fontSize: 25,
                    textStyle:
                        const TextStyle(color: Colors.grey, letterSpacing: .5),
                  ),
                  hintText: 'Título',
                  border: InputBorder.none,
                ),
              ),
            ),
            Text(formatDateTime(DateTime.now()), style: kHintTextStyle),
            SingleChildScrollView(
              child: TextField(
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  textStyle: const TextStyle(letterSpacing: .5),
                ),
                maxLines: 20,
                controller: _bodyController,
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  border: InputBorder.none,
                  hintStyle: GoogleFonts.roboto(
                    fontSize: 15,
                    textStyle:
                        const TextStyle(color: Colors.grey, letterSpacing: .5),
                  ),
                  hintText: 'Digite aqui...',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
