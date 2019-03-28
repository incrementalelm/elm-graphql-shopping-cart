import { objectType, arg, stringArg } from "nexus";

const paymentArgs = {
  discountCode: arg({
    type: "String",
    description: "Cardholder name",
    required: true
  })
};

export const Query = objectType({
  name: "Query",
  definition(t) {
    t.list.string("shoppingCartItems", () => ["elm-bonsai-tree"]);
    t.string("userid", () => "dillon");
    t.field("discountOrError", {
      type: "DiscountedProductInfoOrError",
      args: paymentArgs,
      // @ts-ignore
      resolve: (_, { discountCode }) => {
        switch (discountCode) {
          case "secret": {
            return { discountedPrice: 199, type: "DiscountedProductInfo" };
          }
          case "secret2": {
            return { discountedPrice: 149, type: "DiscountedProductInfo" };
          }
          case "merryxmas2018": {
            return { expiredAt: "abc", type: "DiscountExpired" };
          }
          case "discount": {
            return { reason: 2, type: "DiscountedLookupError" };
          }
          default: {
            return { type: "DiscountNotFound" };
          }
        }
      }
    });
    t.field("discount", {
      type: "DiscountedProductInfo",
      args: paymentArgs,
      resolve: (_, { discountCode }) => {
        switch (discountCode) {
          case "secret": {
            return { discountedPrice: 199 };
          }
          case "secret2": {
            return { discountedPrice: 149 };
          }
          case "merryxmas2018": {
            throw expired("12/31/2018", discountCode);
          }
          default: {
            throw notFound(discountCode);
          }
        }
      }
    });
  }
});

function expired(expirationDate: string, discountCode: string) {
  return new Error(
    `discountCode '${discountCode}' expired on ${expirationDate}`
  );
}

function notFound(discountCode: string) {
  return new Error(`Unrecognized discountCode '${discountCode}'!`);
}

function alreadyUsed(discountCode: string) {
  return new Error(
    `The discountCode '${discountCode}' has been used over the limit!`
  );
}
