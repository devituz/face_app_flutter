import 'package:cached_network_image/cached_network_image.dart';
import 'package:face/constants/colors.dart';
import 'package:face/constants/helpers.dart';
import 'package:face/features/home/cubit/getstudents/getmestudent_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

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
    context.read<GetmestudentCubit>().GetmeStudents(context);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.oq,
      body: RefreshIndicator(
        backgroundColor: AppStyles.myColor,
        color: AppStyles.oq,
        onRefresh: () => _refresh(),
        child: BlocBuilder<GetmestudentCubit, GetmestudentState>(
          builder: (context, state) {
            return state.when(
              initial: ()=> const Center(child: Text("Initial"),),
              loading: () => const Center(child: CircularProgressIndicator(color:AppStyles.myColor,)),
              success: (successState) => CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    expandedHeight: 80,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        'Scanned Candidates: ${successState.results.length}',
                        style:  GoogleFonts.exo2(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      centerTitle: true,
                      background: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue, AppStyles.myColor], // Gradient colors
                          ),
                        ),
                      ),
                    ),

                    backgroundColor: AppStyles.myColor,
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
                              color: AppStyles.myColor,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                              gradient: const LinearGradient(
                                colors: [Colors.blue, AppStyles.myColor,],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(width: 5),
                                Text(
                                  '${index + 1}',
                                  style:  GoogleFonts.exo2(color: Colors.white,fontSize: 20),
                                ),
                                const SizedBox(width: 13),
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.blue.shade200,
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
                                    placeholder: (context, url) => const CircularProgressIndicator(color: AppStyles.myColor,),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),
                                ),
                                const SizedBox(width: 13),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        student.studentName.toString(),
                                        style: GoogleFonts.exo2(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Text(
                                        Helpers.formatDate(student.createdAt.toString()),
                                        style: GoogleFonts.exo2(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
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
              failure: (failureState) => Center(child: Text("No candidates available",  style:  GoogleFonts.exo2(color: Colors.white,fontSize: 20),)),
            );
          },
        ),
      ),
    );
  }
}
