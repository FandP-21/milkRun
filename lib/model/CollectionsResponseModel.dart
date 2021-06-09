// To parse this JSON data, do
//
//     final collectionsResponseModel = collectionsResponseModelFromJson(jsonString);

import 'dart:convert';

CollectionsResponseModel collectionsResponseModelFromJson(String str) => CollectionsResponseModel.fromJson(json.decode(str));

String collectionsResponseModelToJson(CollectionsResponseModel data) => json.encode(data.toJson());

class CollectionsResponseModel {
  CollectionsResponseModel({
    this.collectionListings,
  });

  List<CollectionListing> collectionListings;

  factory CollectionsResponseModel.fromJson(Map<String, dynamic> json) => CollectionsResponseModel(
    collectionListings: json["collection_listings"] == null? null : List<CollectionListing>.from(json["collection_listings"].map((x) => CollectionListing.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "collection_listings": List<CollectionListing>.from(collectionListings.map((x) => x.toJson())),
  };
}

class CollectionListing {
  CollectionListing({
    this.collectionId,
    this.updatedAt,
    this.bodyHtml,
    this.defaultProductImage,
    this.handle,
    this.image,
    this.title,
    this.sortOrder,
    this.publishedAt,
  });

  int collectionId;
  DateTime updatedAt;
  String bodyHtml;
  DefaultProductImage defaultProductImage;
  String handle;
  ImageData image;
  String title;
  String sortOrder;
  DateTime publishedAt;

  factory CollectionListing.fromJson(Map<String, dynamic> json) => CollectionListing(
    collectionId: json["collection_id"] == null ? null :json["collection_id"],
    updatedAt: json["updated_at"] == null ? null :DateTime.parse(json["updated_at"]),
    bodyHtml: json["body_html"] == null ? null :json["body_html"],
    defaultProductImage: json["default_product_image"] == null ? null : DefaultProductImage.fromJson(json["default_product_image"]),
    handle: json["handle"] == null ? null : json["handle"],
    image: json["image"] == null ? null : ImageData.fromJson(json["image"]),
    title: json["title"] == null ? null : json["title"],
    sortOrder: json["sort_order"] == null ? null : json["sort_order"],
    publishedAt: json["published_at"] == null ? null : DateTime.parse(json["published_at"]),
  );

  Map<String, dynamic> toJson() => {
    "collection_id": collectionId,
    "updated_at": updatedAt.toIso8601String(),
    "body_html": bodyHtml,
    "default_product_image": defaultProductImage == null ? null : defaultProductImage.toJson(),
    "handle": handle,
    "image": image == null ? null : image.toJson(),
    "title": title,
    "sort_order": sortOrder,
    "published_at": publishedAt.toIso8601String(),
  };
}

class DefaultProductImage {
  DefaultProductImage({
    this.id,
    this.createdAt,
    this.position,
    this.updatedAt,
    this.productId,
    this.src,
    this.variantIds,
    this.width,
    this.height,
  });

  int id;
  DateTime createdAt;
  int position;
  DateTime updatedAt;
  int productId;
  String src;
  List<dynamic> variantIds;
  int width;
  int height;

  factory DefaultProductImage.fromJson(Map<String, dynamic> json) => DefaultProductImage(
    id: json["id"] == null ? null : json["id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    position: json["position"] == null ? null : json["position"],
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    productId: json["product_id"] == null ? null : json["product_id"],
    src: json["src"] == null ? null : json["src"],
    variantIds: json["variant_ids"] == null ? null : List<dynamic>.from(json["variant_ids"].map((x) => x)),
    width: json["width"] == null ? null : json["width"],
    height: json["height"] == null ? null : json["height"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_at": createdAt.toIso8601String(),
    "position": position,
    "updated_at": updatedAt.toIso8601String(),
    "product_id": productId,
    "src": src,
    "variant_ids": List<dynamic>.from(variantIds.map((x) => x)),
    "width": width,
    "height": height,
  };
}

class ImageData {
  ImageData({
    this.createdAt,
    this.src,
  });

  DateTime createdAt;
  String src;

  factory ImageData.fromJson(Map<String, dynamic> json) => ImageData(
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    src: json["src"] == null ? null : json["src"],
  );

  Map<String, dynamic> toJson() => {
    "created_at": createdAt.toIso8601String(),
    "src": src,
  };
}
