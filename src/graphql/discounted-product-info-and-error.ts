import * as nexus from "nexus";

export const DiscountedProductInfoAndError = nexus.objectType({
  name: "DiscountedProductInfoOrError",
  description:
    "The product information after applying a discount code. Be sure to check if there is an error!",
  definition(t) {
    t.int("discountedPrice", {
      nullable: false,
      description: "The discounted product price."
    });
  }
});
