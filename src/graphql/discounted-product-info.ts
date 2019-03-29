import { objectType } from "nexus";

export const DiscountedProductInfo = objectType({
  name: "DiscountedProductInfo",
  description: "The product information after applying a discount code.",
  definition(t) {
    t.dollars("discountedPrice", {
      nullable: false,
      description: "The discounted product price."
    });
    t.productCode("appliesTo");
  }
});
