import { objectType } from "nexus";

export const Product = objectType({
  name: "Product",
  description: "A product.",
  definition(t) {
    t.dollars("price", {
      nullable: false,
      description: "The full product price."
    });
    t.productCode("code");
    t.string("description");
    t.productId("id");
    t.string("name", { description: "The product name." });
    t.string("imageUrl", { description: "Preview image for product." });
    t.float("averageRating", { description: "The average star rating." });
  }
});
