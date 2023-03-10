import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_tasks_app/screens/counter/counter_screen.dart';
import 'package:flutter_tasks_app/screens/recycle_bin/recycle_bin_screen.dart';
import 'package:flutter_tasks_app/screens/tasks_screen/tasks_screen.dart';
import 'package:flutter_tasks_app/widgets/dialog/custom_dialog.dart';

import '../../blocs/bloc_exports.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Text(FirebaseAuth.instance.currentUser?.email ?? ''),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    BlocBuilder<CounterBloc, CounterState>(
                      builder: (context, state) {
                        return ListTile(
                          onTap: () => Navigator.of(context).pushReplacementNamed(CounterScreen.routeName),
                          leading: const Icon(Icons.timer),
                          title: const Text('Counter'),
                          trailing: Text(state.counterValue.toString()),
                        );
                      },
                    ),
                    const Divider(),
                    BlocBuilder<TasksBloc, TasksState>(
                      builder: (context, state) {
                        return ListTile(
                          onTap: () => Navigator.of(context).pushReplacementNamed(TasksScreen.routeName),
                          leading: const Icon(Icons.folder_special),
                          title: const Text('My Tasks'),
                          trailing: Text(state.allTasks.length.toString()),
                        );
                      },
                    ),
                    const Divider(),
                    BlocBuilder<TasksBloc, TasksState>(
                      builder: (context, state) {
                        return ListTile(
                          onTap: () => Navigator.of(context).pushReplacementNamed(RecycleBinScreen.routeName),
                          leading: const Icon(Icons.delete),
                          title: const Text('Bin'),
                          trailing: Text(state.removedTasks.length.toString()),
                        );
                      },
                    ),
                    const Divider(),
                    BlocBuilder<UseMaterialThreeBloc, UseMaterialThreeState>(
                      builder: (context, state) {
                        return ListTile(
                          title: Text('Material ${state.useMaterialThree ? '3' : '2'} '),
                          trailing: Switch(
                            value: state.useMaterialThree,
                            onChanged: (_) {
                              context.read<UseMaterialThreeBloc>().add(UseMaterialThreeToggleEvent());
                              Phoenix.rebirth(context);
                            },
                          ),
                        );
                      },
                    ),
                    BlocBuilder<UseDarkThemeBloc, UseDarkThemeState>(
                      builder: (context, state) {
                        return ListTile(
                          title: Text('Switch to ${state.useDarkTheme ? 'Light' : 'Dark'} Theme'),
                          trailing: Switch(
                            value: state.useDarkTheme,
                            onChanged: (_) => context.read<UseDarkThemeBloc>().add(UseDarkThemeToggleEvent()),
                          ),
                        );
                      },
                    ),
                    BlocBuilder<ThemeColorSchemeBloc, ThemeColorSchemeState>(
                      builder: (context, state) {
                        return ListTile(
                          onTap: () async {
                            CustomDialog.showColorThemeChoice(context: context).then(
                              (colorScheme) {
                                if (colorScheme != null) {
                                  context.read<ThemeColorSchemeBloc>().add(ChangeThemeColorSchemeEvent(colorScheme: colorScheme));
                                  Phoenix.rebirth(context);
                                }
                              },
                            );
                          },
                          title: const Text('Select Color Theme'),
                          trailing: Icon(
                            Icons.circle,
                            color: state.colorScheme.scheme,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              onTap: () => context.read<AppBloc>().add(const AppEventLogOut()),
              title: const Text('Log Out'),
              leading: const Icon(Icons.logout),
            ),
            ListTile(
              onTap: () => context.read<AppBloc>().add(const AppEventDeleteAccount()),
              title: const Text('Delete Account'),
              leading: const Icon(Icons.delete_forever),
            )
          ],
        ),
      ),
    );
  }
}
