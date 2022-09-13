import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/profile.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  final String? data;
  const ProfileScreen({Key? key, this.data}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<List<ProfileData>>? retrieveProfile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveProfile = fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Align(
            alignment: Alignment.centerLeft, child: Text("Profile")),
        actions: [
          IconButton(
            onPressed: () =>
                PagesGenerator.goTo(context, name: "edit-user-profile"),
            icon: const Icon(
              Icons.edit,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SizedBox(
          child: Column(
            children: <Widget>[
              Container(
                height: height / 3,
                width: width,
                decoration: BoxDecoration(
                  color: fkBlueLight,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.person,
                  size: 370,
                  color: fkGreyText,
                ),
              ),
              verticalSpaceRegular,
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                    onPressed: () =>
                        PagesGenerator.goTo(context, name: "upload-image"),
                    child: const Text("Upload Image")),
              ),
              Expanded(
                  child: FutureBuilder<List<ProfileData>>(
                future: retrieveProfile,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data[index].email ?? "",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                verticalSpaceRegular,
                                Text(
                                  snapshot.data[index].username ?? "",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                verticalSpaceRegular,
                                Text(
                                  snapshot.data[index].phone ?? "",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                verticalSpaceRegular,
                                Text(
                                  "${toBeginningOfSentenceCase(snapshot.data[index].firstName ?? " ")} ${toBeginningOfSentenceCase(snapshot.data[index].lastName ?? "")}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                verticalSpaceRegular,
                              ],
                            ),
                          );
                        });
                  } else if (snapshot.hasError) {
                    return Container(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                            child: Text(
                          snapshot.error != null
                              ? "Failed to load data"
                              : "Data not available...",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: fkGreyText),
                        )));
                  }
                  return Container(
                      padding: const EdgeInsets.all(20.0),
                      margin: const EdgeInsets.only(bottom: 200),
                      child: const Center(
                          child: Text(
                        "Loading info...",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            // fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: fkGreyText),
                      )));
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
