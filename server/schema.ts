import * as path from "path";
import * as allTypes from "./graphql";
import { makeSchema } from "nexus";

/**
 * Finally, we construct our schema (whose starting query type is the query
 * type we defined above) and export it.
 */
export const schema = makeSchema({
  types: allTypes,
  outputs: {
    schema: path.join(__dirname, "../modeling-errors-schema.graphql"),
    typegen: path.join(__dirname, "./modeling-errors-typegen.ts")
  },
  typegenAutoConfig: {
    sources: [
      {
        source: path.join(__dirname, "./types/backingTypes.ts"),
        alias: "shoppingCart"
      }
    ],
    contextType: "swapi.ContextType"
  }
});
