import { INITIAL_VIEWPORTS } from "@storybook/addon-viewport"
import "bulma/css/bulma.css"

export const parameters = {
  actions: { argTypesRegex: "^on[A-Z].*" },
  viewport: {
    viewports: INITIAL_VIEWPORTS
  }
}
