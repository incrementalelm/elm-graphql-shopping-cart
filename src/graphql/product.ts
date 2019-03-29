import { objectType } from "nexus";

export const Product = objectType({
  name: "Product",
  description: "A product.",
  definition(t) {
    t.int("price", {
      nullable: false,
      description: "The full product price."
    });
    t.productCode("code");
  }
});
