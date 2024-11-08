import 'package:cached_network_image/cached_network_image.dart';
import 'package:face/constants/colors.dart';
import 'package:face/features/home/cubit/getstudents/getmestudent_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  void initState() {
    context.read<GetmestudentCubit>().GetmeStudents(context);
    super.initState();
  }

  Future<void> _refresh() async {
    await Future.wait([
      context.read<GetmestudentCubit>().GetmeStudents(context),
    ]);
    await Future.delayed(const Duration(milliseconds: 5));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.oq,
      body: RefreshIndicator(
        backgroundColor: AppStyles.oq,
        color: Colors.teal,
        onRefresh: () => _refresh(),
        child: BlocBuilder<GetmestudentCubit, GetmestudentState>(
          builder: (context, state) {
            return state.when(
              initial: ()=> const Center(child: Text("Initial"),),
              loading: () => const Center(child: CircularProgressIndicator(color: Colors.teal)),
              success: (successState) => CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    expandedHeight: 80,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        'Total Students: ${successState.results.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      centerTitle: true,
                    ),
                    backgroundColor: Colors.teal,
                    pinned: true,
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        final student = successState.results[index];
                        return Center(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.teal.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                              gradient: const LinearGradient(
                                colors: [Colors.teal, AppStyles.yashilsifat],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.grey.shade200,
                                  child: CachedNetworkImage(

                                    imageUrl: student.searchImagePath.toString(),
                                    imageBuilder: (context, imageProvider) => Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) => const CircularProgressIndicator(color: Colors.teal,),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    student.studentName.toString(),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: successState.results.length,
                    ),
                  ),
                ],
              ),
              failure: (failureState) => Center(child: Text(" No students available")),
            );
          },
        ),
      ),
    );
  }
}
