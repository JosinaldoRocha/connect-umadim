import 'package:connect_umadim_app/app/presentation/event/provider/event_provider.dart';
import 'package:connect_umadim_app/app/presentation/event/views/widgets/event_item_widget.dart';
import 'package:connect_umadim_app/app/presentation/event/views/widgets/next_event_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/style/app_text.dart';

class NextEventWidget extends ConsumerStatefulWidget {
  const NextEventWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NextEventWidgetState();
}

class _NextEventWidgetState extends ConsumerState<NextEventWidget> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(getNextEventProvider.notifier).load(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(getNextEventProvider);

    return state.maybeWhen(
      loadSuccess: (data) => data.isEmpty
          ? Container()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    top: 12,
                    bottom: 4,
                  ),
                  child: Text(
                    data.length > 1 ? 'Próximos eventos' : 'Próximo evento',
                    style: AppText.text().titleSmall!.copyWith(fontSize: 14),
                  ),
                ),
                data.length == 1
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: EventItemWidget(
                          event: data[0],
                          isHorizontalScrolling: false,
                        ),
                      )
                    : SizedBox(
                        height: 204,
                        child: NextEventListWidget(events: data),
                      ),
              ],
            ),
      orElse: () => Container(),
    );
  }
}
