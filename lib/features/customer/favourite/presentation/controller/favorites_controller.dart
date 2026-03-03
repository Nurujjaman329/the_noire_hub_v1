import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../data/favorites_response_model.dart';
import '../../data/favorites_service.dart';


class CustomerFavoritesController extends GetxController {
  final CustomerFavoritesService _service;
  CustomerFavoritesController(this._service);

  var isLoading = false.obs;
  var isMoreLoading = false.obs;
  var favoritesList = <FavoriteItem>[].obs;

  int currentPage = 1;
  bool hasMore = true;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchFavorites();

    // Pagination listener
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        loadMore();
      }
    });
  }

  /// Initial Fetch
  Future<void> fetchFavorites() async {
    isLoading.value = true;
    currentPage = 1;

    try {
      final response = await _service.getFavorites(page: currentPage);

      if (response.data?.attributes != null) {
        favoritesList.assignAll(response.data!.attributes!.results);
        hasMore = currentPage < response.data!.attributes!.totalPages;
      }
    } catch (e) {
      debugPrint("Controller Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Load More (Pagination)
  Future<void> loadMore() async {
    if (isLoading.value || isMoreLoading.value || !hasMore) return;

    isMoreLoading.value = true;
    currentPage++;

    try {
      final response = await _service.getFavorites(page: currentPage);
      final newItems = response.data?.attributes?.results ?? [];

      if (newItems.isNotEmpty) {
        favoritesList.addAll(newItems);
        hasMore = currentPage < (response.data?.attributes?.totalPages ?? 1);
      } else {
        hasMore = false;
      }
    } catch (e) {
      currentPage--;
      debugPrint("Pagination Error: $e");
    } finally {
      isMoreLoading.value = false;
    }
  }

  /// Toggle Favorite Status
  Future<void> toggleFavorite(String itemId, String itemType) async {
    // Note: We don't set global isLoading to true to avoid flickering the whole list
    final success = await _service.toggleFavorite(itemId: itemId, itemType: itemType);

    if (success) {
      fetchFavorites(); // Refresh list to show changes
    } else {
      Get.snackbar("Error", "Failed to update favorites",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.7),
          colorText: Colors.white);
    }
  }

  /// Remove Favorite (Optimistic UI update)
  Future<void> removeFavorite(String favoriteId) async {
    // Optimistically remove from list
    final index = favoritesList.indexWhere((element) => element.id == favoriteId);
    if (index == -1) return;

    final removedItem = favoritesList[index];
    favoritesList.removeAt(index);

    final success = await _service.deleteFavorite(favoriteId);

    if (!success) {
      // Rollback if failed
      favoritesList.insert(index, removedItem);
      Get.snackbar("Error", "Could not remove from favorites");
    }
  }

  Future<void> onRefresh() async => await fetchFavorites();

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}