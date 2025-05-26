// services/api_link.dart
// ignore: unused_import

const String linkServerName = "http://10.0.2.2/Maxall_php";

//const String linkSignUp = "$linkServerName/auth/signup.php";
const String linkLogin =
    "$linkServerName/auth/login.php"; // Corrected from signup.php to login.php
const String linkregister = "$linkServerName/auth/register.php";
const String linkcategories = "$linkServerName/download/get_categories.php";
// 🔹 استخدم 10.0.2.2 للمحاكي أو IP الجهاز الحقيقي
const String linkproduct = "$linkServerName/download/get_products.php";
const String linkget_products_by_category =
    "$linkServerName/download/get_products_by_category.php?category_id=";
const String linkprofile = "$linkServerName/auth/profile.php";
const String linkprofile_id = "$linkServerName/auth/profile.php?user_id=";
const String linkSearch = "$linkServerName/search_products.php?query=";
const String linkGetFavorites = "$linkServerName/upload/favorites.php";
const String linkToggleFavorite = "$linkServerName/upload/toggle_favorite.php";
const String linkCheckFavorite = "$linkServerName/upload/check.php?user_id=&product_id=";
