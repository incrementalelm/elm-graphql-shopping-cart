import { objectType, arg, stringArg } from "nexus";

const paymentArgs = {
  discountCode: arg({
    type: "String",
    description: "Cardholder name",
    required: true
  })
};

const products = [
  {
    code: "bonsai",
    name: "Elm Bonsai Tree",
    price: 200,
    id: 1,
    description: "A lovely Japanese-style Elm Bonsai Tree!",
    imageUrl:
      "https://images-na.ssl-images-amazon.com/images/I/71ZQCpI8v2L._SX425_.jpg"
  },
  {
    code: "painting",
    name: "Elm Painting",
    price: 350,
    id: 2,
    description: "A lovely Japanese-style Elm Bonsai Tree!",
    imageUrl:
      "https://images.fineartamerica.com/images-medium-large-5/american-elm-tree-shweta-mahajan.jpg"
  },
  {
    code: "vintage-photo",
    name: "Vintage Elm Tree Photo",
    price: 50,
    id: 3,
    description: "A lovely Japanese-style Elm Bonsai Tree!",
    imageUrl:
      "https://upload.wikimedia.org/wikipedia/commons/1/19/Lovers%27_Elm%2C_Gwynne_estate%2C_Dufferin_Street.jpg"
  },
  {
    code: "seeds",
    name: "Elm Seeds",
    price: 20,
    id: 4,
    description: "A lovely Japanese-style Elm Bonsai Tree!",
    imageUrl:
      "https://upload.wikimedia.org/wikipedia/commons/7/76/Ulmus_glabra.jpg"
  }
];

export const Query = objectType({
  name: "Query",
  definition(t) {
    t.list.field("products", {
      type: "Product",
      resolve() {
        return Promise.resolve(products);
      }
    });
    t.field("product", {
      type: "Product",
      nullable: true,
      args: {
        id: arg({
          type: "ProductId",
          description: "The product to look up.",
          required: true
        })
      },
      resolve(_, { id }) {
        console.log("id", id.value);
        return Promise.resolve(
          products.find(product => product.id.toString() === id.value) || null
        );
      }
    });
    t.list.field("shoppingCartItems", {
      type: "Product",
      resolve() {
        return Promise.resolve([]);
      }
    });
    t.string("userid", () => "dillon");
    t.field("discountOrError", {
      type: "DiscountedProductInfoOrError",
      args: paymentArgs,
      // @ts-ignore
      resolve: (_, { discountCode }) => {
        switch (discountCode) {
          case "secret": {
            return {
              discountedPrice: 199,
              type: "DiscountedProductInfo",
              appliesTo: "painting"
            };
          }
          case "secret2": {
            return {
              discountedPrice: 149,
              type: "DiscountedProductInfo",
              appliesTo: "bonsai"
            };
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
            return { discountedPrice: 199, appliesTo: "painting" };
          }
          case "secret2": {
            return { discountedPrice: 149, appliesTo: "bonsai" };
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
