// To parse this JSON data, do
//
//     final allProductResponseModel = allProductResponseModelFromJson(jsonString);

import 'dart:convert';

AllProductResponseModel allProductResponseModelFromJson(String str) => AllProductResponseModel.fromJson(json.decode(str));

String allProductResponseModelToJson(AllProductResponseModel data) => json.encode(data.toJson());

class AllProductResponseModel {
  AllProductResponseModel({
    this.products,
  });

  List<Product> products;

  factory AllProductResponseModel.fromJson(Map<String, dynamic> json) => AllProductResponseModel(
    products: json["products"]!=null? List<Product>.from(json["products"].map((x) => Product.fromJson(x))):null,
  );

  Map<String, dynamic> toJson() => {
    "products": List<dynamic>.from(products.map((x) => x.toJson())),
  };
}

class Product {
  Product({
    this.id,
    this.title,
    this.bodyHtml,
    this.vendor,
    this.productType,
    this.createdAt,
    this.handle,
    this.updatedAt,
    this.publishedAt,
    this.templateSuffix,
    this.status,
    this.publishedScope,
    this.tags,
    this.adminGraphqlApiId,
    this.variants,
    this.options,
    this.images,
    this.image,
  });

  int id;
  String title;
  String bodyHtml;
  String vendor;
  String productType;
  DateTime createdAt;
  String handle;
  DateTime updatedAt;
  DateTime publishedAt;
  String templateSuffix;
  String status;
  String publishedScope;
  String tags;
  String adminGraphqlApiId;
  List<Variant> variants;
  List<Option> options;
  List<dynamic> images;
  dynamic image;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"] == null ? null : json["id"],
    title: json["title"] == null ? null : json["title"],
    bodyHtml: json["body_html"] == null ? null : json["body_html"],
    vendor: json["vendor"] == null ? null : json["vendor"],
    productType: json["product_type"] == null ? null : json["product_type"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    handle: json["handle"] == null ? null : json["handle"],
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    publishedAt: json["published_at"] == null ? null : DateTime.parse(json["published_at"]),
    templateSuffix: json["template_suffix"] == null ? null : json["template_suffix"],
    status: json["status"] == null ? null : json["status"],
    publishedScope: json["published_scope"] == null ? null : json["published_scope"],
    tags: json["tags"] == null ? null : json["tags"],
    adminGraphqlApiId: json["admin_graphql_api_id"] == null ? null : json["admin_graphql_api_id"],
    variants: json["variants"] == null ? null : List<Variant>.from(json["variants"].map((x) => Variant.fromJson(x))),
    options: json["options"] == null ? null : List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
    images: json["images"] == null ? null : List<dynamic>.from(json["images"].map((x) => x)),
    image: json["image"] == null ? null : json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "body_html": bodyHtml,
    "vendor": vendor,
    "product_type": productType,
    "created_at": createdAt.toIso8601String(),
    "handle": handle,
    "updated_at": updatedAt.toIso8601String(),
    "published_at": publishedAt.toIso8601String(),
    "template_suffix": templateSuffix == null ? null : templateSuffix,
    "status": status,
    "published_scope": publishedScope,
    "tags": tags,
    "admin_graphql_api_id": adminGraphqlApiId,
    "variants": List<dynamic>.from(variants.map((x) => x.toJson())),
    "options": List<dynamic>.from(options.map((x) => x.toJson())),
    "images": List<dynamic>.from(images.map((x) => x)),
    "image": image,
  };
}

class Option {
  Option({
    this.id,
    this.productId,
    this.name,
    this.position,
    this.values,
  });

  int id;
  int productId;
  String name;
  int position;
  List<String> values;

  factory Option.fromJson(Map<String, dynamic> json) => Option(
    id:  json["id"] == null ? null : json["id"],
    productId:  json["product_id"] == null ? null : json["product_id"],
    name:  json["name"] == null ? null : json["name"],
    position:  json["position"] == null ? null : json["position"],
    values:  json["values"] == null ? null : List<String>.from(json["values"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_id": productId,
    "name": name,
    "position": position,
    "values": List<dynamic>.from(values.map((x) => x)),
  };
}

class Variant {
  Variant({
    this.id,
    this.productId,
    this.title,
    this.price,
    this.sku,
    this.position,
    this.inventoryPolicy,
    this.compareAtPrice,
    this.fulfillmentService,
    this.inventoryManagement,
    this.option1,
    this.option2,
    this.option3,
    this.createdAt,
    this.updatedAt,
    this.taxable,
    this.barcode,
    this.grams,
    this.imageId,
    this.weight,
    this.weightUnit,
    this.inventoryItemId,
    this.inventoryQuantity,
    this.oldInventoryQuantity,
    this.requiresShipping,
    this.adminGraphqlApiId,
  });

  int id;
  int productId;
  String title;
  String price;
  String sku;
  int position;
  String inventoryPolicy;
  dynamic compareAtPrice;
  String fulfillmentService;
  String inventoryManagement;
  String option1;
  dynamic option2;
  dynamic option3;
  DateTime createdAt;
  DateTime updatedAt;
  bool taxable;
  String barcode;
  int grams;
  dynamic imageId;
  int weight;
  String weightUnit;
  int inventoryItemId;
  int inventoryQuantity;
  int oldInventoryQuantity;
  bool requiresShipping;
  String adminGraphqlApiId;

  factory Variant.fromJson(Map<String, dynamic> json) => Variant(
    id: json["id"] == null ? null : json["id"],
    productId: json["product_id"] == null ? null : json["product_id"],
    title: json["title"] == null ? null : json["title"],
    price: json["price"] == null ? null : json["price"],
    sku: json["sku"] == null ? null : json["sku"],
    position: json["position"] == null ? null : json["position"],
    inventoryPolicy: json["inventory_policy"] == null ? null : json["inventory_policy"],
    compareAtPrice: json["compare_at_price"] == null ? null : json["compare_at_price"],
    fulfillmentService: json["fulfillment_service"] == null ? null : json["fulfillment_service"],
    inventoryManagement: json["inventory_management"] == null ? null : json["inventory_management"],
    option1: json["option1"] == null ? null : json["option1"],
    option2: json["option2"] == null ? null : json["option2"],
    option3: json["option3"] == null ? null : json["option3"],
    createdAt: DateTime.parse(json["created_at"]) == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]) == null ? null : DateTime.parse(json["updated_at"]),
    taxable: json["taxable"] == null ? null : json["taxable"],
    barcode: json["barcode"] == null ? null : json["barcode"],
    grams: json["grams"] == null ? null : json["grams"],
    imageId: json["image_id"] == null ? null : json["image_id"],
    weight: json["weight"] == null ? null : json["weight"],
    weightUnit: json["weight_unit"] == null ? null : json["weight_unit"],
    inventoryItemId: json["inventory_item_id"] == null ? null : json["inventory_item_id"],
    inventoryQuantity: json["inventory_quantity"] == null ? null : json["inventory_quantity"],
    oldInventoryQuantity: json["old_inventory_quantity"] == null ? null : json["old_inventory_quantity"],
    requiresShipping: json["requires_shipping"] == null ? null : json["requires_shipping"],
    adminGraphqlApiId: json["admin_graphql_api_id"] == null ? null : json["admin_graphql_api_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_id": productId,
    "title": title,
    "price": price,
    "sku": sku,
    "position": position,
    "inventory_policy": inventoryPolicy,
    "compare_at_price": compareAtPrice,
    "fulfillment_service": fulfillmentService,
    "inventory_management": inventoryManagement == null ? null : inventoryManagement,
    "option1": option1,
    "option2": option2,
    "option3": option3,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "taxable": taxable,
    "barcode": barcode == null ? null : barcode,
    "grams": grams,
    "image_id": imageId,
    "weight": weight,
    "weight_unit": weightUnit,
    "inventory_item_id": inventoryItemId,
    "inventory_quantity": inventoryQuantity,
    "old_inventory_quantity": oldInventoryQuantity,
    "requires_shipping": requiresShipping,
    "admin_graphql_api_id": adminGraphqlApiId,
  };
}
