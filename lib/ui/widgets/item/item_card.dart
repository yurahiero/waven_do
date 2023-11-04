import 'package:auto_size_text/auto_size_text.dart';
import 'package:to_do_app/ui/screens/item_form_screen.dart';
import 'package:to_do_app/ui/widgets/confirm_dialog.dart';
import 'package:to_do_app/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do_app/bloc/item_bloc.dart';
import 'package:to_do_app/data/models/item.dart';
import 'package:to_do_app/utils/constants.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  final ItemBloc bloc;
  const ItemCard({
    required this.item,
    required this.bloc,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: size.height * 0.20,
      width: size.width,
      child: Slidable(
        key: ValueKey(item.id),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              borderRadius:
                  const BorderRadius.horizontal(right: Radius.circular(30)),
              onPressed: (context) => deleteItemConfirm(item, context, bloc),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Deletar',
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: const BorderRadius.horizontal(left: Radius.zero),
          ),
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        item.name,
                        style: kTitleTextStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 13),
                        height: size.height * 0.07,
                        width: size.width / 1.5,
                        child: AutoSizeText(
                          item.body.isEmpty ? 'Sem texto' : item.body,
                          textAlign: TextAlign.left,
                          style:
                              TextStyle(fontSize: 18, color: Colors.grey[500]),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                      ),
                      AutoSizeText(formatDateTime(item.createdAt!),
                          style: kHintTextStyle)
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Icon(
                    Icons.menu,
                    color: Colors.grey[350],
                  ),
                ),
              ],
            ),
            onTap: () =>
                openScreen(context, ItemFormScreen(bloc: bloc, item: item)),
          ),
        ),
      ),
    );
  }
}
