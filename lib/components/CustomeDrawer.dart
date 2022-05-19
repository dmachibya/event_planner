import 'package:flutter/material.dart';
import 'package:event_planner/utils/constants.dart';
import 'package:event_planner/utils/authentication.dart';

class CustomHomeDrawer extends StatelessWidget {
  const CustomHomeDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.grey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 4,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.grey,
                    size: 50,
                  ),
                ),
                Text("User@gmail.com"),
                const SizedBox(height: 17),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Menu',
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: Colors.grey),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 1),
                  child: Text(
                    'Value',
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Colors.grey),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            width: double.infinity,
            height: 1,
            color: Colors.grey,
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, registerRoute);
            },
            leading: const Icon(
              Icons.notes,
              color: Colors.grey,
            ),
            title: Text(
              'Lawyers',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Colors.grey),
            ),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(
              Icons.favorite,
              color: Colors.grey,
            ),
            title: Text(
              'Menu Item',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Colors.grey),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              FocusManager.instance.primaryFocus?.unfocus();
              AuthenticationHelper().signOut().then((value) => {
                    if (value == null)
                      {Navigator.pushNamed(context, loginRoute)}
                  });
              // viewModel.logoutUser();
            },
            leading: const Padding(
              padding: EdgeInsets.only(left: 2),
              child: Icon(
                Icons.logout,
                color: Colors.grey,
              ),
            ),
            title: Text(
              'Logout',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
