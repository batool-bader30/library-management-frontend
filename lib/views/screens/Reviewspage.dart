import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_management_web_front/core/constants/colors.dart';
import 'package:library_management_web_front/core/utils/responsive.dart';
import 'package:provider/provider.dart';
import '../../controllers/Review_controller.dart';
import '../../data/models/responses/reviews.dart';

class ReviewsScreen extends StatefulWidget {
  final int bookid;
  const ReviewsScreen({super.key, required this.bookid});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ReviewController>().fetchReviewsByBookId(widget.bookid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final reviewController = context.watch<ReviewController>();
    final reviewsToShow = reviewController.reviews;
    bool isMobile = Responsive.isMobile(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.darkbackground,
      body: Padding(
        padding: EdgeInsets.symmetric( horizontal:isMobile?20: 180.w, vertical:isMobile?20: 60.h),
        child:isMobile
        ?  Column(
          crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // --- النصف الأول: عرض المراجعات ---
                          SizedBox(height: 30.w),
          
                          Expanded(flex: 1, child: _buildAddRatingSection(reviewController)),
          
              Divider(
                color: AppColors.lightbackground.withOpacity(0.1),
                thickness: 1,
              ),
              SizedBox(height: 10.w),
          
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "What Readers Say",
                      style: GoogleFonts.inriaSerif(
                        fontSize:isMobile?18: 28.sp,
                        color: AppColors.lightbackground,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15.h),
                    _buildHeaderRating(reviewsToShow),
                    SizedBox(height: 30.h),
                    Expanded(
                      child: reviewController.isLoading && reviewsToShow.isEmpty
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.lightbackground,
                              ),
                            )
                          : _buildReviewsList(reviewsToShow),
                    ),
                  ],
                ),
              ),
          
                        ],
          
        )
        :Row(
          children: [
            // --- النصف الأول: عرض المراجعات ---
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "What Readers Say",
                    style: GoogleFonts.inriaSerif(
                      fontSize: 28.sp,
                      color: AppColors.lightbackground,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  _buildHeaderRating(reviewsToShow),
                  SizedBox(height: 30.h),
                  Expanded(
                    child: reviewController.isLoading && reviewsToShow.isEmpty
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.lightbackground,
                            ),
                          )
                        : _buildReviewsList(reviewsToShow),
                  ),
                ],
              ),
            ),

            SizedBox(width: 50.w),
            VerticalDivider(
              color: AppColors.lightbackground.withOpacity(0.1),
              thickness: 1,
            ),
            SizedBox(width: 50.w),

            // --- النصف الثاني: إضافة تقييم ---
            Expanded(flex: 1, child: _buildAddRatingSection(reviewController)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRating(List<ReviewsModel> reviews) {
    double averageRating = reviews.isNotEmpty
        ? reviews.fold(0.0, (sum, item) => sum + (item.rating ?? 0)) /
              reviews.length
        : 0.0;

    return Row(
      children: [
        Text(
          averageRating.toStringAsFixed(1),
          style: TextStyle(
            color: AppColors.lightbackground,
            fontSize: 32.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 15.w),
        _buildStarsIndicator(averageRating, size: 24.sp),
        SizedBox(width: 10.w),
        Text(
          "(${reviews.length} reviews)",
          style: TextStyle(color: Colors.white30, fontSize: 14.sp),
        ),
      ],
    );
  }

  Widget _buildReviewsList(List<ReviewsModel> reviews) {
    if (reviews.isEmpty) {
      return Center(
        child: Text(
          "No reviews yet. Be the first to review!",
          style: TextStyle(color: Colors.white30, fontSize: 16.sp),
        ),
      );
    }
    return ListView.builder(
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final item = reviews[index];
        return _buildSimpleReviewLine(
          item.username ?? "Loading...",
          item.comment ?? "",
          (item.rating ?? 0).toInt(),
        );
      },
    );
  }

  Widget _buildAddRatingSection(ReviewController controller) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Share Your Experience",
          style: GoogleFonts.inriaSerif(
            fontSize: 24.sp,
            color: AppColors.lightbackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 25.h),
        TextField(
          controller: controller.commentController,
          maxLines: 3,
          style: const TextStyle(color: AppColors.lightbackground),
          decoration: InputDecoration(
            hintText: "Write your thoughts about the book...",
            hintStyle: TextStyle(color: Colors.white30, fontSize: 14.sp),
            filled: true,
            fillColor: AppColors.lightbackground.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.all(20.r),
          ),
        ),
        SizedBox(height: 20.h),
        _buildInteractiveStars(controller),
        SizedBox(height: 40.h),
        _buildSubmitButton(controller),
      ],
    );
  }

  Widget _buildSubmitButton(ReviewController controller) {
    return Center(
      child: GestureDetector(
        onTap: controller.isLoading
            ? null
            : () async {
                bool success = await controller.submitReview(widget.bookid);
                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Review submitted!"),
                      backgroundColor: Color.fromARGB(255, 61, 41, 1),
                    ),
                  );
                } else if (!success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(controller.errorMessage),
                      backgroundColor: const Color.fromARGB(255, 67, 35, 1),
                    ),
                  );
                }
              },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 15.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: AppColors.lightbackground.withOpacity(0.1),
            border: Border.all(color: Colors.white12),
          ),
          child: controller.isLoading
              ? SizedBox(
                  height: 20.h,
                  width: 20.h,
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Submit Review",
                      style: GoogleFonts.inriaSerif(
                        color: AppColors.lightbackground,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Icon(
                      Icons.send,
                      color: AppColors.lightbackground,
                      size: 18.sp,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildStarsIndicator(double rating, {double? size}) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor() ? Icons.star : Icons.star_border,
          color: const Color(0xFFC1A181),
          size: size ?? 18.sp,
        );
      }),
    );
  }

  Widget _buildInteractiveStars(ReviewController controller) {
    return RatingBar.builder(
      initialRating: controller.currentRating.toDouble(),
      minRating: 1,
      itemCount: 5,
      unratedColor: Colors.white10,
      itemBuilder: (context, _) =>
          const Icon(Icons.star, color: AppColors.lightbackground),
      onRatingUpdate: (rating) => controller.currentRating = rating.toInt(),
    );
  }

  Widget _buildSimpleReviewLine(String userName, String comment, int rating) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                userName,
                style: GoogleFonts.inriaSerif(
                  color: AppColors.lightbackground,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
              _buildStarsIndicator(rating.toDouble()),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            comment,
            style: GoogleFonts.inriaSerif(
              color: Colors.white70,
              fontSize: 14.sp,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
